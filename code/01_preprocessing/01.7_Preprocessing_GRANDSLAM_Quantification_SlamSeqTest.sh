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
echo "Copying 6h files" || exit 100 &&
cp "$datadir/6hours_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/6hours_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
echo "Copying 12h files" || exit 100 &&
cp "$datadir/12hours_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/12hours_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
echo "Cppying 24h files" || exit 100 &&
cp "$datadir/24hours_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/24hours_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&
echo "Copying 0h files" || exit 100 &&
cp "$datadir/Null_0_R1.Aligned.sortedByCoord.out.bam" /tmp ||exit 100 &&
cp "$datadir/Null_0_R1.Aligned.sortedByCoord.out.bam.bai" /tmp ||exit 100 &&

# STEP 2: Prepare cit file for SlamSeqTest
echo "STEP2: prepare .CIT files for GRAND-SLAM" || exit 100 &&
echo "/home/iriverog/GRAND-SLAM_2.0.5f/gedi -e Bam2CIT -p cardio_slamseq_test.cit Null_0_R1.Aligned.sortedByCoord.out.bam 6hours_R1.Aligned.sortedByCoord.out.bam 12hours_R1.Aligned.sortedByCoord.out.bam 24hours_R1.Aligned.sortedByCoord.out.bam"|| exit 100 &&
/Volumes/INTENSO/GRAND-SLAM_2.0.5f/gedi -e Bam2CIT -p cardio_slamseq_test.cit Null_0_R1.Aligned.sortedByCoord.out.bam 6hours_R1.Aligned.sortedByCoord.out.bam 12hours_R1.Aligned.sortedByCoord.out.bam 24hours_R1.Aligned.sortedByCoord.out.bam || exit 100 &&

# STEP 3: Run GRAND-SLAM
echo "STEP 3: Run GRAND-SLAM" || exit 100 &&
echo "/Volumes/INTENSO/GRAND-SLAM_2.0.5f/gedi -e Slam -genomic mus_musculus.106 -prefix cardio_slamseq_test -progress -plot -D -full -nthreads 4 -trim5p 10 -no4sUpattern Null -reads cardio_slamseq_test.cit" ||exit 100 &&
/Volumes/INTENSO/GRAND-SLAM_2.0.5f/gedi -e Slam -genomic mus_musculus.106 -prefix cardio_slamseq_test -progress -plot -D -full -nthreads 4 -trim5p 10 -no4sUpattern Null -reads cardio_slamseq_test.cit || exit 100 &&

# STEP 4: copy GRANDSLAM results to hard drive
echo "STEP 4: copy output files to $outdir" || exit 100 &&
cp "/tmp/cardio_slamseq_test*" "$outdir"

echo"DONE!" || exit 100 &&

