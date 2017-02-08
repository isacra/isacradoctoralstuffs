""" Support Vector Machines"""

import os

import matplotlib.pyplot as plt
import pandas as pd
import sklearn.svm as svm

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

print df_training.columns
features = ['avg_phi', 'facies_4']
Xtrain = df_training[features]
Xtest = df_testing[features]
Xfuture = df_future[features]

output = 'total_prod'
Ytrain = df_training[output]
Ytest = df_testing[output]
Yfuture = df_future[output]

clf = svm.NuSVR()
clf.fit(Xtrain, Ytrain)

ytest = clf.predict(Xtest)
yfuture = clf.predict(Xfuture)
ytrain = clf.predict(Xtrain)

x_dim = 'avg_phi'
y_dim = 'avg_kx'
# x_dim='x'
# y_dim='y'
plt.figure(figsize=(10, 10), edgecolor='w', facecolor='w')
plt.scatter(df_training[x_dim], df_training[y_dim], marker='o', s=100, c=ytrain, edgecolors='k', cmap='rainbow',
            alpha=1)
plt.scatter(df_testing[x_dim], df_testing[y_dim], marker='s', s=100, c=ytest, edgecolors='k', cmap='rainbow', alpha=1)
plt.scatter(df_future[x_dim], df_future[y_dim], marker='*', s=200, c=yfuture, edgecolors='k', cmap='rainbow', alpha=1)
plt.title("SVM Well Regressions")
fname = os.path.join('figs', 'SVM_{}_{}_training_testing'.format(x_dim, y_dim))
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)
