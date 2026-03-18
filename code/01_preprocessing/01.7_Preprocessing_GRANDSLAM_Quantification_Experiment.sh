#!/bin/bash

# Date of creation: 2023/10/03.
# Date of last modification: 2026/03/16.

## creating paths
datadir="/Volumes/INTENSO/PhD/cardio_slamseq/data/Aligned.Reads"
outdir="/Volumes/INTENSO/PhD/cardio_slamseq/data/GRAND-SLAM"

echo ">>> Running 01.5_Preprocessing_GRANDSLAM_Quantification.sh script" || exit 100 &&
#echo "conda activate slamseq"
#conda activate slamseq

# STEP 1: Copy bam and bam.bai files to /tmp
echo "STEP 1: Copying bam files to tmp" ||exit 100 &&
echo "Copying ERBB2 files" || exit 100 &&
cp "$datadir/ERBB2_1_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/ERBB2_1_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/ERBB2_2_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/ERBB2_2_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/ERBB2_3_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/ERBB2_3_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&

echo "Copying GFP files" || exit 100 &&
cp "$datadir/GFP_1.1_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/GFP_1.1_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/GFP_1.2_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/GFP_1.2_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/GFP_1.3_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/GFP_1.3_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/GFP_2.1_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/GFP_2.1_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/GFP_2.2_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/GFP_2.2_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/GFP_2.3_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/GFP_2.3_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&

echo "Cppying MYC files" || exit 100 &&
cp "$datadir/MYC_1_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/MYC_1_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/MYC_2_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/MYC_2_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/MYC_3_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/MYC_3_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&

echo "Copying Null files" || exit 100 &&
cp "$datadir/Null_1_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/Null_1_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/Null_2_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/Null_2_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
cp "$datadir/Null_3_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/Null_3_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&

echo "Copying YAP files" || exit 100 &&
cp "$datadir/YAP_1_R1.Aligned.sortedByCoord.out.bam" /tmp || exit 100 &&
cp "$datadir/YAP_1_R1.Aligned.sortedByCoord.out.bam.bai" /tmp || exit 100 &&
cp "$datadir/YAP_2_R1.Aligned.sortedByCoord.out.bam" /tmp || exit 100 &&
cp "$datadir/YAP_2_R1.Aligned.sortedByCoord.out.bam.bai" /tmp || exit 100 &&
cp "$datadir/YAP_3_R1.Aligned.sortedByCoord.out.bam" /tmp || exit 100 &&
cp "$datadir/YAP_3_R1.Aligned.sortedByCoord.out.bam.bai" /tmp || exit 100 &&

# STEP 2: Prepare cit file for SlamSeqTest
echo "STEP2: prepare .CIT files for GRAND-SLAM" || exit 100 &&
echo "/home/iriverog/GRAND-SLAM_2.0.5f/gedi -e Bam2CIT -p cardio_experiment.cit ERBB2_1_R1.Aligned.sortedByCoord.out.bam ERBB2_2_R1.Aligned.sortedByCoord.out.bam ERBB2_3_R1.Aligned.sortedByCoord.out.bam GFP_1.1_R1.Aligned.sortedByCoord.out.bam GFP_1.2_R1.Aligned.sortedByCoord.out.bam GFP_1.3_R1.Aligned.sortedByCoord.out.bam GFP_2.1_R1.Aligned.sortedByCoord.out.bam GFP_2.2_R1.Aligned.sortedByCoord.out.bam GFP_2.3_R1.Aligned.sortedByCoord.out.bam MYC_1_R1.Aligned.sortedByCoord.out.bam MYC_2_R1.Aligned.sortedByCoord.out.bam MYC_3_R1.Aligned.sortedByCoord.out.bam Null_1_R1.Aligned.sortedByCoord.out.bam Null_2_R1.Aligned.sortedByCoord.out.bam Null_3_R1.Aligned.sortedByCoord.out.bam YAP_1_R1.Aligned.sortedByCoord.out.bam YAP_2_R1.Aligned.sortedByCoord.out.bam YAP_3_R1.Aligned.sortedByCoord.out.bam"|| exit 100 &&
/Volumes/INTENSO/GRAND-SLAM_2.0.5f/gedi -e Bam2CIT -p cardio_slamseq_experiment.cit ERBB2_1_R1.Aligned.sortedByCoord.out.bam ERBB2_2_R1.Aligned.sortedByCoord.out.bam ERBB2_3_R1.Aligned.sortedByCoord.out.bam GFP_1.1_R1.Aligned.sortedByCoord.out.bam GFP_1.2_R1.Aligned.sortedByCoord.out.bam GFP_1.3_R1.Aligned.sortedByCoord.out.bam GFP_2.1_R1.Aligned.sortedByCoord.out.bam GFP_2.2_R1.Aligned.sortedByCoord.out.bam GFP_2.3_R1.Aligned.sortedByCoord.out.bam MYC_1_R1.Aligned.sortedByCoord.out.bam MYC_2_R1.Aligned.sortedByCoord.out.bam MYC_3_R1.Aligned.sortedByCoord.out.bam Null_1_R1.Aligned.sortedByCoord.out.bam Null_2_R1.Aligned.sortedByCoord.out.bam Null_3_R1.Aligned.sortedByCoord.out.bam YAP_1_R1.Aligned.sortedByCoord.out.bam YAP_2_R1.Aligned.sortedByCoord.out.bam YAP_3_R1.Aligned.sortedByCoord.out.bam || exit 100 &&

# STEP 3: Run GRAND-SLAM
echo "STEP 3: Run GRAND-SLAM" || exit 100 &&
echo "/Volumes/INTENSO/GRAND-SLAM_2.0.5f/gedi -e Slam -genomic mus_musculus.106 -prefix cardio_slamseq_experiment -progress -plot -D -full -nthreads 4 -trim5p 10 -no4sUpattern Null -reads cardio_slamseq_experiment.cit" ||exit 100 &&
/Volumes/INTENSO/GRAND-SLAM_2.0.5f/gedi -e Slam -genomic mus_musculus.106 -prefix cardio_slamseq_experiment -progress -plot -D -full -nthreads 4 -trim5p 10 -no4sUpattern Null -reads cardio_slamseq_experiment.cit || exit 100 &&

# STEP 4: copy GRANDSLAM results to hard drive
echo "STEP 4: copy output files to $outdir" || exit 100 &&
echo"DONE!"
