#!/bin/bash

# BOWTIE SHELL SCRIPT FOR ORBIT FUSION LIBRARIES
#

# PARAMS


bowtie2-build --quiet pa14_genome.fasta pa14_ref_genome 


for f in cutadapt_0/*R1*fastq.gz
#for f in cutadapt/T0-1_stop_R1.fastq.gz

do 
    
    FILENAME=$(basename -s _R1.fastq.gz "$f")
    echo ${FILENAME}
    
    #default mode is end to end
    bowtie2 -p 32 -x pa14_ref_genome -1 "cutadapt_0/${FILENAME}_R1.fastq.gz" -2 "cutadapt_0/${FILENAME}_R2.fastq.gz" --no-unal 2> "bowtie_paired/${FILENAME}_bowtie.txt" | samtools view -bh > "bowtie_paired/${FILENAME}.bam"

    
done