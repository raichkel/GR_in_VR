# Black Holes in VR

###  Project using the Gradus package in Julia to display black holes using virtual reality. 

Trajectory of the observer is pre-computed using the Gradus package, and then passed to Unity, which will display the scenario in VR. \
This project is designed for use on High Performance Computing (HPC) systems.

# Repository Structure

💫 [GR_in_VR/final_simulations/](https://github.com/raichkel/GR_in_VR/tree/main/final_simulations) \
    Contains output simulations for Schwarzschild and Kerr black holes, as well as a Morris-Thorne wormhole. \
💫 [GR_in_VR/project/src/pre_computation/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/pre_computation) \
    Code to generate simulation, including test images and test simulations. \
💫 [GR_in_VR/project/src/accretion_disk/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/accretion_disk) \
    Process files for modelling the accretion disk. \
💫 [GR_in_VR/project/src/batch_scripts/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/batch_scripts) \
    Shell script files for running code on HPC. \
💫 [GR_in_VR/project/src/sysimage/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/sysimage) \
    Code to generate sysimage using [PackageCompiler] (https://github.com/JuliaLang/PackageCompiler.jl) package. \
💫 [GR_in_VR/project/src/VR/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/VR) \
    C# code for running simulation on VR headset with Unity. \
💫 [GR_in_VR/project/post_processing/](https://github.com/raichkel/GR_in_VR/tree/main/project/post_processing) \
    Code for colourising images and compiling it into a video. \
💫 [GR_in_VR/project/runner_files/](https://github.com/raichkel/GR_in_VR/tree/main/project/runner_files) \
    Runner files for use with the batch scripts on HPC systems. \
💫 [GR_in_VR/project/test_frames/](https://github.com/raichkel/GR_in_VR/tree/main/project/test_frames) \
    Miscellaneous frames used in test code.\
  
  
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

The GR in VR project can be used to fully calculate a trajectory along a geoedesic into a black hole or wormhole, and then produce a simulation of the view for an observer moving along this trajectory. The simulation is produced initially as a series of equirectangular frames, and then these frames are 'stitched together' into a video format, which is then able to be viewed using an Virtual Reality headset. The project is optimised for use on a HPC system, specifically one operating with the SLURM scheduler. As such, the setup may not be optimal for use on a personal computer. Further in this README, there is a discussion of how to change the code to better run it on a personal machine. 

### Generating a Trajectory
[`GR_in_VR/project/src/pre_computation/trajectory.jl`](https://github.com/raichkel/GR_in_VR/blob/main/project/src/pre_computation/trajectory.jl) can be used to calculate the trajectory that an observer would take from any given initial conditions as they fell into the event horizon of the black hole. A `.txt` file is produced with the observer position and observer velocity for each timestep. The Repository also comes with several example trajectories; [`GR_in_VR/project/src/pre_computation/trajectories/`](https://github.com/raichkel/GR_in_VR/tree/main/project/src/pre_computation/trajectories), which can be used for Schwarzschild and Kerr black holes, and wormholes respectively.

### Producing the Frames
Given a trajectory, the simulation can then be produced. The relevant `.sh` file in [`GR_in_VR/project/src/batch_scripts/`](https://github.com/raichkel/GR_in_VR/tree/main/project/src/batch_scripts) creates an array job over the entire trajectory. Please note, it is necessary to edit these scripts to ensure that the values in `#SBATCH --array=1-NUM` correspond to the size of the `trajectory.txt` file. For each sub-job in the array, the corresponding step in the trajectory is read in and passed to the relevant `runner.jl` file ([`GR_in_VR/project/runner_files/`](https://github.com/raichkel/GR_in_VR/tree/main/project/runner_files)), which sets up all the necessary packages and variables. The `runner.jl` then calls the relevant file to produce and equirectangular frame at this point in the trajectory. See [`GR_in_VR/project/src/pre_computation/simulation_files/`](https://github.com/raichkel/GR_in_VR/tree/main/project/src/pre_computation/simulation_files). Each frame along the observer's trajectory is outputted to a file, which can then be post-processed and turned into a usable video.

### Post-Processing
The frames are outputted as greyscale images, and so the [`GR_in_VR/project/post_processing/colouriser.py`](https://github.com/raichkel/GR_in_VR/blob/main/project/post_processing/colouriser.py) file colours each frame. The frames can then be compiled into a video using the `ffmpeg` software.

`ffmpeg -r 60 -f image2 -s 2520x1260 -i colourised\colour_frame_%d.png -vcodec libx264 -crf 25  -pix_fmt yuv420p black_hole.mp4`


# Features
### Schwarzschild Black Holes
For the full example simulation see [here](https://github.com/raichkel/GR_in_VR/blob/main/final_simulations/shwarzschild_black_hole.mp4). The files are large and so may have to be downloaded to be viewed.

### Kerr Black Holes
For the full example simulation see [here](https://github.com/raichkel/GR_in_VR/blob/main/final_simulations/kerr_black_hole_slower.mp4). The files are large and so may have to be downloaded to be viewed.


### Morris-Thorne Wormholes
For the full example simulation see [here](https://github.com/raichkel/GR_in_VR/blob/main/final_simulations/wormhole.mp4). The files are large and so may have to be downloaded to be viewed.
