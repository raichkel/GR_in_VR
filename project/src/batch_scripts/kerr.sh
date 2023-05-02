#!/bin/bash

# Author: Rachel Kane
#SBATCH --job-name=image_array
#SBATCH --partition=teach_cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=28
#SBATCH --cpus-per-task=1
#SBATCH --time=0:30:0
#SBATCH --mem-per-cpu=1000M
#SBATCH --account=phys026162
#SBATCH --array=1-3282
## creating 3282 sub-jobs numbered 1-3282


## Direct output to the following files.

#SBATCH -e image_array.txt
#SBATCH -o image_array.txt


# Specify the path to the trajectory file
config=project/src/pre_computation/trajectories/kerr_trajectory.txt

# Extract the t value for the current $SLURM_ARRAY_TASK_ID
t=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)

# Extract the r value for the current $SLURM_ARRAY_TASK_ID
r=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $config)

# Extract the theta value for the current $SLURM_ARRAY_TASK_ID
theta=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $4}' $config)

# Extract the theta value for the current $SLURM_ARRAY_TASK_ID
phi=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $5}' $config)


# Extract the theta value for the current $SLURM_ARRAY_TASK_ID
v1=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $6}' $config)


# Extract the theta value for the current $SLURM_ARRAY_TASK_ID
v2=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $7}' $config)

# Extract the theta value for the current $SLURM_ARRAY_TASK_ID
v3=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $8}' $config)

# Extract the theta value for the current $SLURM_ARRAY_TASK_ID
v4=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $9}' $config)

# Extract the theta value for the current $SLURM_ARRAY_TASK_ID
tau=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $10}' $config)





# Print to a file a message that includes the current $SLURM_ARRAY_TASK_ID and the u and v values
echo "This is array task ${SLURM_ARRAY_TASK_ID}, calculating image with t=${t}, r= ${r}, theta=${theta}, phi=${phi}, tau=${tau}."

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

# setting task no. as a variable

tasknum=${SLURM_ARRAY_TASK_ID}

# run file, set automatic number of threads in Gradus using -tauto
# setting t, r, theta, phi, v1, v2, v3, v4, tau


julia -tauto -Jproject/sysimage.so --project="project" project/runner_files/runner.jl ${tasknum} ${t} ${r} ${theta} ${phi} ${v1} ${v2} ${v3} ${v4} ${tau}

# Output the end time
printf "\n\n"
echo "Ended on: $(date)"



