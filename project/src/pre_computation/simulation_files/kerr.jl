# Author: Fergus Baker, Rachel Kane, Joel Mills

using FileIO
using Plots
using Gradus
using StaticArrays
using Images

################################################################################################################
# File to generate individual frames for the VR simulation
# Kerr black hole (spinning)
# runs using the runner.jl file and command line arguments for u (observer's position 4-vector), and 
# v (observer's 4_velocity). Scale (approximately resolution) is hard-coded to 7.
# Outputs a .png equirectangular image at u, v.
###############################################################################################################




function velocity_vector(m, u, v)
    # define velocity vector
    x = u[2] * sin(u[3]) * cos(u[4])
    y = u[2] * sin(u[3]) * sin(u[4])

    R = x^2 + y^2
    rdot = (x * v[1] + y * v[2]) / √R
    θdot = (x * v[2] - v[1] * y) / R
    Gradus.constrain_all(m, u, @SVector[1.0, rdot, θdot, 0.0], 1.0)
end

# change a for a Kerr black hole
m = KerrMetric(M = 1.0, a = 0.998)
# coordinate: t     r      θ       ϕ          
u = @SVector [t, r, θ, φ]
# get the redshift function we want to use
redshift_func = ConstPointFunctions.redshift(m, u)

# define inner and outer radii
r_in = Gradus.isco(m)
r_out = (r_in/6.0)*150.0

# disc:               r_in            r_out  ϕ_inc
d = GeometricThinDisc(Gradus.isco(m), 150.0, π/2)
#print(Gradus.isco(m))

# need a velocity prescription for the observer
# so a simple one is that the observer that is time-like stationary
gcomp = metric_components(m, u[2:3])
# static observer so as to avoid relativistric beaming
v_observer = inv(√(-gcomp[1])) * @SVector[1.0, 0.0, 0.0, 0.0]
#v_observer = velocity_vector(m, u, [0.0, 0.0])
# v_observer = @SVector [v1, v2, v3, v4]




# φ₀, λ₀ (central parallel and meridian)
# φ₁ (standard parallels)
function inverse_equirectangular(x, y; φ₀ = 0, λ₀ = 0, φ₁ = 0, R = 1.0)
    λ = x / (R * cos(deg2rad(φ₁))) + λ₀
    φ = y / R + φ₀
    mod2pi.((deg2rad(φ), deg2rad(λ)))
end



# output image dimensions (y, x)
scale = 7
dim = (180, 360) .* scale

angle_pairs = [inverse_equirectangular(x, y; R = scale) for y in 1:dim[1], x in 1:dim[2]]
vs = [Gradus.sky_angles_to_velocity(m, u, v_observer, -θ, ϕ) for (θ, ϕ) in angle_pairs]
us = fill(u, size(vs))

# don't save the full solution as that's a lot of memory
sols = @time tracegeodesics(m, us, vs, d, (0.0, 2000.0); save_on = false)

points = process_solution.(m, sols.u)

# load in the image and work out the midpoint
image_file = "project/src/pre_computation/blank_disc.jpg"
disc_image = Gray.(load(image_file))
image_y, image_x = size(disc_image)
image_y_mid = image_y ÷ 2
image_x_mid = image_x ÷ 2

#sample some radii & average over keplerian angular velocity for each (w.respect to affine time)
samples = range(r_in, r_out, 10)
let Omega = 0.0
    for i in 1:10
        radius = samples[i]
        vdisc = CircularOrbits.fourvelocity(m, radius)
        Omega += 0.2*vdisc[4]/vdisc[1]
    end


    # populate the output image
    image = zeros(dim)

    # assign appropriate greyscale values to the black hole geometry based on pixel coordinate on accretion disk/background
    # greyscale value is proportional to the frequency of emitted light on the accretion disk, and then fitted into the visible
    # range. Accretion disk modelled as a black body emitter. 

    for i in eachindex(image)
        p = points[i]
        if (p.status == StatusCodes.IntersectedWithGeometry)

            r, ϕ = p.x[2], p.x[4]
            # scale r between 0 and 2
            x = cos(ϕ - Omega*τ) * r / d.outer_radius + 1
            y = sin(ϕ - Omega*τ) * r / d.outer_radius + 1
            # add 1 since julia arrays begin at 1
            xi = trunc(Int, x * image_x_mid) + 1
            yi = trunc(Int, y * image_y_mid) + 1
            
            # accounting for edge cases where x, y are exactly = to image dimensions
            if xi == image_x + 1
                xi -= 1
            end

            if yi == image_y + 1
                yi -= 1
            end 

            g = redshift_func(m, p, 0.0)
            regulator = 0.05 + 0.95*exp(1-g)
           
            value = disc_image[yi, xi]*regulator
            image[i] = value
        end
    end


    #smooth out seam - need even dimensions
    image ./= maximum(image)
    mid_x = Int(dim[2]/2)
    mid_y = Int(dim[1]/2)
    for y in mid_y:dim[1]
        image[y, mid_x] = (image[y, mid_x-1])/2 + (image[y, mid_x+1])/2
    end

    # y is flipped, so reverse along that axis
    save("greyscale_kerr_new/frame_$ID.png", reverse(image; dims = 1))

end