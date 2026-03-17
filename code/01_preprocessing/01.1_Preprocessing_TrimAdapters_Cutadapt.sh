#!/bin/bash
# Date of creation: 2023/02/15.
# Date of last modification: 2026/03/10.

echo ">>> Running 01.1_Preprocessing_TrimAdapters_Cutadapt.sh script" || exit 100 &&
date +"%F %X" || exit 100 && 


source="/Volumes/INTENSO/PhD/cardio_slamseq/data/Raw.Reads"
destination="/Volumes/INTENSO/PhD/cardio_slamseq/data/Processed.Reads"

for source_file in "$source"/*.gz; do
    if [ -f "$source_file" ]; then
        filename=$(basename "$source_file")
        echo ">>> Trimming adapters in sample: $filename"
        echo "cutadapt -m 30 --match-read-wildcards -o 7 -q 0 -o $destination/$filename -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -a GATCGGAAGAGCACACGTCTGAACTCCAGTCAC $source/$filename"
        cutadapt -m 30 --match-read-wildcards -o 7 -q 0 -o $destination/$filename -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -a GATCGGAAGAGCACACGTCTGAACTCCAGTCAC $source/$filename
        date +"%F %X"
    fi
done


echo ">>> QC after trimming adapters" || exit 100 &&
echo "fastqc $destination/*" || exit 100 &&
fastqc "$destination"/* || exit 100 &&

echo "DONE" || exit 100 &&
date +"%F %X"