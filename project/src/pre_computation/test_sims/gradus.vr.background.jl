# Author: Fergus Baker, Joel Mills

using Gradus
using StaticArrays
using Images
using FileIO
using Plots
using PyCall
using Conda 

# making sure we have the colour module installed
Conda.add("colour")

py"""
import colour
import numpy as np

# function to convert RGB value to wavelength
def RGB2wav(RGB):
    RGB_f = np.array(RGB)/255
    wl, xy_1, xy_2 = colour.convert(RGB_f, "Output-Referred RGB", "Dominant Wavelength")
    return abs(wl)
"""

# function to convert wavelength to RGB value
function wav2RGB(wavelength)
    w = trunc(wavelength)
    # colour
    if (w >= 380 && w < 440)
        R = -(w - 440.) / (440. - 350.)
        G = 0.0
        B = 1.0
    elseif (w >= 440 && w < 490)
        R = 0.0
        G = (w - 440.) / (490. - 440.)
        B = 1.0
    elseif (w >= 490 && w < 510)
        R = 0.0
        G = 1.0
        B = -(w - 510.) / (510. - 490.)
    elseif (w >= 510 && w < 580)
        R = (w - 510.) / (580. - 510.)
        G = 1.0
        B = 0.0
    elseif (w >= 580 && w < 645)
        R = 1.0
        G = -(w - 645.) / (645. - 580.)
        B = 0.0
    elseif (w >= 645 && w <= 780)
        R = 1.0
        G = 0.0
        B = 0.0
    else
        R = 0.0
        G = 0.0
        B = 0.0
    end

    # intensity correction
    if (w >= 380 && w < 420)
        SSS = 0.3 + 0.7*(w - 350) / (420 - 350)
    elseif (w >= 420 && w <= 700)
        SSS = 1.0
    elseif (w > 700 && w <= 780)
        SSS = 0.3 + 0.7*(780 - w) / (780 - 700)
    else
        SSS = 0.0
    end

    RGB{N0f8}(SSS*R, SSS*G, SSS*B)
end



function velocity_vector(m, u, v)
    x = u[2] * sin(u[3]) * cos(u[4])
    y = u[2] * sin(u[3]) * sin(u[4])

    R = x^2 + y^2
    rdot = (x * v[1] + y * v[2]) / √R
    θdot = (x * v[2] - v[1] * y) / R
    Gradus.constrain_all(m, u, @SVector[1.0, rdot, θdot, 0.0], 1.0)
end



m = KerrMetric(M = 1.0, a = 0.0)
# coordinate: t    r      θ            ϕ          c
u = @SVector [0.0, 10.0, deg2rad(70), 0.0]
# disc:               r_in            r_out  ϕ_inc
d = GeometricThinDisc(Gradus.isco(m), 150.0, π/2)
#print(Gradus.isco(m))

# need a velocity prescription for the observer
# so a simple one is that the observer that is time-like stationary
gcomp = metric_components(m, u[2:3])
v_observer = inv(√(-gcomp[1])) * @SVector[1.0, 0.0, 0.0, 0.0]
v_observer = velocity_vector(m, u, [0.0, 0.0])



# φ₀, λ₀ (central parallel and meridian)
# φ₁ (standard parallels)
function inverse_equirectangular(x, y; φ₀ = 0, λ₀ = 0, φ₁ = 0, R = 1.0)
    λ = x / (R * cos(deg2rad(φ₁))) + λ₀
    φ = y / R + φ₀
    mod2pi.((deg2rad(φ), deg2rad(λ)))
end

# output image dimensions (y, x)
scale = 5
dim = (180, 360) .* scale

angle_pairs = [inverse_equirectangular(x, y; R = scale) for y in 1:dim[1], x in 1:dim[2]]
vs = [Gradus.sky_angles_to_velocity(m, u, v_observer, -θ, ϕ) for (θ, ϕ) in angle_pairs]
us = fill(u, size(vs))

# don't save the full solution cus that's a lot of memory
sols = @time tracegeodesics(m, us, vs, d, (0.0, 2000.0); save_on = false)

# get the redshift function we want to use
redshift_func = ConstPointFunctions.redshift(m, u)
points = process_solution.(m, sols.u)

# load in the image and work out the midpoint
image_file = "project/src/pre_computation/images/blank_disc.jpg"
disc_image = load(image_file)
image_y, image_x = size(disc_image)
image_y_mid = image_y ÷ 2
image_x_mid = image_x ÷ 2

image_file2 = "project/src/pre_computation/images/space.png"
stars = load(image_file2)
dim_y, dim_x = size(stars)

#your input array should have elements within this range of visible wavelengths (nm)
#but, image files are automatically normalized between 0 and 1 
max_wavelength = 780.
min_wavelength = 380.

# populate the output image
image = zeros(RGB, dim)
for i in eachindex(image)
    p = points[i]
    value = RGB{N0f8}(0.0,0.0,0.0)

    if (p.status == StatusCodes.IntersectedWithGeometry)

        r, ϕ = p.u2[2], p.u2[4]
        # scale r between 0 and 2
        x = cos(ϕ) * r / d.outer_radius + 1
        y = sin(ϕ) * r / d.outer_radius + 1
        # add 1 since julia arrays begin at 1
        xi = trunc(Int, x * image_x_mid) + 1
        yi = trunc(Int, y * image_y_mid) + 1

        g = redshift_func(m, p, 0.0)
        wavelength = (float(disc_image[yi, xi])*(max_wavelength-min_wavelength) + min_wavelength)*g
        ###r = float(red(disc_image[yi, xi]))
        ##g = float(green(disc_image[yi, xi]))
        #b = float(blue(disc_image[yi, xi]))
        value = wav2RGB(wavelength)

    elseif (p.status == StatusCodes.OutOfDomain)

        θ, ϕ = p.u2[3], p.u2[4]
        yi = ceil(Int, (mod2pi(θ)/(2*pi))*dim_y)
        xi = ceil(Int, (mod2pi(ϕ)/(2*pi))*dim_x)
        r = float(red(stars[yi, xi]))
        g = float(green(stars[yi, xi]))
        b = float(blue(stars[yi, xi]))
        value = RGB{N0f8}(r, g, b)
    end

    image[i] = value
end


# y is flipped, so reverse along that axis
save("colourized7.png", reverse(image; dims = 1))