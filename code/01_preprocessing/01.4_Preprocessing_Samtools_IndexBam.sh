#!/bin/bash
# Date of creation: 2023/09/22.
# Date of last modification: 2023/10/11.

echo ">>> Running 01.3_Preprocessing_Samtools_IndexBam.sh script" || exit 100 &&
~/samtools-1.15/bin/samtools --version|| exit 100 &&
date +"%F %X" || exit 100 && 

datadir="/data_lab_MT/Ines/REANIMA_SlamSeq/Aligned.Reads"

for source_file in "$datadir"/*Aligned.sortedByCoord.out.bam; do
    echo "~/samtools-1.15/bin/samtools index $source_file"
    ~/samtools-1.15/bin/samtools index $source_file
    date +"%F %X"
done