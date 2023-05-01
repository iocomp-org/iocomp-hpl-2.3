# common variables 
PPN=128
TIMES=( "3:00:00" "3:00:00" "3:00:00" "3:00:00" "3:00:00"  ) # different times for different ranks 
NODE_START=0
NODE_END=0
IO_start=0 
IO_end=0
DIR=TEST
ARRAY=0 
N=50000

# loop over number of nodes given by 2^x 
for x in $(seq ${NODE_START} ${NODE_END}) 
do 
  NUM_NODES=$((2**x)) 
  # TIME_VAR=${TIMES[$x]} 
  TIME_VAR=00:05:00

  # loop over I/O layers 
  for IO in $(seq ${IO_start} ${IO_end}) 
  do 
    echo NODES ${NUM_NODES} PPN ${PPN} IO ${IO} to ${IO}  TIME ${TIME_VAR} N ${N} 
    sbatch --export=ALL,DIR=${DIR},IO_start=${IO},IO_end=${IO},SIZE=${N} --ntasks-per-node=${PPN} --nodes=${NUM_NODES} --time=${TIME_VAR} --array=${ARRAY} --qos=lowpriority  archer2.slurm 
  done 

done 

