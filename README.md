# Black Holes in VR

###  Project using the Gradus package in Julia to display black holes using virtual reality. 

Trajectory of the observer is pre-computed using the Gradus package, and then passed to Unity, which will display the scenario in VR. \
This project is designed for use on High Performance Computing (HPC) systems.

# Docs

The documentation for this project can be found on GitHub Pages, [here](https://raichkel.github.io/GR_in_VR/).


# Repository Structure

💫 [GR_in_VR/final_simulations/](https://github.com/raichkel/GR_in_VR/tree/main/final_simulations) \
    Contains the output simulations for Schwarzschild and Kerr black holes, as well as a Morris-Thorne wormhole. \
💫 [GR_in_VR/project/src/pre_computation/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/pre_computation) \
    Code to generate the simulation, including test images and test simulations. \
💫 [GR_in_VR/project/src/accretion_disk/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/accretion_disk) \
    Process files for modelling the accretion disk. \
💫 [GR_in_VR/project/src/batch_scripts/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/batch_scripts) \
    Shell script files for running code on HPC. \
💫 [GR_in_VR/project/src/sysimage/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/sysimage) \
    Code to generate sysimage using the [PackageCompiler](https://github.com/JuliaLang/PackageCompiler.jl) package. \
💫 [GR_in_VR/project/src/VR/](https://github.com/raichkel/GR_in_VR/tree/main/project/src/VR) \
    C# code for running the simulation on VR headset with Unity. \
💫 [GR_in_VR/project/post_processing/](https://github.com/raichkel/GR_in_VR/tree/main/project/post_processing) \
    Code for colourising images and compiling it into a video. \
💫 [GR_in_VR/project/runner_files/](https://github.com/raichkel/GR_in_VR/tree/main/project/runner_files) \
    Runner files for use with the batch scripts on HPC systems. \
💫 [GR_in_VR/project/test_frames/](https://github.com/raichkel/GR_in_VR/tree/main/project/test_frames) \
    Miscellaneous frames used in the test code.\
💫 [GR_in_VR/project/vr_files/](https://github.com/raichkel/GR_in_VR/tree/main/project/vr_files) \
    Files to set up Unity Hub for runningthe simulation.\
    

  
  
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

