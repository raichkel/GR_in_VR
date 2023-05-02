# Author: Fergus Baker, Rachel Kane, Joel Mills

using FileIO
using Plots
using Gradus
using StaticArrays
using Images


#set affine time
τ = 0.0

function velocity_vector(m, u, v)
    x = u[2] * sin(u[3]) * cos(u[4])
    y = u[2] * sin(u[3]) * sin(u[4])

    R = x^2 + y^2
    rdot = (x * v[1] + y * v[2]) / √R
    θdot = (x * v[2] - v[1] * y) / R
    Gradus.constrain_all(m, u, @SVector[1.0, rdot, θdot, 0.0], 1.0)
end


m = MorrisThorneWormhole(b = 20.0)

# coordinate: t    r      θ            ϕ          
u = @SVector [t, r, θ, φ]


r_in = 6.0

r_out = (r_in/6.0)*150.0
# disc:               r_in            r_out  ϕ_inc
d = GeometricThinDisc(r_in, r_out, π/2)
# print(r_in)

# need a velocity prescription for the observer
# so a simple one is that the observer that is time-like stationary
gcomp = metric_components(m, u[2:3])
v_observer = inv(√(-gcomp[1])) * @SVector[1.0, 0.0, 0.0, 0.0]



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
vs = [Gradus.sky_angles_to_velocity(m, u, v_observer, -θ, φ) for (θ, φ) in angle_pairs]
us = fill(u, size(vs))

# don't save the full solution cus that's a lot of memory
sols = @time tracegeodesics(m, us, vs, d, (0.0, 2000.0); save_on = false)

points = process_solution.(m, sols.u)

# load in the image and work out the midpoint
image_file = "project/src/pre_computation/images/blank_disc.jpg"
disc_image = Gray.(load(image_file))
image_y, image_x = size(disc_image)
image_y_mid = image_y ÷ 2
image_x_mid = image_x ÷ 2


Ω = 1.0


#    populate the output image
image = zeros(dim)



for i in eachindex(image)
    p = points[i]
    if (p.status == StatusCodes.IntersectedWithGeometry)

        r, φ = p.x[2], p.x[4]
        # scale r between 0 and 2
        x = (cos(φ - Ω*τ) * r / d.outer_radius + 1) 
        y = (sin(φ - Ω*τ) * r / d.outer_radius + 1)

        # add 1 since julia arrays begin at 1
        xi = trunc(Int, x * image_x_mid) + 1
        yi = trunc(Int, y * image_y_mid) + 1

        if xi == image_x + 1
            xi -= 1
        end

        if yi == image_y + 1
            yi -= 1
        end

        value = disc_image[yi, xi]
        image[i] = value

    end
end


image ./= maximum(image)
#smooth out seam - need even dimensions
mid_x = Int(dim[2]/2)
mid_y = Int(dim[1]/2)
for y in mid_y:dim[1]
    image[y, mid_x] = (image[y, mid_x-1])/2 + (image[y, mid_x+1])/2
end

# y is flipped, so reverse along that axis
save("wormhole/wormhole_$ID.png", reverse(image; dims = 1))