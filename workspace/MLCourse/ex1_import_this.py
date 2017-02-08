""" Test to ensure that all base packages are installed and up-to-date """

import sys

import bokeh
import matplotlib as plt
import numpy as np
import sklearn

print "Python version \t: {}".format(sys.version)
print "Numpy version \t: {} ".format(np.__version__)
print "Scikit-learn version \t: {} ".format(sklearn.__version__)
print "Matplotlib version \t: {} ".format(plt.__version__)
print "Bokeh version \t: {} ".format(bokeh.__version__)
