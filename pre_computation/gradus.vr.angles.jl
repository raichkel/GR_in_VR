using Gradus
using StaticArrays

m = KerrMetric(M = 1.0, a = 0.0)
# coordinate: t    r      θ            ϕ          
u = @SVector [0.0, 5.0, deg2rad(80), 0.0]
# disc:               r_in            r_out  ϕ_inc
d = GeometricThinDisc(Gradus.isco(m), 150.0, π / 2)

# need a velocity prescription for the observer
# so a simple one is that the observer that is time-like stationary
gcomp = metric_components(m, u[2:3])
v_observer = inv(√(-gcomp[1])) * @SVector[1.0, 0.0, 0.0, 0.0]

# fix azimuth
θ = deg2rad(40)
# vary radial and assemble velocities
vs = [Gradus.sky_angles_to_velocity(m, u, v_observer, θ, ϕ) for ϕ in range(0.0, 2π, 30)]

# there are many different ways to give initial conditions for
# batches of geodesics to Gradus but the easiest here is probably
# just pairs of positions and velocities
us = fill(u, size(vs))

sols = tracegeodesics(m, us, vs, d, (0.0, 2000.0))



# plotting code
using Plots
Plots.gr()

function plot_event_horizon!(p, m; N = 32, kwargs...)
    R, ϕ = event_horizon(m, resolution = N)

    θ = range(0, stop = π, length = N)
    x = R .* cos.(ϕ) .* sin.(θ)'
    y = R .* sin.(ϕ) .* sin.(θ)'
    z = R .* repeat(cos.(θ)', outer = [N, 1])

    surface!(p, x, y, z; kwargs...)
end

begin
    LIM = 10
    p = plot(legend = false)
    for sol in sols.u
        tspan = range(0.0, min(last(sol.t), 100.0), 300)
        # interpolate at selected times
        points = sol.(tspan)
        # unpack 
        r = [i[2] for i in points]
        θ = [i[3] for i in points]
        ϕ = [i[4] for i in points]
        # transform to cartesian
        x = @. r * sin(θ) * cos(ϕ)
        y = @. r * sin(θ) * sin(ϕ)
        z = @. r * cos(θ)
        # plot
        plot!(p, x, y, z)
    end
    plot!(p, [0], [0], [0], ms = 50)

    plot_event_horizon!(p, m)
    p = plot(
        p,
        xlims = (-LIM, LIM),
        ylims = (-LIM, LIM),
        zlims = (-LIM, LIM),
        legend = false,
        camera = (10, 10),
    )

    p
end
