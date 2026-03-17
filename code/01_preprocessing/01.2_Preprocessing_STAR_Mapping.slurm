#!/bin/bash
#SBATCH --partition=cpu-single
#SBATCH --job-name=star_align
#SBATCH --output=star_align_%A_%a.log
#SBATCH --error=star_align_%A_%a.err
#SBATCH --time=4:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --array=0-21%4


# activate environment containing STAR
source ~/miniforge3/etc/profile.d/conda.sh
conda activate slamseq

# define paths
PROJECTDIR=/mnt/sds-hd/sd22b002/projects/ines/cardio_slamseq
GENOMEDIR=/mnt/sds-hd/sd22b002/projects/ines/cardio_slamseq/reference/star_index_mm39_ensembl106

DATADIR=${PROJECTDIR}/data/Processed.Reads
OUTDIR=${PROJECTDIR}/data/Aligned.Reads

THREADS=${SLURM_CPUS_PER_TASK}

# Get fastq file
FILES=("$DATADIR"/*.fastq.gz)

INPUT=${FILES[$SLURM_ARRAY_TASK_ID]}

sample=$(basename "$INPUT")
sample=${sample%%.fastq.gz}

echo "Processing sample: $sample"
echo "Input file: $INPUT"
echo "Threads: $THREADS"
date

# Run STAR
STAR --runMode alignReads --runThreadN "$THREADS" --readFilesIn "$INPUT" --readFilesCommand zcat --genomeDir "$GENOMEDIR" --outSAMattributes NM MD NH --outSAMtype BAM SortedByCoordinate --alignEndsType EndToEnd --outFileNamePrefix "$OUTDIR/${sample}."

echo "Finished sample: $sample"
date
