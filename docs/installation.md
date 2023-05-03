[Home](https://raichkel.github.io/GR_in_VR/) | [GitHub](https://github.com/raichkel/GR_in_VR)

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

will load in the necessary packages alongside this. Ensure that you have installed these packages onto your machine prior to doing so, using the `pkg]` functionality, or the `Pkg` module.

The repository can then be cloned to your local machine as usual using `git clone`.
> Note that the full repo contains simulation video files, which can be large (>30MB).

