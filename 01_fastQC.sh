#!/bin/bash
#SBATCH --time=2:00:00
#SBATCH --mem=1g
#SBATCH --cpus-per-task=1
#SBATCH --job-name=fast_QC
#SBATCH --output=/data/users/rkumble/rnaseq_course/log/01_fastQC_%J.out
#SBATCH --error=/data/users/rkumble/rnaseq_course/log/01_fastQC_%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=1-31

#Variables
WORKDIR="/data/users/${USER}/rnaseq_course"
OUTDIR="$WORKDIR/QC_results"
SAMPLELIST="$WORKDIR/samplelist.tsv"
LOGDIR="$WORKDIR/log"

#Create the directory for the error and output file 
mkdir -p $LOGDIR

#use awk to take the sample name and path to reads 1 & 2 per line
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

#Create the directory output 
mkdir -p $OUTDIR
cd $OUTDIR

#run fastqc for both reads and put the result in outfile
apptainer exec --bind /data /containers/apptainer/fastqc-0.12.1.sif fastqc -t 2 $READ1 $READ2 -o $OUTDIR