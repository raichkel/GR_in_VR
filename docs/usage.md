[Home](https://raichkel.github.io/GR_in_VR/)    [GitHub](https://github.com/raichkel/GR_in_VR)

# Usage

The GR in VR project can be used to fully calculate a trajectory along a geoedesic into a black hole or wormhole, and then produce a simulation of the view for an observer moving along this trajectory. The simulation is produced initially as a series of equirectangular frames, and then these frames are 'stitched together' into a video format, which is then able to be viewed using an Virtual Reality headset. The project is optimised for use on a HPC system, specifically one operating with the SLURM scheduler. As such, the setup may not be optimal for use on a personal computer. \
For a discussion of how to change the code to better run it on a local machine, see the [Local Machine](https://raichkel.github.io/GR_in_VR/local_machine.html) section. 


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