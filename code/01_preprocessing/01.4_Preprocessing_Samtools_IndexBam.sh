#!/bin/bash
# Date of creation: 2023/09/22.
# Date of last modification: 2026/03/13.

echo ">>> Running 01.4_Preprocessing_Samtools_IndexBam.sh script" || exit 100 &&

#echo "conda activate slamseq" || exit 100 &&
#conda init || exit 100 &&
#conda activate slamseq || exit 100 &&

samtools --version || exit 100 &&

date +"%F %X" || exit 100 && 

datadir="/Volumes/INTENSO/PhD/cardio_slamseq/data/Aligned.Reads"

for source_file in "$datadir"/*Aligned.sortedByCoord.out.bam; do
    echo "samtools index $source_file"
    samtools index $source_file
    date +"%F %X"
done

echo "DONE!"