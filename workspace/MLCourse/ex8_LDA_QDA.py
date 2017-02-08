""" Linear and Quadratic Discriminant Analaysis"""

import os

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sklearn.discriminant_analysis as DA
import sklearn.metrics as metrics

# ---------------------------
# To make things simpler, please fill in the information below according to your group:
# ---------------------------

quality = 'clean'  # clean, dirty, messy
training_fraction = 85  # 50, 66, 85
realization = 2  # can be 0, 1, 2

# ---------------------------
# Load the data
# ---------------------------

training_file = os.path.join('decks', '300_' + quality + '_training_' + str(training_fraction) + '_log_' + str(
    realization) + '.csv')
df_training = pd.read_csv(training_file)

testing_file = os.path.join('decks', '300_' + quality + '_testing_' + str(training_fraction) + '_log_' + str(
    realization) + '.csv')
df_testing = pd.read_csv(testing_file)

future_file = os.path.join('decks', '300_' + quality + '_future_' + str(training_fraction) + '_log_' + str(
    realization) + '.csv')
df_future = pd.read_csv(future_file)

features = ['x', 'y', 'z', 'phi', 'kx', 'ntg']
Xtrain = df_training[features]
Xtest = df_testing[features]
Xfuture = df_future[features]

output = 'facies'
Ytrain = df_training[output]
Ytest = df_testing[output]
Yfuture = df_future[output]

# clf = DA.LinearDiscriminantAnalysis()
clf = DA.QuadraticDiscriminantAnalysis()
clf.fit(Xtrain, Ytrain)

ytest = clf.predict(Xtest)
yfuture = clf.predict(Xfuture)
ytrain = clf.predict(Xtrain)

print metrics.accuracy_score(ytest, Ytest, normalize=False)
print metrics.accuracy_score(ytest, Ytest, normalize=True)
print metrics.classification_report(ytest, Ytest)
print metrics.confusion_matrix(ytest, Ytest)

# -- PLOT the expect facies profile of future wells

zz = df_future['z'].as_matrix()
well_name = df_future['name'].as_matrix()
future_facies = yfuture
well_list = np.unique(well_name)

data_index = well_name == 9
for wi in well_list[0:2]:
    plt.figure(figsize=(5, 15))
    data_index = well_name == wi
    plt.plot(future_facies[data_index], -zz[data_index], color='blue', linewidth=1, linestyle='-')
    plt.xlabel('Facies')
    plt.ylabel('Depth')
    plt.grid()
    axes = plt.gca()
    fname = os.path.join('figs', 'LDA_future_facies_log_{}'.format(wi))
    plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
                transparent=True, pad_inches=0.01, bbox_inches='tight',
                frameon=None)
