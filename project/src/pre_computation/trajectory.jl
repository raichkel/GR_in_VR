# Author: Joel Mills

# Code to compute the trajectory of a free-falling observer until the horizon is crossed,
# then write the observer's 4-position & 4-velocity at evenly spaced timestamps to a txt file
# Application is for rows to be read as inputs for an array job on BC4
# Start free fall far away at r =: 250.0

using Gradus
using StaticArrays


# define the metric object
m = KerrMetric(M = 1.0, a = 0.0)

# define initial observer position
t_init = 0.0
r_init = 250.0
θ_init = deg2rad(70)
φ_init = 0.0
# coordinate: t    r      θ            ϕ          
u = @SVector [t_init, r_init, θ_init, φ_init]


# need a velocity prescription for the observer
# so a simple one is that the observer that is time-like stationary
gcomp = metric_components(m, u[2:3])
v_observer = inv(√(-gcomp[1])) * @SVector[1.0, 0.0, 0.0, 0.0]


# disc:               r_in            r_out  ϕ_inc
d = GeometricThinDisc(Gradus.isco(m), 150.0, π/2)


# Compute observer's geodesic with initial position u and 4-velocity v_observer
trajectory = tracegeodesics(m, u, v_observer, d, (0.0, 2000.0); save_on = false, μ = 1.0)
points = process_solution(m, trajectory)


# Loop through points on observer's geodesic paramterized by affine time until the event horizon is crossed,
# writing the observer's 4-position and 4-velocity for each point to a txt file
let point = [points.u1; points.v1], t = 0.0, i = 1

    open("project/src/pre_computation/trajectories/array_job.txt", "w") do f

        #do time increments every 2.5s until the radial coordinate is less than the Schwarzchild outer_radius
        # (in natural units c=1 & G=1, Schwarzchild radius = 2.0 if the mass is 1.0 --- R =: 2*G*m/c^2)

        while point[2] > 2.0
            u1 = point[1]
            u2 = point[2]
            u3 = point[3]
            u4 = point[4]
            v1 = point[5]
            v2 = point[6]
            v3 = point[7]
            v4 = point[8]
            write(f, "$i $u1 $u2 $u3 $u4 $v1 $v2 $v3 $v4 \n")
            t += 2.5
            i += 1
            point = trajectory(t)
        end
    end
    print(i)
end




