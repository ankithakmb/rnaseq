#!/usr/bin/env bash
#SBATCH --time=00:10:00
#SBATCH --mem=10M
#SBATCH --cpus-per-task=1
#SBATCH --job-name=get_reference
#SBATCH --output=/data/users/rkumble/rnaseq_course/log/03_get_reference_%J.out
#SBATCH --error=/data/users/rkumble/rnaseq_course/log/03_get_reference_%J.err
#SBATCH --partition=pibu_el8

# Variables 
WORKDIR="/data/users/rkumble/rnaseq_course/"
REFGENDIR="$WORKDIR/reference_genome"
LOGDIR="$WORKDIR/log"

#Create the directory for the error and output file
mkdir -p $LOGDIR
mkdir -p $REFGENDIR

#cd into folder with the reference genome and download fa and gff file from ensembl
cd $REFGENDIR
wget https://ftp.ensembl.org/pub/release-113/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
wget https://ftp.ensembl.org/pub/release-113/gtf/mus_musculus/Mus_musculus.GRCm39.113.gtf.gz

#Verify the integrity of the files (to detect any corruption)
echo "Checksum for fasta file"
sum $REFGENDIR/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
echo "Checksum for gtf file"
sum $REFGENDIR/Mus_musculus.GRCm39.113.gtf.gz 