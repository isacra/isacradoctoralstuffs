""" Dimensionality reduction """
import os

import matplotlib.pyplot as plt
import pandas as pd
import sklearn.decomposition as decomposition
import sklearn.manifold as mnf
from scipy.spatial import distance

from mpl_toolkits.mplot3d import Axes3D

# ---------------------------
# To make things simpler, please fill in the information below according to your group:
# ---------------------------

quality = 'messy'  # clean, dirty, messy
training_fraction = 85  # 50, 66, 85
realization = 2  # can be 0, 1, 2

# ---------------------------
# Load the data
# ---------------------------

training_file = os.path.join('decks', '300_' + quality + '_training_' + str(training_fraction) + '_well_' + str(
    realization) + '.csv')
df = pd.read_csv(training_file)

# Important: select the features for the initial space
selected_features = ['avg_phi', 'avg_net', 'facies_4', 'x', 'y']
X = df[selected_features]
target = df[['total_prod']]

# Perform Principal Component Analysis
pca = decomposition.PCA(n_components=3)
X_pca = pca.fit_transform(X)
X_back_pca = pca.inverse_transform(X_pca)

# Precision metrcsi:
print "Explained variance ratio : {}".format(pca.explained_variance_ratio_)
print "Precision matrix\n{}".format(pca.get_precision())
print "Components\n{}".format(pca.components_)

fig = plt.figure(figsize=(8, 6))
ax = Axes3D(fig, elev=-150, azim=110)
ax.scatter(X_pca[:, 0], X_pca[:, 1], X_pca[:, 2], c=target, cmap=plt.cm.Paired)
ax.set_title("First three PCA directions")
ax.set_xlabel("1st eigenvector")
ax.w_xaxis.set_ticklabels([])
ax.set_ylabel("2nd eigenvector")
ax.w_yaxis.set_ticklabels([])
ax.set_zlabel("3rd eigenvector")
ax.w_zaxis.set_ticklabels([])
fname = os.path.join('figs', 'PCA_components')
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

# ------------ YOUR TURN!

selected_features = ['avg_phi', 'avg_net', 'avg_kx', 'facies_4','total_prod', 'x', 'y']
X = df[selected_features]
pca = decomposition.PCA(n_components=3)
X_pca = pca.fit_transform(X)
X_back_pca = pca.inverse_transform(X_pca)

ig = plt.figure(figsize=(8, 6))
ax = Axes3D(fig, elev=-150, azim=110)
ax.scatter(X_pca[:, 0], X_pca[:, 1], X_pca[:, 2], c=target, cmap=plt.cm.Paired)
ax.set_title("First three PCA directions")
ax.set_xlabel("1st eigenvector")
ax.w_xaxis.set_ticklabels([])
ax.set_ylabel("2nd eigenvector")
ax.w_yaxis.set_ticklabels([])
ax.set_zlabel("3rd eigenvector")
ax.w_zaxis.set_ticklabels([])
fname = os.path.join('figs', 'PCA_components_complet')
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

X = X.as_matrix()
for dim in range(5):
    plt.figure(figsize=(12, 6))
    dim = 0  # Try other dimensions
    #
    plt.subplot(121)
    plt.scatter(X[:, dim], X_back_pca[:, dim], s=100, c='r', alpha=.5)
    axes = plt.gca()
    xx = axes.get_xlim()
    yy = axes.get_ylim()
    plt.plot(xx, yy, color='k')
    axes.set_xlim(xx)
    axes.set_ylim(yy)
    plt.grid()
    plt.xlabel('Original {}'.format(selected_features[dim]))
    plt.ylabel('PCA {}'.format(selected_features[dim]))
    fname = os.path.join('figs', 'PCA_Comparison_Data_{}'.format(selected_features[dim]))
    plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

#
#  Work on Kernel PCA

kpca = decomposition.KernelPCA(kernel="rbf", n_components=3, fit_inverse_transform=True, gamma=5)
X_kpca = kpca.fit_transform(X)
X_back_kpca = kpca.inverse_transform(X_kpca)

fig = plt.figure(figsize=(8, 6))
ax = Axes3D(fig, elev=-150, azim=110)
ax.scatter(X_kpca[:, 0], X_kpca[:, 1], X_kpca[:, 2], c=target, cmap=plt.cm.Paired)
ax.set_title("First three K-PCA directions")
ax.set_xlabel("1st eigenvector")
ax.w_xaxis.set_ticklabels([])
ax.set_ylabel("2nd eigenvector")
ax.w_yaxis.set_ticklabels([])
ax.set_zlabel("3rd eigenvector")
ax.w_zaxis.set_ticklabels([])
fname = os.path.join('figs', 'KPCA_components')
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

# Independent component analysis using FastICA
ipca = decomposition.FastICA(n_components=3)
X_ipca = ipca.fit_transform(X)
X_back_ipca = ipca.inverse_transform(X_ipca)
plt.figure(figsize=(12, 6))
dim = 0  # Try other dimensions
#X = X.as_matrix()
plt.subplot(121)
plt.scatter(X[:, dim], X_back_pca[:, dim], s=100, c='r', alpha=.5)
axes = plt.gca()
xx = axes.get_xlim()
yy = axes.get_ylim()
plt.plot(xx, yy, color='k')
axes.set_xlim(xx)
axes.set_ylim(yy)
plt.grid()
plt.xlabel('Original {}'.format(selected_features[dim]))
plt.ylabel('PCA {}'.format(selected_features[dim]))

plt.subplot(122)
plt.scatter(X[:, dim], X_back_ipca[:, dim], s=100, c='b', alpha=.5)
axes = plt.gca()
xx = axes.get_xlim()
yy = axes.get_ylim()
plt.plot(xx, yy, color='k')
axes.set_xlim(xx)
axes.set_ylim(yy)
plt.grid()
plt.xlabel('Original {}'.format(selected_features[dim]))
plt.ylabel('I-PCA {}'.format(selected_features[dim]))
fname = os.path.join('figs', 'PCA_iPCA_dim {}'.format(selected_features[dim]))
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)


# -----------------
# MDS
# -----------------
similarities=distance.euclidean(df[selected_features])
mds=mnf.MDS()
mds.fit_transform(df[selected_features])
pos = mds.fit(similarities).embedding_
