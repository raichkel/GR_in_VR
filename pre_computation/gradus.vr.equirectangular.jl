using Gradus
using StaticArrays
using Images

m = KerrMetric(M=1.0, a=0.0)
# coordinate: t    r      θ            ϕ          
u = @SVector [0.0, 10.0, deg2rad(73), 0.0]
# disc:               r_in            r_out  ϕ_inc
d = GeometricThinDisc(Gradus.isco(m), 150.0, π/2)

# need a velocity prescription for the observer
# so a simple one is that the observer that is time-like stationary
gcomp = metric_components(m, u[2:3])
v_observer = inv(√(-gcomp[1])) * @SVector[1.0, 0.0, 0.0, 0.0]

# φ₀, λ₀ (central parallel and meridian)
# φ₁ (standard parallels)
function inverse_equirectangular(x, y; φ₀ = 0, λ₀ = 60.0, φ₁ = 0, R = 1.0)
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

# populate the output image
image = zeros(Float64, dim)
for i in eachindex(image)
    p = points[i]
    value = if p.status == StatusCodes.IntersectedWithGeometry
        redshift_func(m, p, 0.0)
    else
        0.0
    end
    image[i] = value
end

begin 
    max = maximum(image)
    min = minimum(image)
    # normalize between 0 and 1
    image = @. (image - min) / (max - min)
end

# y is flipped, so reverse along that axis
save("test.png", colorview(Gray, reverse(image; dims=1)))