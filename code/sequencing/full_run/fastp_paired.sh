#!/bin/bash

#before running, need to activate conda module:
# >module load python/3.4.x-anaconda
#then need to activate conda env bioinfo_env:
# >source activate bioinfo_env
#test with fastp command:
# > fastp
# should show full instructions

# FASTP SHELL SCRIPT FOR ORBIT FUSION LIBRARIES
# This fastp script does basic quality control on the .fastq files. Including default length and quality score cutoffs. It also places UMIs in the read headers. It does not remove PCR duplicates at present

# PARAMS
#   CORES: -w 16 | Note fastp can only use a max of 16 cores even on biohpc, run time is surely limited by file IO and not computation. Could probably speed up using different strategy.
#   UMI: --umi_loc=read2 --umi_len=8 | these flags specify the location and length of the UMI. UMI should be placed in read headers
#   File inputs: -i -I | reads 1 and 2
#   File outputs: -o "...fastq.gz" -O "/dev/null" | read 1 output to file. Read 2 is currently discarded.
#   REPORT: -h "...html" -json /dev/null | html report is saved, json report is discarded
# NOTES: For Novaseq files of ~200M reads each, script takes ~10 miin

for f in ../2025_10_22_PA_hypo_NGS_data/*R1*.gz
#for f in ../2025_10_22_PA_hypo_NGS_data/T0-1_R1_001.fastq.gz
do 
    
    FILENAME=$(basename -s _R1_001.fastq.gz "$f")
    echo ${FILENAME}
    #option -D for deduplicate not enabled
    #only R1 processed is kept for now
    #umi information from read 2 is put into header for each read for later use if needed
    
    fastp -w 16 --umi_loc=read2 --umi_len=8 -i "$f" -I "../2025_10_22_PA_hypo_NGS_data/${FILENAME}_R2_001.fastq.gz"   -o "fastp_paired/fastp_${FILENAME}_R1.fastq.gz" -O "fastp_paired/fastp_${FILENAME}_R2.fastq.gz" -h "fastp_paired/fastp_${FILENAME}.html" --json /dev/null
    #fastp -w 16 --umi_loc=read2 --umi_len=8 -i "$f"   -o "../fastp/fastp_${FILENAME}_R1.fastq.gz" -h "../fastp/fastp_${FILENAME}.html" --json /dev/null
    
done