import os
import shutil

__title__ = "MatrixDemos"
__author__ = "NachoMonkey"
__version__ = "0.3"

# Put special data in your home directory
DATA_PATH = "/home/cfc" +"/.matrixdemos_data"

if not os.path.exists(DATA_PATH):
    os.mkdir(DATA_PATH)
    shutil.chown(DATA_PATH, os.getlogin())
