#!/bin/bash

#SBATCH --job-name=julia_test
#SBATCH --partition=teach_cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=28
#SBATCH --cpus-per-task=1
#SBATCH --time=0:40:00
#SBATCH --mem-per-cpu=1000M
#SBATCH --account=phys026162


## Direct output to the following files.
## (The %j is replaced by the job id.)
#SBATCH -e julia_test_%j.txt
#SBATCH -o julia_test_%j.txt

module purge
# load julia
module load languages/julia/1.8.2 

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

# run file
#julia -tauto greyscale_equirectangular.jl

julia --project="project"

# Output the end time
printf "\n\n"
echo "Ended on: $(date)"