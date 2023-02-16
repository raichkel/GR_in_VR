from scipy.ndimage import geometric_transform
from numpy import pi, exp, arctanh, arctan, tan
from pylab import imread, imshow, roll, subplot, title, show, fliplr
import colour
import numpy as np

def RGB2wav(RGB):
    RGB_f = np.array(RGB)/255
    wl, xy_1, xy_2 = colour.convert(RGB_f, "Output-Referred RGB", "Dominant Wavelength")
    return abs(wl)
 
RGB = [235.0, 112.0, 155.0]

def wav2RGB(wavelength):
    w = int(wavelength)

    # colour
    if w >= 380 and w < 440:
        R = -(w - 440.) / (440. - 350.)
        G = 0.0
        B = 1.0
    elif w >= 440 and w < 490:
        R = 0.0
        G = (w - 440.) / (490. - 440.)
        B = 1.0
    elif w >= 490 and w < 510:
        R = 0.0
        G = 1.0
        B = -(w - 510.) / (510. - 490.)
    elif w >= 510 and w < 580:
        R = (w - 510.) / (580. - 510.)
        G = 1.0
        B = 0.0
    elif w >= 580 and w < 645:
        R = 1.0
        G = -(w - 645.) / (645. - 580.)
        B = 0.0
    elif w >= 645 and w <= 780:
        R = 1.0
        G = 0.0
        B = 0.0
    else:
        R = 0.0
        G = 0.0
        B = 0.0

    # intensity correction
    if w >= 380 and w < 420:
        SSS = 0.3 + 0.7*(w - 350) / (420 - 350)
    elif w >= 420 and w <= 700:
        SSS = 1.0
    elif w > 700 and w <= 780:
        SSS = 0.3 + 0.7*(780 - w) / (780 - 700)
    else:
        SSS = 0.0
    SSS *= 255

    return np.array([int(SSS*R), int(SSS*G), int(SSS*B)])



img = imread('./Mercator.jpg') # load an image
Ny = img.shape[0]
Nx = img.shape[1]
v = 0.9
boost = exp(arctanh(v))
print(img.shape)

def shift_func(coords):

 ##phi = coords[0]*2*pi/Nx
 theta = coords[0]*pi/Ny
 #phi_new = phi
 theta_new = 2*arctan(tan(theta/2)*boost)
 #x_new = int(phi_new*Nx/(2*pi))
 y_new = int(theta_new*Ny/pi)
 
 '''''
 RGB = np.array(coords[2])
 wavelength = RGB2wav(RGB)
 redshift = (1 + (tan(theta/2)**2))/(boost + ((tan(theta/2)**2)/boost))
 wavelength *= redshift
 RGB_new = wav2RGB(wavelength)
 '''''
 #redshift = (1 + (tan(theta/2)**2))/(boost + ((tan(theta/2)**2)/boost))

 return y_new, coords[1], coords[2]
    
r = geometric_transform(img,shift_func,cval=255,output_shape=(Ny,Nx,3))

subplot(1,2,1)
title('Projected Celestial Sphere')
imshow(img)
subplot(1,2,2)
title('Projected Celestial Sphere after Lorentz Transform')
imshow(r)
show()