

# run from command line:
#>R
#>library(tidyverse)
#>library(GenomicAlignments)

#if needed:
#>#>#install.packages(c("tidyverse", "GenomicAlignments"))
#>
#>source('bam_agg.R')
#>

library(tibble)
library(dplyr)
library(GenomicAlignments)
library(stringr)
#library(tidyr)

bam_files <- tibble(file_name = list.files("bowtie_paired/", pattern = '*.bam$'))



#bam_files <- bam_files %>% head(1)

df_bam <- bam_files %>% 
  mutate(full_file_name = paste0("bowtie_paired/",file_name))

df_results <- tibble()

for(f in 1:nrow(df_bam)){
#for(f in 1:2){
  
  file_row <- df_bam[f,]
  
  print(file_row)
  
  df <- readGAlignmentPairs(file = file_row$full_file_name, param=ScanBamParam(what=c("mapq"), tag = c('NM'))) %>%
    as.data.frame() %>% 
    as_tibble() %>% 
    filter(NM.first == 0 & njunc.first == 0 & str_detect(cigar.first, "^[0-9]+M$")) %>% 
    mutate(paired_len = abs(end.first - start.last)) %>%
    filter(paired_len <= 500) %>% 
    mutate(stop_pos = ifelse(strand.first == '-', end.first, start.first)) %>%
    group_by(strand.first, stop_pos) %>%
    summarise(n = n(), mean_qwidth = mean(qwidth.first), min_mapq = min(mapq.first), mean_mapq = mean(mapq.first)) %>%
    mutate(file_name = file_row$file_name)

  df_results <- bind_rows(df_results, df)
  
}

write.csv(df_results, "2026_01_13_PA_hypo_abx_paired_perfect_first_counts.csv")
