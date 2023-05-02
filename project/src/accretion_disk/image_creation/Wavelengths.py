#Author: Joel Mills

# Test code to take a grayscale image, remap the [0,1] values between some visible wavelength range,
# then use Bruton's algorithm to convert these to their approximate RGB values
# DON'T USE --- Bruton's Algorithm is good but the colours it maps to are too simplistic & saturated

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib


#Function to convert wavelength to RGB (Bruton's Algorithm)
def wav2RGB(wavelength):
    w = int(wavelength)
    # colour
    if (w >= 380 and w < 440):
        R = -(w - 440.) / (440. - 350.)
        G = 0.0
        B = 1.0
    elif (w >= 440 and w < 490):
        R = 0.0
        G = (w - 440.) / (490. - 440.)
        B = 1.0
    elif (w >= 490 and w < 510):
        R = 0.0
        G = 1.0
        B = -(w - 510.) / (510. - 490.)
    elif (w >= 510 and w < 580):
        R = (w - 510.) / (580. - 510.)
        G = 1.0
        B = 0.0
    elif (w >= 580 and w < 645):
        R = 1.0
        G = -(w - 645.) / (645. - 580.)
        B = 0.0
    elif (w >= 645 and w <= 780):
        R = 1.0
        G = 0.0
        B = 0.0
    else:
        R = 0.0
        G = 0.0
        B = 0.0

    # intensity correction
    if (w >= 380 and w < 420):
        SSS = 0.3 + 0.7*(w - 350) / (420 - 350)
    elif (w >= 420 and w <= 700):
        SSS = 1.0
    elif (w > 700 and w <= 780):
        SSS = 0.3 + 0.7*(780 - w) / (780 - 700)
    else:
        SSS = 0.0
    
    return SSS*R, SSS*G, SSS*B


# target range of wavelengths
min_visible = 590.0 #nm
max_visible = 780.0 #nm
length_visible = max_visible - min_visible


path = "project/src/pre_computation/images/smoky.jpg"
wavelengths = plt.imread(path) #read in grayscale image
min_wave = np.min(wavelengths)
max_wave = np.max(wavelengths)
length_λ = max_wave - min_wave


# convert grayscale pixel value from [0,1] to target range of wavelengths 
length_ratio = length_λ/length_visible
λ_diff = wavelengths - min_wave
new_wavelengths = λ_diff*(1/length_ratio) + min_visible

(dimx, dimy, dimRGB) = np.shape(new_wavelengths)


#initialise empty canvas
canvas = np.zeros(np.shape(new_wavelengths))


#convert each grayscale 'wavelength' pixel to an RGB pixel
for i in range(dimx):
    for j in range(dimy):
        R, G, B = wav2RGB(float(new_wavelengths[i][j][0]))
        canvas[i][j][0] = R
        canvas[i][j][1] = G
        canvas[i][j][2] = B


#save plots
plt.imshow(canvas)
matplotlib.image.imsave("project/src/pre_computation/images/coloured_wavelengths.jpg", canvas)
plt.show()
