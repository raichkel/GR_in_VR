import numpy as np
import matplotlib.pyplot as plt
import os
from matplotlib import image as img

directoryname = "greyscale"
list = os.listdir(directoryname)
savedirectory = "colourised"

for file in list:
    split_str = file.split("_")
    number = split_str[1]

    path = os.path.join(directoryname, file)
    
    image = np.array(img.imread(path))

    savepath = os.path.join(savedirectory, f"colour_frame_{number}")

    img.imsave(savepath, image, cmap="afmhot")

