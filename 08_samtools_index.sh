#!/usr/bin/env bash
#SBATCH --time=01:00:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=samtools_index
#SBATCH --output=/data/users/rkumble/rnaseq_course/log/08_samtools_index%J.out
#SBATCH --error=/data/users/rkumble/rnaseq_course/log/08_samtools_index%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=1-16


WORKDIR="/data/users/rkumble/rnaseq_course"
LOGDIR="$WORKDIR/log"
SAMPLELIST="$WORKDIR/samplelist.tsv"
OUTDIR=$WORKDIR/mapping


#Create the directory for the error and output file
mkdir -p $LOGDIR

#take the sample name and path reads 1 & 2 per line
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

#index the bam file 
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools index $OUTDIR/${SAMPLE}sorted.bam