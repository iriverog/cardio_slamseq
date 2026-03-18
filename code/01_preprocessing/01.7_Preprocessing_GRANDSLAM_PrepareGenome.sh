#!/bin/bash

# Date of creation: 2023/10/03.
# Date of last modification: 2026/03/13.

## creating paths
projectdir="/Volumes/INTENSO/PhD/cardio_slamseq"
tmpdir="/tmp"
datadir="$projectdir/reference/Mmusculus_GRCm39_Ensembl106_GenomeFiles"

conda activate slamseq || exit 100 &&

cd "$tmpdir"

echo "STEP 1: Copying genome files to /tmp (GRAND-SLAM does not work on external drive)" || exit 100 &&
cp "$datadir/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz" .
cp "$datadir/Mmusculus_GRCm39_Ensembl106_GenomeFiles/Mus_musculus.GRCm39.106.gtf.gz" .

gunzip Mus_musculus.GRCm39.dna.primary_assembly.fa.gz 
gunzip Mus_musculus.GRCm39.106.gtf.gz

echo "STEP 2: Preparing gedi genome" || exit 100 &&
echo "/Volumes/INTENSO/GRAND-SLAM_2.0.5f/gedi -e IndexGenome -s Mus_musculus.GRCm39.dna.primary_assembly.fa -a Mus_musculus.GRCm39.106.gtf -n mus_musculus.106 -p -nobowtie -nokallisto"
/Volumes/INTENSO/GRAND-SLAM_2.0.5f/gedi -e IndexGenome -s Mus_musculus.GRCm39.dna.primary_assembly.fa -a Mus_musculus.GRCm39.106.gtf -n mus_musculus.106 -p -nobowtie -nokallisto
