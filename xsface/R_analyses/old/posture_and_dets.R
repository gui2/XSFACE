rm(list=ls())

source("~/Projects/R/mcf.useful.R")
source("helper.R")

## load detectors
all.dets <- read.csv("~/Projects/xsface/data/face_presence.csv")
all.dets$time <- strptime(all.dets$time,"%M:%OS")
all.dets$time <- as.numeric(all.dets$time-all.dets$time[1]) # make into numbers

### RAW MEASURES OF DETECTORS
d.mss <- aggregate(face ~ subid + age.grp, all.dets, na.mean)
d.mss$ycenter <- aggregate(ycenter ~ subid + age.grp, all.dets, na.mean)$ycenter
d.mss$size.pct <- aggregate(size.pct ~ subid + age.grp, all.dets, na.mean)$size.pct
d.ms <- aggregate(cbind(face,ycenter,size.pct) ~ age.grp, d.mss, mean) # aggregates for checking

##### MERGE IN POSTURES
file.path <- "~/Projects/xsface/data/posture/cleaned/"
files <- dir(file.path)

d <- data.frame()

## for each file
for (f in files) {  
  print(f)
  fdata <- merge.dets(paste(file.path,f,sep=""),f,all.dets)
  d <- rbind.fill(d,fdata)
}

# add demographic data
demo.data <- read.csv("~/Projects/xsface/data/demographics/demographics.csv")
d <- merge(d, demo.data, by.x="subid",by.y="subid")


## STATS BY BOTH POSTURE AND ORIENTATION
mss <- ddply(d,~subid + orient + posture + age.grp,summarise,
            face=weighted.mean(face,diff.s,na.rm=TRUE),
            size=weighted.mean(size.pct,diff.s,na.rm=TRUE),
            ycenter=weighted.mean(ycenter,diff.s,na.rm=TRUE))

ms <- ddply(mss,~orient + posture + age.grp,summarise,
            face=mean(face,na.rm=TRUE),#f.cih=ci.high(face,na.rm=TRUE),f.cil=ci.low(face,na.rm=TRUE),f.sem=sem(face),
            size=mean(size,na.rm=TRUE),#s.cih=ci.high(size,na.rm=TRUE),s.cil=ci.low(size,na.rm=TRUE),s.sem=sem(size),
            ycenter=mean(ycenter,na.rm=TRUE))

quartz()
qplot(age.grp,face,colour=posture,facets = .~ orient,
      geom=c("line","point"),position=position_dodge(.7),ylim=c(0,.25),
      xlab="Age (Months)",ylab="Proportion Faces Detected",
      data=subset(ms,orient!="other")) + plot.style

quartz()
qplot(age.grp,size,colour=posture,facets = .~ orient,
      geom=c("line","point"),position=position_dodge(.7),ylim=c(0,.15),
      xlab="Age (Months)",ylab="Visual Field Subtended by Faces",
      data=subset(ms,orient!="other")) + plot.style

qplot(age.grp,ycenter,colour=posture,facets = .~ orient,
      geom=c("line","point"),position=position_dodge(.7),ylim=c(.3,.7),
      xlab="Age (Months)",ylab="Middle Position",
      data=subset(ms,orient!="other")) + plot.style

