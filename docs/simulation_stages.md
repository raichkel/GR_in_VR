[Home](https://raichkel.github.io/GR_in_VR/)    [GitHub](https://github.com/raichkel/GR_in_VR)
# Simulation Stages

The simulation process operates on a number of stages, which are laid out here for clarity. Please see [Usage](https://raichkel.github.io/GR_in_VR/usage.html) for further information on running this code.

### Generating a Trajectory
[`GR_in_VR/project/src/pre_computation/trajectory.jl`](https://github.com/raichkel/GR_in_VR/blob/main/project/src/pre_computation/trajectory.jl) can be used to calculate the trajectory that an observer would take from any given initial conditions as they fell into the event horizon of the black hole. A `.txt` file is produced with the observer position and observer velocity for each timestep. The Repository also comes with several example trajectories; [`GR_in_VR/project/src/pre_computation/trajectories/`](https://github.com/raichkel/GR_in_VR/tree/main/project/src/pre_computation/trajectories), which can be used for Schwarzschild and Kerr black holes, and wormholes respectively.

### Producing the Frames
Given a trajectory, the simulation can then be produced. The relevant `.sh` file in [`GR_in_VR/project/src/batch_scripts/`](https://github.com/raichkel/GR_in_VR/tree/main/project/src/batch_scripts) creates an array job over the entire trajectory. Please note, it is necessary to edit these scripts to ensure that the values in `#SBATCH --array=1-NUM` correspond to the size of the `trajectory.txt` file. For each sub-job in the array, the corresponding step in the trajectory is read in and passed to the relevant `runner.jl` file ([`GR_in_VR/project/runner_files/`](https://github.com/raichkel/GR_in_VR/tree/main/project/runner_files)), which sets up all the necessary packages and variables. The `runner.jl` then calls the relevant file to produce and equirectangular frame at this point in the trajectory. See [`GR_in_VR/project/src/pre_computation/simulation_files/`](https://github.com/raichkel/GR_in_VR/tree/main/project/src/pre_computation/simulation_files). Each frame along the observer's trajectory is outputted to a file, which can then be post-processed and turned into a usable video.

### Post-Processing
The frames are outputted as greyscale images, and so the [`GR_in_VR/project/post_processing/colouriser.py`](https://github.com/raichkel/GR_in_VR/blob/main/project/post_processing/colouriser.py) file colours each frame. The frames can then be compiled into a video using the `ffmpeg` software.

`ffmpeg -r 60 -f image2 -s 2520x1260 -i colourised\colour_frame_%d.png -vcodec libx264 -crf 25  -pix_fmt yuv420p black_hole.mp4`