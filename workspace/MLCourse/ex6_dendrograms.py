# needed imports
import os

import pandas as pd
from matplotlib import pyplot as plt
from scipy.cluster.hierarchy import cophenet
from scipy.cluster.hierarchy import dendrogram, linkage
from scipy.cluster.hierarchy import fcluster
from scipy.spatial.distance import pdist

# ---------------------------
# To make things simpler, please fill in the information below according to your group:
# ---------------------------

quality = 'messy'  # clean, dirty, messy
training_fraction = 85  # 50, 66, 85
realization = 2  # can be 0, 1, 2

# ---------------------------
# Load the data
# ---------------------------

training_file = os.path.join('decks', '300_' + quality + '_training_' + str(training_fraction) + '_log_' + str(
    realization) + '.csv')
df = pd.read_csv(training_file)

# generate the linkage matrix
X = df.as_matrix()


# Try 'single', 'complete', 'average'
# Distance metrics 'euclidian', 'cityblock', 'hamming', 'cosine'
methods= ['single', 'complete', 'average']
metrics = ['euclidean', 'cityblock', 'hamming', 'cosine']

for m in metrics:
    for meth in methods:
        Z = linkage(X, meth ,metric=m)
        c, coph_dists = cophenet(Z, pdist(X))
        print "Cophenet correlation should be close to 1 : {}_{}_{}".format(c,m,meth)
        
        plt.title('Hierarchical Clustering Dendrogram (truncated)')
        plt.xlabel('sample index or (cluster size)')
        plt.ylabel('distance')
        dendrogram(
            Z,
            truncate_mode='lastp',  # show only the last p merged clusters
            p=12,  # show only the last p merged clusters
            leaf_rotation=90.,
            leaf_font_size=12.,
            show_contracted=True,  # to get a distribution impression in truncated branches
        )
        fname = os.path.join('figs', 'dendogram_well_{}_{}'.format(m,meth))
        plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
                    transparent=True, pad_inches=0.01, bbox_inches='tight',
                    frameon=None)
        # Retrieving cluster
        
        max_d = 3
        d_clusters = fcluster(Z, max_d, criterion='distance')
        
        max_clusters = 8
        m_clusters = fcluster(Z, max_clusters, criterion='maxclust')
        
        plt.figure(figsize=(10, 8))
        x_dim = 0
        y_dim = 1
        plt.scatter(X[:, x_dim], X[:, y_dim], s=200, c=m_clusters, cmap='viridis',
                    alpha=1)  # plot points with cluster dependent colors
        fname = os.path.join('figs', 'hierarchical_well_lusters_vs_{}_{}_{}_{}'.format(df.columns[y_dim], df.columns[x_dim],m,meth))
        plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
                    transparent=True, pad_inches=0.01, bbox_inches='tight',
                    frameon=None)
