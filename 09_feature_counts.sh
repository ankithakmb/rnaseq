#!/usr/bin/env bash
#SBATCH --time=02:00:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=feature_counts
#SBATCH --output=/data/users/rkumble/rnaseq_course/log/09_feature_counts%J.out
#SBATCH --error=/data/users/rkumble/rnaseq_course/log/09_feature_counts%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=1-16

#Variables
WORKDIR="/data/users/rkumble/rnaseq_course"
LOGDIR="$WORKDIR/log"
SAMPLELIST="$WORKDIR/samplelist.tsv"
BAMDIR="$WORKDIR/mapping"  # Directory containing BAM files
OUTDIR=$WORKDIR/feature_counts
REFGENDIR="$WORKDIR/reference_genome"
REFGENOMEFILE="Mus_musculus.GRCm39.113.gtf" 


#Create the directory for the error and output file
mkdir -p $LOGDIR
mkdir -p $OUTDIR

#unzip the reference genome file 
gunzip $REFGENDIR/$REFGENOMEFILE.gz

#take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

#run feature counts
#Q10 set minimum read quality to 10%, only reads with MAPQ score of ≥10 will be considered
#T4 4 threads
#-p specifies that input data is pair-end reads
#-s2 specifies that input data is strand specific, and that the reverse strand (2) needs to be considered for feature assignment
apptainer exec --bind $WORKDIR /containers/apptainer/subread_2.0.1--hed695b0_0.sif featureCounts -T4 -p -s2 -Q10 -t exon -g gene_id -a $REFGENDIR/$REFGENOMEFILE -o "$OUTDIR/gene_count.txt" $BAMDIR/*sorted.bam