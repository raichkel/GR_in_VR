# Author: Rachel Kane, Joel Mills
# file to colourise wormhole frames using 'bone' colourmap
import numpy as np
import matplotlib.pyplot as plt
import os
from matplotlib import image as img
import re

# function to sort a list of file names in numerical order
numbers = re.compile(r'(\d+)')
def numericalSort(value):
    parts = numbers.split(value)
    parts[1::2] = map(int, parts[1::2])
    return parts

directoryname = "colouriser/wormhole"
list = sorted(os.listdir(directoryname), key=numericalSort)

savedirectory = "colouriser/colourised_wormhole"

# reading in and colourising all files, ensuring that they are named as consecutive numbers
# necessary for video creation step
count = 1
for file in list:

    path = os.path.join(directoryname, file)

    image = np.array(img.imread(path))

    savepath = os.path.join(savedirectory, f"colour_frame_wormhole_{count}.png")

    img.imsave(savepath, image, cmap="bone")
    count += 1





