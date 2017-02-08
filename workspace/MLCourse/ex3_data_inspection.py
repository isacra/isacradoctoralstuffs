""" First look at the Well Data used in Machine-Learning """
import os

import pandas as pd
from matplotlib import pyplot as plt

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
testing_file = os.path.join('decks', '300_' + quality + '_testing_' + str(training_fraction) + '_well_' + str(
    realization) + '.csv')
future_file = os.path.join('decks', '300_' + quality + '_future_' + str(training_fraction) + '_well_' + str(
    realization) + '.csv')

df_training = pd.read_csv(training_file)
df_testing = pd.read_csv(testing_file)
df_future = pd.read_csv(future_file)

# ---------------------------
# Console inspection
# ---------------------------

print df_training

# Print data properties
print df_training.columns

# Statistics on the properties: "describe"
print df_training.describe()

# Interactions between pandas and numpy: np.mean(df['phi'])

# Access one record, one slice...

# How many points?

# ---------------------------
#  Plot a map of wells, colored by their avg_phi
# ---------------------------

plt.figure(figsize=(12, 12))
plt.scatter(df_training['x'], df_training['y'], s=200, c=df_training['avg_phi'], alpha=.5)
plt.scatter(df_testing['x'], df_testing['y'], s=200, c=[.5, .5, .5], alpha=.5)
plt.xlim(min(df_training['x']) - 50, max(df_training['x']) + 50)
plt.ylim(min(df_training['y']) - 50, max(df_training['y']) + 50)
fname = os.path.join('figs', 'well_maps_avgphi')
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

# ---------------------------
# Now work on well logs
# ---------------------------

training_file = os.path.join('decks', '300_' + quality + '_training_' + str(training_fraction) + '_log_' + str(
    realization) + '.csv')

df_log = pd.read_csv(training_file)
one_well_mask = df_log['name'] == 6
one_well = df_log[one_well_mask]

plt.figure(figsize=(5, 15))
plt.plot(one_well.phi, -one_well.z, color='blue', linewidth=1, linestyle='-')
plt.xlabel('Porosity')
plt.ylabel('Depth')
plt.grid()
axes = plt.gca()
axes.set_xlim([0, .3])
fname = os.path.join('figs', 'onewell_porosity_log')
plt.savefig(fname, dpi='figure', facecolor='w', edgecolor='w',
            transparent=True, pad_inches=0.01, bbox_inches='tight',
            frameon=None)

print one_well.describe()

print "-" * 79 + "\nDone"
plt.show()
