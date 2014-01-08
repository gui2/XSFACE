rm(list=ls())

source("~/Projects/R/mcf.useful.R")
source("helper.R")

## load detectors
all.dets <- read.csv("~/Projects/xsface/data/face_presence.csv")
all.dets$time <- strptime(all.dets$time,"%M:%OS")
all.dets$time <- as.numeric(all.dets$time-all.dets$time[1]) # make into numbers

##### MERGE IN POSTURES
pfile.path <- "~/Projects/xsface/data/posture/cleaned/"
pfiles <- dir(pfile.path)

nfile.path <- "~/Projects/xsface/data/naming/cleaned/"
nfiles <- dir(nfile.path)

d <- data.frame()

## for each file
for (i in 1:length(nfiles)) {  
  print(nfiles[i])
  fdata <- merge.naming(paste(nfile.path,nfiles[i],sep=""),
                        paste(pfile.path,pfiles[i],sep=""),pfiles[i],all.dets)
  d <- rbind.fill(d,fdata)
}

demo.data <- read.csv("~/Projects/xsface/data/demographics/demographics.csv")
d <- merge(d, demo.data, by.x="subid",by.y="subid")

# add first naming instance
naming.instance <- function(x) {
  x$naming.instance <- rep(0,length(x$name))
  for (l in unique(x$name)) {
    this.name <- x$name==l
    x$naming.instance[this.name] <- cumsum(this.name)[this.name]
  }
  return(x)
}

d <- ddply(d,~subid,naming.instance)

summary <- ddply(d,~subid,nrow)
summary(summary$V1)
aggregate(V1 ~ novel,summary,mean)
aggregate(V1 ~ novel,summary,min)
aggregate(V1 ~ novel,summary,max)

# more dataset cleanup
words <- c("ball","zem","car","manu","brush","tima","gimo")
d$name <- factor(d$name,levels=words)
d$novel <- "Familiar"
d$novel[d$name == "zem" | d$name == "manu" | d$name == "tima"] <- "Novel"
d$novel <- factor(d$novel)
d <- subset(d,!is.na(name))
d$instance[d$naming.instance == 1] <- "First instance"
d$instance[d$naming.instance != 1] <- "Later instance"
d$instance <- factor(d$instance)

## start aggregating
mss <- ddply(d,~subid+age.grp+novel+instance,summarise,
             face = na.mean(face))

ms <- ddply(mss,~age.grp+novel+instance,summarise,
            face = na.mean(face),
            cih = ci.high(face),
            cil = ci.low(face),
            sem = sem(face))

quartz()
qplot(age.grp,face,colour=instance,facets=.~novel,
      ymin = face - sem, ymax = face + sem,
      position = position_dodge(.7),
      xlab="Age Group",ylab="Proportion faces detected in window",
      data=ms,geom=c("line","pointrange")) + plot.style