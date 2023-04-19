#Attempted code to unwrap an image of an accretion disc in cartesian coordinates such that the new image axes are the polar coordinates (Polar Unwrap)
#DON'T USE


import cv2  # used to load and show image
import numpy as np
from matplotlib import pyplot as plt


#Function to convert polar coordinates to cartesian, given a central point c
def convert(r, theta, c):
    x = r * np.cos(theta) + c[0]
    y = r * np.sin(theta) + c[1]
    return x, y


#Function to unwrap an image in polar coordinates 
def polar_remap(image, point, radians, min_radius, max_radius, CCW, flip):
    
    # 1) meshgrid parameter 1: Create an array with intervals from 0 to 2PI spread out over the Circumference of
    # circle.
    # 2) meshgrid parameter 2: Create an array with intervals from starting radius to final radius.
    # 3) theta, r = np.meshgrid(y,x) meshgrid returns 2 grids of angles and radius.
    # 4) Unwrap clockwise or counter-clockwise - Change angle interval in meshgrid from 0, 2PI to 2PI, 0
    # 5) Flip unwrap by setting radius start=min_radius, stop=max_radius, step = 1 OR start=max_radius, stop=min_radius, step = -1

    if(CCW):
      theta = np.linspace(2 * np.pi, 0, radians)[None, :].astype('float32')
    else:
      theta = np.linspace(0, 2 * np.pi, radians)[None, :].astype('float32')

    if(flip):
      r = np.arange(start=min_radius, stop=max_radius, step=1, dtype=int)[:,None].astype('float32')
    else:
      r = np.arange(start=max_radius, stop=min_radius, step=-1, dtype=int)[:,None].astype('float32')

    # Create X and Y maps for remap function. 
    x_map, y_map = convert(r, theta, point)

    dst = cv2.remap(image, x_map, y_map, cv2.INTER_LINEAR)

    return dst


img = cv2.imread('project\src\pre_computation\images\heic1913b.jpg', cv2.IMREAD_COLOR)  # read image from file
colourised =cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
pixels = np.array(colourised)


#specify parameters for unwrapping
Ny, Nx, RGB = img.shape
center = (Ny/2, Nx/2)
outer_radius = min(center)
inner_radius = 0.0 
circumference = int(2 * outer_radius * np.pi)  # calculate circumference of circle from radius variable.


# polar unwrap function
polar = polar_remap(colourised, center, circumference, inner_radius, outer_radius, CCW = False, flip = False)  


plt.imshow(polar)
plt.show()  # show unwrapped image in new window.