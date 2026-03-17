#!/bin/bash
#SBATCH --partition=cpu-single
#SBATCH --job-name=star_index_mm39
#SBATCH --output=star_index_mm39_%j.log
#SBATCH --error=star_index_mm39_%j.err
#SBATCH --time=08:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=40G

# activate environment containing STAR
source ~/miniforge3/etc/profile.d/conda.sh
conda activate slamseq

# Define paths
GENOME_DIR=/mnt/sds-hd/sd22b002/projects/ines/cardio_slamseq/reference/star_index_mm39_ensembl106
REF_DIR=/mnt/sds-hd/sd22b002/projects/ines/cardio_slamseq/reference/Mmusculus_GRCm39_Ensembl106_GenomeFiles/

FASTA=${REF_DIR}/Mus_musculus.GRCm39.dna.primary_assembly.fa
GTF=${REF_DIR}/Mus_musculus.GRCm39.106.gtf

THREADS=${SLURM_CPUS_PER_TASK}


# Run STAR genomeGenerate

STAR --runThreadN ${THREADS} --runMode genomeGenerate --genomeDir ${GENOME_DIR} --genomeFastaFiles ${FASTA} --sjdbGTFfile ${GTF} --sjdbOverhang 100

# Done
echo "STAR genome index completed"
