using PackageCompiler
using Pkg

Pkg.activate("project")

create_sysimage(["Gradus", "FileIO", "Plots", "StaticArrays", "Images"]; sysimage_path="project/sysimage.so", precompile_execution_file="project/runner.jl")