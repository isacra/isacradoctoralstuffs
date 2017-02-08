""" Exercise on clustering algorithms """

import os
from time import time

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sklearn.decomposition as decomposition
from sklearn import metrics
from sklearn.cluster import KMeans

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

features = df[['avg_phi', 'facies_4', 'avg_kx']]
n_clus = 4
y_pred = KMeans(n_clusters=n_clus).fit_predict(features)

plt.figure()
x_dim = 'avg_phi'
y_dim = 'facies_4'
plt.scatter(features[x_dim], features[y_dim], c=y_pred)
plt.title("K-means Clustering: {} clusters".format(n_clus))
plt.xlabel(x_dim)
plt.ylabel(y_dim)
fname = os.path.join('figs', 'clusters_{}_vs_{}_{}'.format(y_dim, x_dim, n_clus))
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

plt.figure()
x_dim = 'avg_kx'
y_dim = 'total_prod'
plt.scatter(df[x_dim], df[y_dim], c=y_pred)
plt.title("K-means Clustering: {} clusters".format(n_clus))
plt.xlabel(x_dim)
plt.ylabel(y_dim)
fname = os.path.join('figs', 'clusters_{}_vs_{}_{}'.format(y_dim, x_dim, n_clus))
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

# Perform Principal Component Analysis
# Features to keep in the PCA:
pca_selected_features = ['avg_phi', 'avg_net', 'avg_phi', 'facies_4', 'x', 'y', 'total_prod']
pca = decomposition.PCA(n_components=3)
X_pca = pca.fit_transform(df[pca_selected_features])
# Cluster in the PCA space
y_pred_pca = KMeans(n_clusters=n_clus).fit_predict(X_pca)

# Plot
plt.figure()
x_dim = 'avg_phi'
y_dim = 'facies_4'
plt.scatter(features[x_dim], features[y_dim], c=y_pred_pca)
plt.title("PCA K-means Clustering: {} clusters".format(n_clus))
plt.xlabel(x_dim)
plt.ylabel(y_dim)
fname = os.path.join('figs', 'clustersPCA__{}_vs_{}_{}'.format(y_dim, x_dim, n_clus))
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

plt.figure()
x_dim = 'avg_kx'
y_dim = 'total_prod'
plt.scatter(df[x_dim], df[y_dim], c=y_pred_pca)
plt.title("PCA K-means Clustering: {} clusters".format(n_clus))
plt.xlabel(x_dim)
plt.ylabel(y_dim)
fname = os.path.join('figs', 'clustersPCA__{}_vs_{}_{}'.format(y_dim, x_dim, n_clus))
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

# --- ON LOG ---

training_file = os.path.join('decks', '300_' + quality + '_training_' + str(training_fraction) + '_log_' + str(
    realization) + '.csv')
df = pd.read_csv(training_file)

features = df[['phi', 'kx', 'x', 'y', 'z']]
target = df['facies']

n_samples, n_features = features.shape
n_digits = len(np.unique(target))
labels = target.as_matrix()

y_pred_log = KMeans(n_clusters=n_digits).fit_predict(features)

# Plot
plt.figure()
x_dim = 'phi'
y_dim = 'kx'
y_dim = 'z'
plt.scatter(features[x_dim], target, c=y_pred_log)
plt.title("Log K-means Clustering: {} clusters".format(n_clus))
plt.xlabel(x_dim)
plt.ylabel(y_dim)
fname = os.path.join('figs', 'clusters_logs_{}_vs_{}_{}'.format(y_dim, x_dim, n_clus))
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

print("n_digits: %d, \t n_samples %d, \t n_features %d"
      % (n_digits, n_samples, n_features))

print(79 * '_')
print('% 9s' % 'init'
               '         time    inertia   homogeneity compl  v-meas   ARI     AMI')

plt.figure()
x_dim = 'phi'
y_dim = 'z'
#y_dim = 'z'
plt.scatter(features[x_dim],features[y_dim], c=y_pred_log)
plt.title("Log K-means Clustering: {} clusters".format(n_clus))
plt.xlabel(x_dim)
plt.ylabel(y_dim)
fname = os.path.join('figs', 'clusters_logs_{}_vs_{}_{}'.format(y_dim, x_dim, n_clus))
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)


pca_selected_features = ['phi', 'kx', 'x', 'y', 'z']
pca = decomposition.PCA(n_components=3)
X_pca = pca.fit_transform(df[pca_selected_features])
# Cluster in the PCA space
y_pred_log_pca =  KMeans(n_clusters=n_clus).fit_predict(X_pca)

plt.figure()
x_dim = 'phi'
y_dim = 'z'
#y_dim = 'z'
plt.scatter(features[x_dim],features[y_dim], c=y_pred_log_pca)
plt.title("Log K-means Clustering PCA: {} clusters".format(n_clus))
plt.xlabel(x_dim)
plt.ylabel(y_dim)
fname = os.path.join('figs', 'clusters_logs_PCA_{}_vs_{}_{}'.format(y_dim, x_dim, n_clus))
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)


def bench_k_means(estimator, name, data):
    t0 = time()
    estimator.fit(data)
    print('% 9s   %.2fs    %i   %.3f   %.3f   %.3f   %.3f   %.3f'
          % (name, (time() - t0), estimator.inertia_,
             metrics.homogeneity_score(labels, estimator.labels_),
             metrics.completeness_score(labels, estimator.labels_),
             metrics.v_measure_score(labels, estimator.labels_),
             metrics.adjusted_rand_score(labels, estimator.labels_),
             metrics.adjusted_mutual_info_score(labels, estimator.labels_)))


bench_k_means(KMeans(init='k-means++', n_clusters=n_digits, n_init=10),
              name="k-means++", data=features)

bench_k_means(KMeans(init='random', n_clusters=n_digits, n_init=10),
              name="random", data=features)
