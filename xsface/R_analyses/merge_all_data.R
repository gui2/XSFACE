  rm(list=ls())
  
  source("~/Projects/R/mcf.useful.R")
  source("R_analyses/helper.R")
  
  ## load detectors
  dets <- read.csv("~/Projects/xsface/data/face_presence_LDT.csv")
  
  ## load demographic data and merge
  demo.data <- read.csv("~/Projects/xsface/data/demographics/demographics.csv")
  d <- merge(dets, demo.data, by.x = "subid", by.y = "subid", 
             all.x = TRUE, all.y = FALSE)
  
  ## now add ground truth time to these
  d <- ddply(d, ~subid, add.times)
  
  ## now add posture and orientation to these
  d <- ddply(d, ~subid, add.posture)
  
  write.csv(d,"~/Projects/xsface/data/all_dets_LDT_merged.csv")