# Author: Rachel Kane
# Runner file for Kerr simulation, confirms required dependencies are installed,
# formats command line args from batch script and runs simulation file

# tell Julia we are running in project environment "project", use corresponding package.toml/manifest.toml files
# which tell Julia what packages and dependencies are required for this project
import Pkg
using Pkg
Pkg.Registry.update()

# using the Pkg module to ensure the AstroRegistry is added if not already
# then using Pkg.instantiate to ensure all of the required packages from manifest.toml are installed in this directory
Pkg.Registry.add(RegistrySpec(url = "https://github.com/astro-group-bristol/AstroRegistry"))
Pkg.instantiate()

# get values from ARGS
ID, t, r, θ, φ, v1, v2, v3, v4, τ = ARGS[1:end]
# scale = 5
# r = 20.0
# θ = 1.222
# ϕ = 0.0

ID = parse(Int64, ID)
t = parse(Float64, t)
r = parse(Float64, r)
θ = parse(Float64, θ)
φ = parse(Float64, φ)
v1 = parse(Float64, v1)
v2 = parse(Float64, v2)
v3 = parse(Float64, v3)
v4 = parse(Float64, v4)
τ = parse(Float64, τ)


# generate the image

include("src/pre_computation/kerr.jl")
