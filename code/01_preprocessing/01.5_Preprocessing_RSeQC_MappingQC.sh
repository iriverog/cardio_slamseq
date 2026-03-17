#!/bin/bash

# Date of creation: 2023/09/22.
# Date of last modification: 2026/03/17.

## creating paths
projectdir="/Volumes/INTENSO/PhD/cardio_slamseq"
datadir="$projectdir/data/Aligned.Reads"
outdir="$projectdir/results/01_preprocessing/RSeQC"
refanno="$projectdir/reference/GRAND-SLAM/Mus_musculus.GRCm39.106.gtf"
genepred="$projectdir/reference/RSeQC/Mus_musculus.GRCm39.106.genePred"
refbed="$projectdir/reference/RSeQC/Mus_musculus.GRCm39.106.bed12"
refbedsorted="$projectdir/reference/RSeQC/Mus_musculus.GRCm39.106.sorted.bed12"

echo ">>> Running 01.5_Preprocessing_RSeQC_MappingQC.sh script" || exit 100 &&

echo "Program versions" || exit 100 &&
bam_stat.py --version || exit 100 &&
mismatch_profile.py --version || exit 100 &&
read_distribution.py --version || exit 100 &&
read_duplication.py --version || exit 100 &&
read_GC.py --version || exit 100 &&

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

echo "Preparing annotation bed" || exit 100 &&
echo "gtfToGenePred $refanno $genepred" || exit 100 &&
gtfToGenePred "$refanno" "$genepred" || exit 100 &&
echo "genePredToBed $genepred $refbed" || exit 100 &&
genePredToBed "$genepred" "$refbed"  || exit 100 &&
echo "sort -k1,1 -k2,2n $refbed > $refbedsorted" || exit 100 &&
sort -k1,1 -k2,2n "$refbed" > "$refbedsorted"

for source_file in "$datadir"/*Aligned.sortedByCoord.out.bam; do
    echo "$source_file"
    if [ -f "$source_file" ]; then
        inputfile=$(basename "$source_file")
        outputfile="${inputfile%.Aligned.sortedByCoord.out.bam}"
        echo ">>> Running QC for Sample $inputfile"
        echo "bam_stat.py -i $datadir/$inputfile -q 30 > '$outdir/$outputfile._RSeQC_BamStats.txt'"
        bam_stat.py -i $datadir/$inputfile -q 30 > "$outdir/$outputfile._RSeQC_BamStats.txt"
        echo "geneBody_coverage.py -r $refbedsorted -i $datadir/$inputfile  -o $outdir/$outputfile"
        geneBody_coverage.py -r $refbedsorted -i $datadir/$inputfile  -o "$outdir/$outputfile"
        echo "mismatch_profile.py -l 100 -i $datadir/$inputfile -o $outdir/$outputfile -n 50000000 -q 30"
        mismatch_profile.py -l 100 -i $datadir/$inputfile -o "$outdir/$outputfile" -n 50000000 -q 30
        echo "read_distribution.py -i $datadir/$inputfile -r $refbedsorted > '$outdir/$outputfile.RSeQC_ReadDistribution.txt'"
        read_distribution.py -i $datadir/$inputfile -r $refbedsorted > "$outdir/$outputfile.RSeQC_ReadDistribution.txt"
        echo "read_duplication.py -i $datadir/$inputfile -o $outdir/$outputfile -u 500 -q 30"
        read_duplication.py -i $datadir/$inputfile -o "$outdir/$outputfile" -u 500 -q 30
        echo "read_GC.py -i $datadir/$inputfile -o $outdir/$outputfile -q 30"
        read_GC.py -i $datadir/$inputfile -o "$outdir/$outputfile" -q 30 
        date +"%F %X"
    fi
done

echo 'DONE with all samples' || exit 100 &&
date +"%F %X"