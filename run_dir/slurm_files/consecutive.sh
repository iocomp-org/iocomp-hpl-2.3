export CASE=Consecutive
export RUNDIR=${PARENT_DIR}/${CASE}/$i
echo "**" $CASE 
echo $RUNDIR
rm -rf ${RUNDIR}
mkdir -p ${RUNDIR}
lfs setstripe -c -1  ${RUNDIR}
cd ${RUNDIR} 
cp ${CONFIG} . 
cp ${HPL_DAT} . 

end=$((${FULL_CORES}-1))
vals=($(seq 0 1 $(eval echo ${end})))
bar=$(IFS=, ; echo "${vals[*]}")

TOTAL_RANKS=$((${SLURM_NNODES} * ${SLURM_NTASKS_PER_NODE} ))
if (($MAP == 1)); then 
  map -n ${TOTAL_RANKS} --mpiargs="--hint=nomultithread  --distribution=block:block  --nodes=${SLURM_NNODES} --cpu-bind=map_cpu:${bar[@]}" --profile ${HPL}  --io ${m} --HT 1

else 
  srun  --hint=nomultithread  --distribution=block:block  --nodes=${SLURM_NNODES} --cpu-bind=map_cpu:${bar[@]} ${HPL} --HT 1  --io ${m} > test.out
fi 

echo "JOB ID"  $SLURM_JOBID >> test.out
echo "JOB NAME" ${SLURM_JOB_NAME} >> test.out
