""" Random forest """

import os

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sklearn.metrics as metrics
from sklearn.ensemble import RandomForestClassifier

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

clf = RandomForestClassifier(n_estimators=100)
clf = clf.fit(Xtrain, Ytrain)

print 'calibrated'

ytest = clf.predict(Xtest)
yfuture = clf.predict(Xfuture)
ytrain = clf.predict(Xtrain)

print metrics.accuracy_score(ytest, Ytest, normalize=False)
print metrics.accuracy_score(ytest, Ytest, normalize=True)
print metrics.classification_report(ytest, Ytest)
print metrics.confusion_matrix(ytest, Ytest)

# Feature importance:
importances = clf.feature_importances_
std = np.std([tree.feature_importances_ for tree in clf.estimators_], axis=0)
indices = np.argsort(importances)[::-1]

# Print the feature ranking
axis_labels = []
print("Feature ranking:")
for f in range(Xtrain.shape[1]):
    axis_labels.append(features[indices[f]])
    print("{}. feature {}: {} ({})".format(f + 1, indices[f], features[indices[f]], importances[indices[f]]))

# Plot the feature importances of the forest
plt.figure()
plt.title("Feature importances")
plt.bar(range(Xtrain.shape[1]), importances[indices], color="r", yerr=std[indices], align="center")
plt.xticks(range(Xtrain.shape[1]), axis_labels)
plt.xlim([-1, Xtrain.shape[1]])
fname = os.path.join('figs', 'random_forest_sensitivity')
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

# Work on Grid Search
