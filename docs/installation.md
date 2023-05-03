[Home](https://raichkel.github.io/GR_in_VR/)

# Installation 

This project relies heavily on the [Gradus package](https://github.com/astro-group-bristol/Gradus.jl) which, in turn, relies on aspects of the [AstroRegistry](https://github.com/astro-group-bristol/AstroRegistry) AstroRegistry. The AstroRegistry can be added as follows:\
\
 `julia>] registry add https://github.com/astro-group-bristol/AstroRegistry`\
 \
 and then Gradus can be added by running:\
 \
 `julia>] add Gradus`\
`julia> using Gradus`

Loading Julia using the command line flag 

`--project="project"`

will load in the necessary packages alongside this.

The repository can then be cloned to your local machine as usual using `git clone`.

### Using HPC facilities

The project as-is relies on HPC facilities. Once you have decided what object you want to simulate, you can then begin by uploading the relevant file to the HPC system. 

We will use the [Schwarzschild black hole](https://github.com/raichkel/GR_in_VR/blob/main/final_simulations/shwarzschild_black_hole.mp4) as an example:

- Copy the [`schwarzschild.sh`](https://github.com/raichkel/GR_in_VR/tree/main/project/src/batch_scripts/schwarzschild.sh) batch script onto the HPC machine.
- Copy the [`runner_shw.jl`](https://github.com/raichkel/GR_in_VR/tree/main/project/runner_files/runner_shw.jl) file onto the HPC machine.
- Copy the [`schwarzschild.jl`](https://github.com/raichkel/GR_in_VR/tree/main/project/src/pre_computation/simulation_files/schwarzschild.jl) file onto the HPC machine.
- Copy the [`shwarzschild_trajectory.txt`](https://github.com/raichkel/GR_in_VR/blob/main/project/src/pre_computation/trajectories/shwarzschild_trajectory.txt) file onto the HPC machine.
- Copy the [`blank_disc.jpg`](https://github.com/raichkel/GR_in_VR/blob/main/project/src/pre_computation/images/blank_disc.jpg) file onto the HPC machine.


Now, ensure that all paths for the image file, trajectory, and simulation files are correct. Make sure that the number of array jobs in `schwarzschild.sh` is equal to the length of the trajectory. Then, the simulation can be called by running \
\
`sbatch schwarzschild.sh`
\
On the terminal of the HPC machine.