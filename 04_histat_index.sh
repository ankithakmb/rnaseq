#!/usr/bin/env bash
#SBATCH --time=03:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=hisat_index
#SBATCH --output=/data/users/rkumble/rnaseq_course/log/04_hisat_index_%J.out
#SBATCH --error=/data/users/rkumble/rnaseq_course/log/04_hisat_index_%J.err
#SBATCH --partition=pibu_el8

#Variables 
WORKDIR="/data/users/${USER}/rnaseq_course/"
REFGENDIR="$WORKDIR/reference_genome"
LOGDIR="$WORKDIR/log"
INDEXDIR="$WORKDIR/index_hisat"
REFGENOMEFILE="Mus_musculus.GRCm39.dna.primary_assembly.fa"


#Create the directory for the error and output file
mkdir -p $LOGDIR

mkdir -p $INDEXDIR

#unzip the file for indexing 
gunzip $REFGENDIR/$REFGENOMEFILE.gz

#Run hisat
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif hisat2-build $REFGENDIR/$REFGENOMEFILE $INDEXDIR/genome_index