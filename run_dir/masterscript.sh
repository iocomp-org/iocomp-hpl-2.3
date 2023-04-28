# common variables 
PPN=128
#TIMES=( "00:05:00" "00:05:00" "00:30:00" "00:40:00" ) # different times for different ranks 
NODE_START=0
NODE_END=4

###  TESTING CHANGE PARAMETERS 
DIR=TEST 
IO_start=0 
IO_end=0 
ARRAY="0"
TIMES="00:05:00"

# loop over number of nodes given by 2^x 
for x in $(seq ${NODE_START} ${NODE_END}) 
do 
  NUM_NODES=$((2**x)) 
  #TIME_VAR=${TIMES[$x]} # change after testing 
  TIME_VAR=${TIMES} 

  # loop over I/O layers 
  for IO in $(seq ${IO_start} ${IO_end}) 
  do 
    echo NODES ${NUM_NODES} PPN ${PPN} IO ${IO} to ${IO}  TIME ${TIME_VAR} SIZE ${NX} x ${NY} x ${NZ} = ${SIZE}MiB 
    sbatch --export=ALL,DIR=${DIR},IO_start=${IO},IO_end=${IO} --ntasks-per-node=${PPN} --nodes=${NUM_NODES} --time=${TIME_VAR} --array=${ARRAY} archer2.slurm 

  done 

done 

