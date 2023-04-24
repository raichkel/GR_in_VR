# Black Holes in VR

###  Project using the Gradus package in Julia to display black holes using virtual reality. 

Trajectory of the observer is pre-computed using the Gradus package, and then passed to Unity, which will display the scenario in VR.

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

# Usage

The GR in VR project can be used to fully calculate a trajectory along a geoedesic, into a black hole, and then produce a simulation of the view for an observer moving along this trajectory. The simulation is produced initially as a series of equirectangular frames, and then these frames are 'stitched together' into a video format, which is then able to be viewed using an Virtual Reality headset. The project is optimised for use on a High Peformance Computing (HPC) system, specifically one operating with the SLURM scheduler. As such, the setup may not be optimal for use on a personal computer. Further in this README, there is a discussion of how to change the code to better run it on a personal machine. 

### Generating a Trajectory
`project/src/pre_computation/trajectory.jl` can be used to calculate the trajectory that an observer would take from any given initial conditions as they fell into the event horizon of the black hole. A `.txt` file is produced with the observer position and observer velocity for each timestep. The Repository also comes with several example trajectories; `NAME OF EXAMPLES`, which can be used for !CORRESPONDING SCENARIOS].

### Producing the Frames
Given a trajectory, the simulation can then be produced. `image_array.sh` creates an array job over the entire trajectory. For each sub-job in the array, the corresponding step in the trajectory is read in and passed to `runner.jl`, which sets up all the necessary packages and variables. `runner.jl` then calls the relevant file to produce and equirectangular frame at this point in the trajectory. `serial.jl` for a Schwarzschild black hole, and `kerr.jl` for a Kerr black hole. Each frame along the observer's trajectory is outputted to a file, which can then be post-processed and turned into a usable video.

### Post-Processing



# Features

