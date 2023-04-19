#!/bin/bash

#SBATCH --job-name=optimised
#SBATCH --partition=teach_cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=28
#SBATCH --cpus-per-task=1
#SBATCH --time=0:50:00
#SBATCH --mem-per-cpu=1000M
#SBATCH --account=phys026162


## Direct output to the following files.
## (The %j is replaced by the job id.)
#SBATCH -e optimised_%j.txt
#SBATCH -o optimised_%j.txt

# load in Julia
module purge
module load languages/julia/1.8.5

# Change to working directory, where the job was submitted from.
cd "${SLURM_SUBMIT_DIR}"

# Record some potentially useful details about the job: 
echo "Running on host $(hostname)"
echo "Started on $(date)"
echo "Directory is $(pwd)"
echo "Slurm job ID is ${SLURM_JOBID}"
echo "This jobs runs on the following machines:"
echo "${SLURM_JOB_NODELIST}" 
printf "\n\n"

# run file, set automatic number of threads in Gradus using -tauto
# tell Julia we are running in project environment "project", use corresponding package.toml/manifest.toml files
# which tell Julia what packages and dependencies are required for this project
# -e '...' executes the enclosed lines of Julia, separated by ;
# using the Pkg module to ensure the AstroRegistry is added if not already
# then using Pkg.instantiate to ensure all of the required packages from manifest.toml are installed in this directory
# setting ARGS (equivalent to a command line style input in other languages, edited here to work with -e)
# running the file using include(filepath)


julia -tauto --project="project" -e 'import Pkg; using Pkg; Pkg.Registry.update(); Pkg.Registry.add(RegistrySpec(url = "https://github.com/astro-group-bristol/AstroRegistry")); Pkg.instantiate(); using Distributed; addprocs(nprocs(), exeflags="--project"); ARGS = [5]; include("project/src/pre_computation/optimised.jl")'  

# Output the end time
printf "\n\n"
echo "Ended on: $(date)"