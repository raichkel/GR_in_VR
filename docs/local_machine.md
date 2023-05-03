[Home](https://raichkel.github.io/GR_in_VR/) | [GitHub](https://github.com/raichkel/GR_in_VR)

# Using this Code on a Local Machine

#### Please note that this code is not intended for a local machine, and the following is a brief guide only.

Running this code for its intended use of producing many-frame VR simulations is not advised on a local machine, and so the repository does not provide code optimised for doing so. However, we wish to acknowledge that not all potential users will have access to a HPC facility, and so here we provide a brief overview of the steps required to convert this code for local use.

In order to successfully edit the code for use on a local machine, it is first necessary to understand how the code works on a HPC machine. The code runs as follows:

- A shell script is called on the command line, this script sets up an array job with N sub-jobs.
- On each sub-job, n, the nth step in the trajetory is read in from the config file (usually called something like `kerr_trajectory.txt`). The values of r, theta, phi, v, etc. from this file are assigned to variables within the script. 
- The sub-job script then opens Julia in the 'project' environment, using the flag `--project="project"`. Then the `runner.jl` file is called, and the trajectory variables passed as `ARGS` - which are Julia's version of command-line arguments.
- The runner file then sets up the relevant modules, assigns the `ARGS` to Julia variables, and then calls the `simulation.jl` file, named, for example, `kerr.jl`. 
- The simulation file then produces the equirectangular frame of view for an observer at this point along the trajectory.

> More information on this process can be found in the [Usage](https://raichkel.github.io/GR_in_VR/usage.html) section.

The proposed process to optimise the code for a local machine would be:
- Combine the `runner.jl` and `simulation.jl` files. The `runner.jl` file's main job is ensuring that the ARGS are read in correctly, and to deal with the code's required deoendencies. This method of doing so is unique to the HPC system, and is mainly implemented as a fix to common issues with various packages/registries encountered on the HPC system in development. On a local machine, the `simulation.jl` file could safely be edited to read in the trajectory values, and the registry/package code from `runner.jl` done away with.
- Remove references to variables such as `$ID` in the script, which refer to variables associated with sub-jobs in the array job.
- Ensure that Julia is started with the `--project="project"` flag, so that all the required dependencies are present.

From this, it should be possible to produce gresyscale frames on a local madchine, however the time taken to do so is of order 1000 longer than the time to perform the same task on a HPC machine.