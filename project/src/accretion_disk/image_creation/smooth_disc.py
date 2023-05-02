#Author: Joel Mills

# code to create smooth disk gradient image for use in simulation



# the radii in temps.csv are from 6.0 to 150.0 in steps of 0.02
# create grayscale (w. applied cmap) image of accretion disc where each pixel has its radius from the center computed and is filled in according 
# to the lookup table given by temps.txt. Trim and normalize the frequency spectrum accordingly to fit between 0.0 and 1.0 and 
# smoothly taper out to black at the outermost radius of the accretion disc.


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib

#read in precomputed data 
filename = "project/src/accretion_disk/temps.csv"
data = pd.read_csv(filename, sep=",", header=0)

#get frequencies, indexed in order of radius 
frequencies = np.array(data[data.columns[2]])

#set black level as the frequency at the outermost radius, then white level as the maximum frequency occurring
black_level = frequencies[-1]
white_level = max(frequencies)
frequencies = (frequencies - black_level)/(white_level - black_level) #normalise between range
#black out any negative values (i.e. those near the innermost radius with frequency less than the black level)
for e in range(len(frequencies)):
    if frequencies[e] < 0:
        frequencies[e] = 0.0


radii = np.array(data[data.columns[0]]) #get radii
dim_pixels = 15000
shape = (dim_pixels, dim_pixels)
canvas = np.zeros(shape) #initialise 15000*15000 canvas
midpoint = [int(dim_pixels), int(dim_pixels)] 
minimum = int(min(radii)*100) #get minimum and scale up by 100 so an integer for indexing
maximum = int(max(radii)*100) #get maximum and scale up by 100 so an integer for indexing


#for every pixel in canvas, get radius from center
#use 2*i not i since radial increments are 0.02 not 0.01
for i in range(dim_pixels):
    for j in range(dim_pixels):

        abs_x = np.abs((2*i)-midpoint[0])
        abs_y = np.abs((2*j)-midpoint[1])
        radius = int(np.sqrt(abs_x**2 + abs_y**2))

        #if radius lies in between innermost and outermost value, fill in pixel accordingly
        #note temps.txt doesn't begin at 0.0 but 6.0 so have to displace index
        if radius >= minimum and radius <= maximum:
            canvas[i][j] = frequencies[int((radius-minimum)/2)]


#make and save plots
matplotlib.image.imsave("project/src/pre_computation/images/smooth_disk.jpg", canvas, cmap="afmhot")
plt.imshow(canvas, cmap="afmhot")
plt.show()

