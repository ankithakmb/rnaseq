#!/usr/bin/env bash
#SBATCH --time=02:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=hisat_mapping
#SBATCH --output=/data/users/rkumble/rnaseq_course/log/05_hisat_mapping_%J.out
#SBATCH --error=/data/users/rkumble/rnaseq_course/log/05_hisat_mapping_%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=1-16


#Variables
WORKDIR="/data/users/${USER}/rnaseq_course/"
REFGENDIR="$WORKDIR/reference_genome"
LOGDIR="$WORKDIR/log"
INDEXDIR="$WORKDIR/index_hisat"
SAMPLELIST="$WORKDIR/samplelist.tsv"
OUTDIR=$WORKDIR/mapping

#Create the directory for the error and output file
mkdir -p $LOGDIR

mkdir -p $OUTDIR


#use awk to take the sample name and path to reads 1 & 2 per line
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

#Map the reads onto reference genome
apptainer exec --bind /data /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif \
hisat2 -x $INDEXDIR/genome_index -1 $READ1 -2 $READ2 -S $OUTDIR/$SAMPLE.sam --threads 4 --rna-strandness RF --summary-file $OUTDIR/${SAMPLE}mapping_summary.txt