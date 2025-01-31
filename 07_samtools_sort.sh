#!/usr/bin/env bash
#SBATCH --time=01:00:00
#SBATCH --mem=30G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=samtools_sort
#SBATCH --output=/data/users/rkumble/rnaseq_course/log/07_samtools_sort_%J.out
#SBATCH --error=/data/users/rkumble/rnaseq_course/log/07_samtools_sort_%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=0-31


WORKDIR="/data/users/rkumble/rnaseq_course"
LOGDIR="$WORKDIR/log"
SAMPLELIST="$WORKDIR/samplelist.tsv"
OUTDIR=$WORKDIR/mapping


#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

#take the sample name and path reads 1 & 2 per line
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`


#sort the bam file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools sort -m 27000m -@ 4 -o $OUTDIR/${SAMPLE}sorted.bam -T temp $OUTDIR/$SAMPLE.bam