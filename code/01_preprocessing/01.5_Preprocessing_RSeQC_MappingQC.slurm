#!/bin/bash
#SBATCH --partition=cpu-single
#SBATCH --job-name=rseqc
#SBATCH --output=rseqc_%A_%a.log
#SBATCH --error=rseqc_%A_%a.err
#SBATCH --time=8:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --array=0-21%10


# activate environment containing STAR
source ~/miniforge3/etc/profile.d/conda.sh
conda activate slamseq

# define paths
PROJECTDIR=/mnt/sds-hd/sd22b002/projects/ines/cardio_slamseq
REFBEDSORTED=${PROJECTDIR}/reference/RSeQC/Mus_musculus.GRCm39.106.sorted.bed12

DATADIR=${PROJECTDIR}/data/Aligned.Reads
OUTDIR=${PROJECTDIR}/results/RSeQC

THREADS=${SLURM_CPUS_PER_TASK}

# Collect BAM files
FILES=("$DATADIR"/*Aligned.sortedByCoord.out.bam)
INPUT=${FILES[$SLURM_ARRAY_TASK_ID]}

# Extract sample name
sample=$(basename "$INPUT")
sample=${sample%%.Aligned.sortedByCoord.out.bam}

echo "Processing sample: $sample"
echo "Input file: $INPUT"
date

# Run bamstats
echo "Running bam_stat.py"
bam_stat.py -i "$INPUT" -q 30 > "$OUTDIR/${sample}_RSeQC_BamStats.txt"
date
echo "-----------------------------------------------------------------------"

# Run gene body coverage
echo "Running geneBody_coverage.py"
geneBody_coverage.py -r "$REFBEDSORTED" -i "$INPUT"  -o "$OUTDIR/${sample}"
date
echo "-----------------------------------------------------------------------"

# Run mismatch profile
echo "Running mismatch_profile.py"
mismatch_profile.py -l 97 -i "$INPUT" -o "$OUTDIR/${sample}" -n 50000000 -q 30
date
echo "-----------------------------------------------------------------------"

# Run read distribution
echo "Running read_distribution.py"
read_distribution.py -i "$INPUT" -r "$REFBEDSORTED" > "$OUTDIR/${sample}_RSeQC_ReadDistribution.txt"
date
echo "-----------------------------------------------------------------------"

# Run read duplication
echo "Running read_duplication.py"
read_duplication.py -i "$INPUT" -o "$OUTDIR/${sample}" -u 500 -q 30
date
echo "-----------------------------------------------------------------------"

# Run read GC
echo "Running reag_GC.py"
read_GC.py -i "$INPUT" -o "$OUTDIR/${sample}" -q 30 
date
echo "-----------------------------------------------------------------------"

echo "Finished sample: $sample"
date
