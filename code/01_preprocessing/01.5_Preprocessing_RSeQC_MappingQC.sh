#!/bin/bash

# Date of creation: 2023/09/22.
# Date of last modification: 2023/09/22.

## default variables
while getopts i:o:p:r: flag
do
    case "${flag}" in 
        p) projectdir=${OPTARG};; # NEEDED: /data_lab_MT/Ines/REANIMA_SlamSeq
        r) refbed=${OPTARG};; # NEEDED: Reference bed file (/data_lab_MT/Ines/REANIMA_SLAMseq_Experiments/Mmusculus_GRCm39_Ensembl106_GenomeFiles/Mus_musculus.GRCm39.106.gtf_galaxy.bed)
    esac
done

## creating paths
projectdir="/data_lab_MT/Ines/REANIMA_SlamSeq"
datadir="$projectdir/Aligned.Reads"
outdir="$datadir/RSeQC"

echo ">>> Running 01.5_Preprocessing_RSeQC_MappingQC.sh script" || exit 100 &&
echo "source ~/miniconda3.cluster.source && conda activate RSeQC &&" || exit 100 && 
source ~/miniconda3.cluster.source && conda activate RSeQC || exit 100 &&

echo "Program versions" || exit 100 &&
bam_stat.py --version || exit 100 &&
mismatch_profile.py --version || exit 100 &&
read_distribution.py --version || exit 100 &&
read_duplication.py --version || exit 100 &&
read_GC.py --version || exit 100 &&
tin.py --version || exit 100 &&

date +"%F %X" || exit 100 &&

echo "" || exit 100 &&
echo "" || exit 100 &&
echo "#############################  PARAMETERS ############################" || exit 100 &&
echo "" || exit 100 &&
echo "Project directory: $projectdir" || exit 100 &&
echo "Aligned reads directory: $datadir" || exit 100 &&
echo "Output directory: $outdir" || exit 100 &&
echo "Reference bed file: $refbed" || exit 100 &&
echo "" || exit 100 &&
echo "#######################################################################" || exit 100 &&
echo "" || exit 100 &&
echo "" || exit 100 &&


for source_file in "$datadir"/*Aligned.sortedByCoord.out.bam; do
    echo "$source_file"
    if [ -f "$source_file" ]; then
        inputfile=$(basename "$source_file")
        outputfile="${inputfile%.Aligned.sortedByCoord.out.bam}"
        echo ">>> Running QC for Sample $inputfile"
        echo "bam_stat.py -i $datadir/$inputfile -q 30 > '$outdir/$outputfile._RSeQC_BamStats.txt'"
        bam_stat.py -i $datadir/$inputfile -q 30 > "$outdir/$outputfile._RSeQC_BamStats.txt"
        echo "geneBody_coverage.py -r $refbed -i $datadir/$inputfile  -o $outdir/$outputfile"
        geneBody_coverage.py -r $refbed -i $datadir/$inputfile  -o "$outdir/$outputfile"
        echo "mismatch_profile.py -l 75 -i $datadir/$inputfile -o $outdir/$outputfile -n 50000000 -q 30"
        mismatch_profile.py -l 75 -i $datadir/$inputfile -o "$outdir/$outputfile" -n 50000000 -q 30
        echo "read_distribution.py -i $datadir/$inputfile -r $refbed > '$outdir/$outputfile.RSeQC_ReadDistribution.txt'"
        read_distribution.py -i $datadir/$inputfile -r $refbed > "$outdir/$outputfile.RSeQC_ReadDistribution.txt"
        echo "read_duplication.py -i $datadir/$inputfile -o $outdir/$outputfile -u 500 -q 30"
        read_duplication.py -i $datadir/$inputfile -o "$outdir/$outputfile" -u 500 -q 30
        echo "read_GC.py -i $datadir/$inputfile -o $outdir/$outputfile -q 30"
        read_GC.py -i $datadir/$inputfile -o "$outdir/$outputfile" -q 30 
        date +"%F %X"
    fi
done

echo 'DONE with all samples' || exit 100 &&
date +"%F %X"