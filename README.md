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

# Usage

The GR in VR project can be used to fully calculate a trajectory along a geoedesic, into a black hole, and then produce a simulation of the view for an observer moving along this trajectory. The simulation is produced initially as a series of equirectangular frames, and then these frames are 'stitched together' into a video format, which is then able to be viewed using an Virtual Reality headset.

### To Calulate a Trajectory:
Using `project/src/pre_computation/trajectory.jl`

# Features

