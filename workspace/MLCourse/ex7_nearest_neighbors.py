import os

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sklearn.metrics as metrics
from sklearn import neighbors

# ---------------------------
# To make things simpler, please fill in the information below according to your group:
# ---------------------------

quality = 'clean'  # clean, dirty, messy
training_fraction = 85  # 50, 66, 85
realization = 2  # can be 0, 1, 2

# ---------------------------
# Load the data
# ---------------------------

training_file = os.path.join('decks', '300_' + quality + '_training_' + str(training_fraction) + '_well_' + str(
    realization) + '.csv')
df_training = pd.read_csv(training_file)
testing_file = os.path.join('decks', '300_' + quality + '_testing_' + str(training_fraction) + '_well_' + str(
    realization) + '.csv')
df_testing = pd.read_csv(testing_file)
future_file = os.path.join('decks', '300_' + quality + '_future_' + str(training_fraction) + '_well_' + str(
    realization) + '.csv')
df_future = pd.read_csv(future_file)

n_neighbors = 15

features = ['x', 'y']
# features=['avg_phi', 'avg_net', 'facies_4', 'x', 'y']
Xtrain = df_training[features]
Xtest = df_testing[features]
Xfuture = df_future[features]

output = ['total_prod']
Ytrain = df_training[output]
Ytest = df_testing[output]
Yfuture = df_future[output]

h = 10.  # step size in the mesh

# for weights in ['uniform', 'distance']:
for weights in ['uniform']:
    # we create an instance of Neighbours Classifier and fit the data.
    clf = neighbors.KNeighborsRegressor(n_neighbors, weights=weights)
    clf.fit(Xtrain, Ytrain)

    # point in the mesh [x_min, x_max]x[y_min, y_max].
    x_min, x_max = Xtrain['x'].min() - h, Xtrain['x'].max() + h
    y_min, y_max = Xtrain['y'].min() - h, Xtrain['y'].max() + h
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
    Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])

    ytest = clf.predict(Xtest)
    yfuture = clf.predict(Xfuture)

    plt.figure(figsize=(10, 10), edgecolor='w', facecolor='w')
    plt.scatter(Xtrain['x'], Xtrain['y'], marker='o', s=100, c=Ytrain, edgecolors='k', cmap='cool', alpha=1)
    plt.scatter(Xtest['x'], Xtest['y'], marker='o', s=100, c=ytest, edgecolors='none', cmap='cool', alpha=1)
    plt.scatter(Xfuture['x'], Xfuture['y'], marker='s', s=200, c=yfuture, edgecolors='none', cmap='cool', alpha=1)
    plt.xlim(0, 1000)
    plt.ylim(0, 1000)
    plt.title("Well regression (k = %i, weights = '%s')" % (n_neighbors, weights))
    fname = os.path.join('figs', 'nearest_neigh_X_Y_training_testing_{}'.format(weights))
    plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
                transparent=True, pad_inches=0.01, bbox_inches='tight',
                frameon=None)

    # Put the result into a color plot
    Z = Z.reshape(xx.shape)
    plt.figure(figsize=(10, 10), edgecolor='w', facecolor='w')
    plt.pcolormesh(xx, yy, Z, cmap='cool')
    plt.scatter(Xtrain['x'], Xtrain['y'], marker='o', s=100, c=Ytrain, edgecolors='k', cmap='cool', alpha=1)
    plt.scatter(Xtest['x'], Xtest['y'], marker='o', s=100, c=ytest, edgecolors='none', cmap='cool', alpha=1)
    plt.scatter(Xfuture['x'], Xfuture['y'], marker='s', s=200, c=yfuture, edgecolors='k', cmap='cool', alpha=1)
    plt.title("3-Class classification (k = %i, weights = '%s')" % (n_neighbors, weights))
    plt.xlim(0, 1000)
    plt.ylim(0, 1000)
    fname = os.path.join('figs', 'nearest_neigh_X_Y_training_decision_testing_{}'.format(weights))
    plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
                transparent=True, pad_inches=0.01, bbox_inches='tight',
                frameon=None)

    # Plot only the training points

# Regression metrics
print "MAE {}".format(metrics.mean_absolute_error(y_pred=ytest, y_true=Ytest))
print "RMSE {}".format(metrics.mean_squared_error(y_pred=ytest, y_true=Ytest))
print "R2 {}".format(metrics.r2_score(y_pred=ytest, y_true=Ytest))
print "Explained variance {}".format(metrics.explained_variance_score(y_pred=ytest, y_true=Ytest))
