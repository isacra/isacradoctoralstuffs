""" Test to ensure that all base packages are installed and up-to-date """
# !/usr/bin/env ipython

import sys

print "Python version \t: {}".format(sys.version)

# Create the "figs" directory, used in many exercises
import os

if not os.path.isdir('figs'):
    os.makedirs('figs')

# Testing numpy
# --------------

try:
    import numpy as np

    print "Numpy version : {} ".format(np.__version__)
    np.random.seed(1234567)
    random_values = np.random.random(1000)

except ImportError:
    print "Could not import numpy"
    print "Try running this : \npip install numpy"

# Testing pandas
# --------------

try:
    import pandas as pd

    print "Pandas version : {} ".format(pd.__version__)
    df = pd.DataFrame({'colA': [1, 2, 3, 4], 'colB': [5, 6, 7, 8]})
    print df

except ImportError:
    print "Could not import pandas"
    print "Try running this : \npip install pandas"

# Testing matplotlib
# --------------

try:
    import matplotlib

    print "Matplotlib version : {} ".format(matplotlib.__version__)
    from matplotlib import pyplot as plt

    matplotlib.pyplot.figure(figsize=(6, 6))
    xx = np.random.random(50)
    yy = np.random.random(50)
    zz = xx * yy
    plt.scatter(xx, yy, s=200, c=zz, cmap='prism', alpha=.8)
    plt.savefig('figs/ex1_test_figure', dpi='figure', facecolor='w', edgecolor='w',
                transparent=True, pad_inches=0.01, bbox_inches='tight',
                frameon=None)
    print "Figure saved to file figs/ex1_test_figure"

except ImportError:
    print "Could not import matplotlib"
    print "Try running this : \npip install matplotlib"

# Testing sklearn
# --------------

try:
    import sklearn

    print "Scikit-learn version : {} ".format(sklearn.__version__)
except ImportError:
    print "Could not import sklearn"
    print "Try running this : \npip install sklearn"

# Testing bokeh (optional)
# ------------------------

try:
    import bokeh

    print "Bokeh version : {} ".format(bokeh.__version__)
except ImportError:
    print "Could not import bokeh"
    print "Try running this : \npip install bokeh"

# all good
# --------------
print "*" * 79
print "Congratulations - you are ready to proceed with the class!"
print "*" * 79

# plt.show()
