# R code to merge CBF ROI extracts and visualize
# 
# Sean Ma
# Oct 2018
# 
rm(list=ls())
setwd('~/Dropbox/DrD_Ext/')

# file list from matching csvs
roi_files <- list.files(path = ".", pattern = "^ROI_extract")
roi_files

# extract out only CBF filenames
# inspired by https://stackoverflow.com/questions/6109882/regex-match-all-characters-between-two-strings
# look behind: `(?<=)` and look ahead (?=)
fname <- stringr::str_extract(roi_files, "(?<=cbfmap_)(.*)(?=.csv)")

# read in all csv files with `purrr` (such as `map_df`)
# add in filename in df: https://stackoverflow.com/questions/46299777/add-filename-column-to-table-as-multiple-files-are-read-and-bound
# specifically, melt it, insert extracted filename as Subject column
library(purrr)
library(dplyr)
library(tidyr)
library(readr)

# purrr style magic!!
# .x is element in filenames, and .y is element in sites
roi_df <- map2_df(roi_files, fname, 
                  ~read_csv(.x) %>% 
                    select(-X1) %>%
                    gather(key = ROI, value = CBF_value) %>%
                    mutate(Subject = .y)
                  )
# remove NAs
roi_df <- na.omit(roi_df)

# visualization 
# had some issues with error bars not plotting on each bar but resolved after updating to newest
# https://github.com/kassambara/ggpubr/issues/71
library(ggpubr)

ggbarplot(roi_df, x= "ROI", y = "CBF_value", 
          add = "mean_se",
          fill = "Subject", color = "Subject", 
          add.params = list(group = "Subject"),
          x.text.angle = 45,
          position = position_dodge(0.9),
          legend = "right", xlab = "ROI Location", ylab = "CBF Value",
          title = 'CBF value comparison for 6 roi regions')  

ggsave('CBF_value_comparison_6roi.png', width = 8, height = 6)
