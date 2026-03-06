#!/bin/bash
# Date of creation: 2023/02/16.
# Date of last modification: 2023/09/19.

while getopts t:g:p:r:o: flag
do
    case "${flag}" in 
        g) genomedir=${OPTARG};;  # NEEDED: /data_lab_MT/Ines/REANIMA_SlamSeq/Mmusculus_GRCm39_Ensembl106_GenomeFiles
        p) projectdir=${OPTARG};; # NEEDED: /data_lab_MT/Ines/REANIMA_SlamSeq
    esac
done

## creating paths
datadir="$projectdir/Processed.Reads"
outdir="$projectdir/Aligned.Reads"

echo ">>> Running 01.2_Preprocessing_Mapping_STAR.sh script" || exit 100 &&
echo "source ~/miniconda3.cluster.source && conda activate star-mapper &&" || exit 100 && 
source ~/miniconda3.cluster.source && conda activate star-mapper || exit 100 &&
STAR --version || exit 100 &&
date +"%F %X" || exit 100 &&

echo "" || exit 100 &&
echo "" || exit 100 &&
echo "#############################  PARAMETERS ############################" || exit 100 &&
echo "" || exit 100 &&
echo "Project directory: $projectdir" || exit 100 &&
echo "Processed reads directory: $datadir" || exit 100 &&
echo "Aligned reads directory: $outdir" || exit 100 &&
echo "Genome directory: $genomedir" || exit 100 &&
echo "" || exit 100 &&
echo "#######################################################################" || exit 100 &&
echo "" || exit 100 &&
echo "" || exit 100 &&

for source_file in "$datadir"/*.gz; do
    if [ -f "$source_file" ]; then
        inputfile=$(basename "$source_file")
        outputfile="${inputfile%%.fastq.gz}"
        echo ">>> Aligning reads in sample: $outputfile"
        echo "STAR --runMode alignReads --runThreadN 1 --readFilesIn $datadir/$inputfile --readFilesCommand zcat --genomeDir $genomedir --outSAMattributes NM MD NH --outSAMtype BAM SortedByCoordinate --alignEndsType EndToEnd --outFileNamePrefix $outdir/$outputfile"
        STAR --runMode "alignReads" --runThreadN 1 --readFilesIn "$datadir/$inputfile" --readFilesCommand "zcat" --genomeDir "$genomedir" --outSAMattributes "NM" "MD" "NH" --outSAMtype "BAM" "SortedByCoordinate" --alignEndsType "EndToEnd" --outFileNamePrefix "$outdir/$outputfile"
        date +"%F %X"
    fi
done

echo 'DONE with all samples' || exit 100 &&
date +"%F %X"
