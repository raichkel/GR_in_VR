# tell Julia we are running in project environment "project", use corresponding package.toml/manifest.toml files
# which tell Julia what packages and dependencies are required for this project
# -e '...' executes the enclosed lines of Julia, separated by ;
# using the Pkg module to ensure the AstroRegistry is added if not already
# then using Pkg.instantiate to ensure all of the required packages from manifest.toml are installed in this directory

import Pkg
using Pkg
Pkg.Registry.update()
Pkg.Registry.add(RegistrySpec(url = "https://github.com/astro-group-bristol/AstroRegistry"))
Pkg.instantiate()

# get values from ARGS
ID, t, r, θ, ϕ, v1, v2, v3, v4 = ARGS[1:end]
# scale = 5
# r = 20.0
# θ = 1.222
# ϕ = 0.0

ID = parse(Int64, ID)
t = parse(Float64, t)
r = parse(Float64, r)
θ = parse(Float64, θ)
ϕ = parse(Float64, ϕ)
v1 = parse(Float64, v1)
v2 = parse(Float64, v2)
v3 = parse(Float64, v3)
v4 = parse(Float64, v4)


# generate the image

include("src/pre_computation/serial.jl")
