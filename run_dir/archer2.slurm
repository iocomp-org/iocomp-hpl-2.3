#!/bin/bash --login
#SBATCH --job-name=hpl
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --account=e609
#SBATCH --partition=standard 
#SBATCH --qos=lowpriority
##SBATCH --array=0-2

module swap PrgEnv-cray/8.0.0 PrgEnv-gnu
module load cmake 
module use /work/y07/shared/archer2-lmod/dev
module load xthi 
module swap craype-network-ofi craype-network-ucx 
module swap cray-mpich cray-mpich-ucx 
module load cray-hdf5-parallel

# Setup environment
export PPN=${SLURM_NTASKS_PER_NODE}
export OMP_NUM_THREADS=1
# export IOCOMP_DIR=/work/e609/e609/shr203/iocomp
export IOCOMP_DEBUG_DIR=/work/e609/e609/shr203/iocomp_DEBUG
export ADIOS2_DIR=/work/e609/e609/shr203/opt/gnu/8.0.0/ADIOS2
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${ADIOS2_DIR}/lib64:${IOCOMP_DIR}/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${ADIOS2_DIR}/lib64:${IOCOMP_DEBUG_DIR}/lib
export HPL=/mnt/lustre/a2fs-work3/work/e609/e609/shr203/hpl-2.3/bin/cray/xhpl
export CONFIG=${SLURM_SUBMIT_DIR}/config.xml 
export HPL_DAT=${SLURM_SUBMIT_DIR}/HPL.dat

# Make new directory 
IOLAYERS=("MPIIO" "HDF5" "ADIOS2_HDF5" "ADIOS2_BP4" "ADIOS2_BP5") # assign IO layer array 
SIZE=64GB
i=${SLURM_ARRAY_TASK_ID} 
HALF_CORES=$((${SLURM_NTASKS_PER_NODE}/2)) 
FULL_CORES=$((${SLURM_NTASKS_PER_NODE})) 
HALF_NODES=$((${SLURM_NNODES}/2))
MAP=0

echo "Job started " $(date +"%T") # start time

for m in {0..0}
do 
  #export PARENT_DIR=${SLURM_SUBMIT_DIR}/v1.1.1/${SLURM_NNODES}_${SLURM_NTASKS_PER_NODE}/${SIZE}/${IOLAYERS[${m}]}
  export PARENT_DIR=${SLURM_SUBMIT_DIR}/TEST/${SLURM_NNODES}_${SLURM_NTASKS_PER_NODE}/${IOLAYERS[${m}]}

  # Case 1 
	source ${SLURM_SUBMIT_DIR}/slurm_files/sequential.sh
	wait 

##  # Case 2
##	source ${SLURM_SUBMIT_DIR}/slurm_files/oversubscribe.sh 
##	wait 

  # Case 3
	source ${SLURM_SUBMIT_DIR}/slurm_files/hyperthread.sh 
	wait 

  # Case 4
	source ${SLURM_SUBMIT_DIR}/slurm_files/consecutive.sh
	wait 
done 

echo $(module list) 

# runtime given by: 
echo "Job ended " $(date +"%T") # end time 
