#!/bin/bash

# CUTADAPT SHELL SCRIPT FOR ORBIT FUSION LIBRARIES
# This cutadapt script "demultiplexes" fusion and stop adapters using a very strict error rate and puts the reads in separate files

# PARAMS
#   NAMED LINKED ADAPTERS: -a stop="" | -a fusion="" | These are named linked adapters. Only read 1 is being searched, so the ORBIT sequence in read 1 is required, while the ligated adapter is optional. Neither sequence is anchored, we just want everyting in between.
#   TIMES: -n 1 | only remove 1 set of adapters per read
#   MINIMUM LENGTH: -m 20 | do not retain any trimmed sequence with less than 20 bp of putative genomic sequence
#   ERROR RATE: -e 0.015 | for the long ORBIT "adapter" att sequences corresponds to only a single bp error in the whole sequence. Therefore we can confidently differentiate stops from fusions
#   MULTICORE: --cores=32 | multicore commands work for cutadapt including "demultiplexing." On biohpc 128 GB node will try 32 cores.
#   DISCARD: --discard-untrimmed | do not keep reads that do not have detected adapters. If you want to inspect reads that didn't have correct adapters need to change this.
#   OUTPUT: -o
#   REPORT: --report=minimal > ".tsv" print a minimal report to tsv

for f in fastp_paired/*R1*fastq.gz
#for f in fastp_paired/fastp_T0-1_R1.fastq.gz

do

    FILENAME=$(basename -s _R1.fastq.gz "$f")
    echo ${FILENAME:6}
   # echo $f

    cutadapt -G CTACAAGAGCGGTGAGt -g stop="gaagcagctccagcctacacttaagctgctaaagcgtagttttcgtcgtttgctgcTTAtaggtttgtaccgtacaccactgagaccgccgtcgtcgacaagcc" -g ASV="tctagaaagtataggaacttcgaagcagctccagcctacacTTAAACTGATGCAGCGTAGTTTTCGTCGTTTGCTGCtaggtttgtaccgtacaccactgagaccgccgtcgtcgacaagcc" -g LAA="tctagaaagtataggaacttcgaagcagctccagcctacacTTAAGCTGCTAAAGCGTAGTTTTCGTCGTTTGCTGCtaggtttgtaccgtacaccactgagaccgccgtcgtcgacaagcc" -g LVA="tctagaaagtataggaacttcgaagcagctccagcctacacTTAAGCTACTAAAGCGTAGTTTTCGTCGTTTGCTGCtaggtttgtaccgtacaccactgagaccgccgtcgtcgacaagcc" -n 1 -m 20:20 -e 0 --cores=32 --discard-untrimmed "fastp_paired/${FILENAME}_R1.fastq.gz" "fastp_paired/${FILENAME}_R2.fastq.gz" -o "cutadapt_0/${FILENAME:6}_{name}_R1.fastq.gz" -p "cutadapt_0/${FILENAME:6}_{name}_R2.fastq.gz" --report=minimal > "cutadapt_0/${FILENAME:6}_cutadapt.tsv"
done