#### OLD! WILL BE REMOVED!
#echo "STEP1: PREPARE .CIT FILES" || exit 100 &&
#echo "/home/iriverog/GRAND-SLAM_2.0.5f/gedi -e Bam2CIT -p REANIMA_SlamSeq_AllSamples_20231010.cit 12hours.Aligned.sortedByCoord.out.bam 24hours.Aligned.sortedByCoord.out.bam 6hours.Aligned.sortedByCoord.out.bam Downsample1_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample1_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample1_Null_3_trimmedAligned.sortedByCoord.out.bam Downsample2_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample2_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample2_Null_3_trimmedAligned.sortedByCoord.out.bam Downsample3_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample3_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample3_Null_3_trimmedAligned.sortedByCoord.out.bam Downsample4_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample4_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample4_Null_3_trimmedAligned.sortedByCoord.out.bam Downsample5_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample5_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample5_Null_3_trimmedAligned.sortedByCoord.out.bam Erbb2_1.Aligned.sortedByCoord.out.bam Erbb2_2.Aligned.sortedByCoord.out.bam Erbb2_3.Aligned.sortedByCoord.out.bam GFP_1.1.Aligned.sortedByCoord.out.bam GFP_1.2.Aligned.sortedByCoord.out.bam GFP_1.3.Aligned.sortedByCoord.out.bam GFP_2.1.Aligned.sortedByCoord.out.bam GFP_2.2.Aligned.sortedByCoord.out.bam GFP_2.3.Aligned.sortedByCoord.out.bam mir199_1.1.Aligned.sortedByCoord.out.bam mir199_1.2.Aligned.sortedByCoord.out.bam mir199_1.3.Aligned.sortedByCoord.out.bam mir199_2.1.Aligned.sortedByCoord.out.bam mir199_2.2.Aligned.sortedByCoord.out.bam mir199_2.3.Aligned.sortedByCoord.out.bam mir590_1.1.Aligned.sortedByCoord.out.bam mir590_1.2.Aligned.sortedByCoord.out.bam mir590_1.3.Aligned.sortedByCoord.out.bam mir590_2.1.Aligned.sortedByCoord.out.bam mir590_2.2.Aligned.sortedByCoord.out.bam mir590_2.3.Aligned.sortedByCoord.out.bam Myc_1.Aligned.sortedByCoord.out.bam Myc_2.Aligned.sortedByCoord.out.bam Myc_3.Aligned.sortedByCoord.out.bam Null_0.Aligned.sortedByCoord.out.bam Null_1.Aligned.sortedByCoord.out.bam Null_2.Aligned.sortedByCoord.out.bam Null_3.Aligned.sortedByCoord.out.bam YAP_1.Aligned.sortedByCoord.out.bam YAP_2.Aligned.sortedByCoord.out.bam YAP_3.Aligned.sortedByCoord.out.bam" || exit 100 &&
#/home/iriverog/GRAND-SLAM_2.0.5f/gedi -e Bam2CIT -p REANIMA_SlamSeq_AllSamples_20231010.cit 12hours.Aligned.sortedByCoord.out.bam 24hours.Aligned.sortedByCoord.out.bam 6hours.Aligned.sortedByCoord.out.bam Downsample1_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample1_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample1_Null_3_trimmedAligned.sortedByCoord.out.bam Downsample2_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample2_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample2_Null_3_trimmedAligned.sortedByCoord.out.bam Downsample3_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample3_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample3_Null_3_trimmedAligned.sortedByCoord.out.bam Downsample4_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample4_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample4_Null_3_trimmedAligned.sortedByCoord.out.bam Downsample5_Null_0_trimmedAligned.sortedByCoord.out.bam Downsample5_Null_1_trimmedAligned.sortedByCoord.out.bam Downsample5_Null_3_trimmedAligned.sortedByCoord.out.bam Erbb2_1.Aligned.sortedByCoord.out.bam Erbb2_2.Aligned.sortedByCoord.out.bam Erbb2_3.Aligned.sortedByCoord.out.bam GFP_1.1.Aligned.sortedByCoord.out.bam GFP_1.2.Aligned.sortedByCoord.out.bam GFP_1.3.Aligned.sortedByCoord.out.bam GFP_2.1.Aligned.sortedByCoord.out.bam GFP_2.2.Aligned.sortedByCoord.out.bam GFP_2.3.Aligned.sortedByCoord.out.bam mir199_1.1.Aligned.sortedByCoord.out.bam mir199_1.2.Aligned.sortedByCoord.out.bam mir199_1.3.Aligned.sortedByCoord.out.bam mir199_2.1.Aligned.sortedByCoord.out.bam mir199_2.2.Aligned.sortedByCoord.out.bam mir199_2.3.Aligned.sortedByCoord.out.bam mir590_1.1.Aligned.sortedByCoord.out.bam mir590_1.2.Aligned.sortedByCoord.out.bam mir590_1.3.Aligned.sortedByCoord.out.bam mir590_2.1.Aligned.sortedByCoord.out.bam mir590_2.2.Aligned.sortedByCoord.out.bam mir590_2.3.Aligned.sortedByCoord.out.bam Myc_1.Aligned.sortedByCoord.out.bam Myc_2.Aligned.sortedByCoord.out.bam Myc_3.Aligned.sortedByCoord.out.bam Null_0.Aligned.sortedByCoord.out.bam Null_1.Aligned.sortedByCoord.out.bam Null_2.Aligned.sortedByCoord.out.bam Null_3.Aligned.sortedByCoord.out.bam YAP_1.Aligned.sortedByCoord.out.bam YAP_2.Aligned.sortedByCoord.out.bam YAP_3.Aligned.sortedByCoord.out.bam

# Move CIT file to GRANDSLAM folder
#mv "$datadir/REANIMA_SlamSeq_AllSamples_20231010.cit" "$outdir/REANIMA_SlamSeq_AllSamples_20231010.cit"
#mv "$datadir/REANIMA_SlamSeq_AllSamples_20231010.cit.metadata.json" "$outdir/REANIMA_SlamSeq_AllSamples_20231010.cit.metadata.json"
#cd $outdir

#echo "STEP2: INDEX THE GENOME" || exit 100 &&
#echo "/home/iriverog/GRAND-SLAM_2.0.5f/gedi -e IndexGenome -organism mus_musculus -version 106 -p -nobowtie -nokallisto" || exit 100 &&
#/home/iriverog/GRAND-SLAM_2.0.5f/gedi -e IndexGenome -organism mus_musculus -version 106 -p -nobowtie -nokallisto

#echo "STEP 3: RUN GRAND-SLAM" || exit 100 &&
#echo "/home/iriverog/GRAND-SLAM_2.0.5f/gedi -e Slam -genomic mus_musculus.106 -prefix REANIMA_SlamSeq_2023-10-11 -progress -plot -D -full -nthreads 4 -trim5p 10 -no4sUpattern Downsample -reads REANIMA_SlamSeq_AllSamples_20231010.cit" || exit 100 &&
#/home/iriverog/GRAND-SLAM_2.0.5f/gedi -e Slam -genomic mus_musculus.106 -prefix REANIMA_SlamSeq_2023-10-11 -progress -plot -D -full -nthreads 1 -trim5p 10 -no4sUpattern Downsample -reads REANIMA_SlamSeq_AllSamples_20231010.cit
#echo "DONE"

#echo "STEP 4: CLEAN FILES" || exit 100 &&
#echo "" || exit 100 &&


# Updated protocol (Currently checking if step 3 works)
# 1. Activate conda slamseq
#conda activate slamseq
# 2. Copy bam and bam.bai to /tmp

# 3. Prepare CIT in /tmp

# 5. Run GRANDSLAM in /tmp
#/Volumes/INTENSO/GRAND-SLAM_2.0.5f/gedi -e Slam -genomic mus_musculus.106 -prefix test -progress -plot -D -full -nthreads 1 -trim5p 10 -no4sUpattern Null -reads test.cit

# 6. Cp GRANDSLAM files (cits and results) to good dir

# 7. Rm bam and bam.bai from tmp
#rm *.bam.bai
#rm *.bam
#rm *.cit
#rm Mus_musculus.GRCm39.106.gtf
#rm Mus_musculus.GRCm39.dna.primary_assembly.fa
