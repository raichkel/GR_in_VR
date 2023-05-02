GR in VR
===============================================

###  Project using the Gradus package in Julia to display black holes using virtual reality. 

This project is optimised for use on High Performance Computing (HPC) systems.

Trajectory of the observer is pre-computed using the Gradus package, and then passed to Unity, which will display the scenario in VR.



💫 `final_simulations <https://github.com/raichkel/GR_in_VR/tree/main/final_simulations>`_
    Contains output simulations for Schwarzschild and Kerr black holes, as well as a Morris-Thorne wormhole.
💫 `project/src/pre_computation <https://github.com/raichkel/GR_in_VR/tree/main/project/src/pre_computation>`_
    Code to generate simulation, including test images and test simulations.
💫 `project/src/accretion_disk <https://github.com/raichkel/GR_in_VR/tree/main/project/src/accretion_disk>`_
    Process files for modelling the accretion disk.
💫 `project/src/batch_scripts <https://github.com/raichkel/GR_in_VR/tree/main/project/src/batch_scripts>`_
    Shell script files for running code on HPC.
💫 `project/src/sysimage <https://github.com/raichkel/GR_in_VR/tree/main/project/src/sysimage>`_
    Code to generate sysimage using 'PackageCompiler <https://github.com/JuliaLang/PackageCompiler.jl>' package.
💫 `project/src/VR <https://github.com/raichkel/GR_in_VR/tree/main/project/src/VR>`_
    C# code for running simulation on VR headset with Unity.
💫 `project/post_processing <https://github.com/raichkel/GR_in_VR/tree/main/project/post_processing>`_
    Code for colourising images and compiling it into a video.
💫 `project/runner_files <https://github.com/raichkel/GR_in_VR/tree/main/project/runner_files>`_
    Runner files for use with the batch scripts on HPC systems
💫 `project/test_frames <https://github.com/raichkel/GR_in_VR/tree/main/project/test_frames>`_
    Miscellaneous frames used in test code.



Installation
---------------------
This project relies heavily on the [Gradus package](https://github.com/astro-group-bristol/Gradus.jl) which, in turn, relies on aspects of the [AstroRegistry](https://github.com/astro-group-bristol/AstroRegistry) AstroRegistry. The AstroRegistry can be added as follows:


.. code-block:: console

    julia>] registry add https://github.com/astro-group-bristol/AstroRegistry


And then Gradus can be added by running:

.. code-block:: console

    julia>] add Gradus
    julia> using Gradus

Loading Julia using the command line flag:

.. code-block:: console
    --project="project"


Will load in the necessary packages alongside this.

The repository can then be cloned to your local machine as usual using `git clone`.

