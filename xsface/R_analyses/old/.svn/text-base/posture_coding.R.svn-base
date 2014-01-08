## remove other data - not relevant, includes uncodable portions and out of range portions

rm(list=ls())
source("~/Projects/R/mcf.useful.R")
		 
demo.data <- read.csv("~/Projects/xsface/data/demographics/demographics.csv")

file.path <- "~/Projects/xsface/data/posture/cleaned/"
files <- dir(file.path)

post.short <- c("l","carry","c","si","st")
postures <- c("lie","carry","crawl","sit","stand")
orientations <- c("far","close","behind","other")
orientations.noother <- c("far","close","behind")

### GET POSTURE DATA FOR ALL FILES
post.data <- data.frame()
orient.data <- data.frame()

for (f in files) {
    data <- read.csv(paste(file.path,f,sep=""),stringsAsFactors=FALSE)
    subid <- sub(".csv","",f)    
 
    # normalize posture levels
    data$posture[data$posture=="w"] <- "st"  # walking is standing
    data <- subset(data,posture!="other") # remove other
    data$posture <- factor(data$posture,post.short)
    levels(data$posture) <- postures
    
    #Convert times to readable time format (in miliseconds)
    data$start <- strptime(data$start,"%M:%OS")
    data$end <- strptime(data$end,"%M:%OS")
    data$diff.s <- as.numeric(data$end - data$start)
    
    #aggregate data by posture to find total time in each
    post <- data.frame(tapply(data$diff.s,data$posture,sum),postures,
                           row.names=NULL)
    names(post) <- c("time","posture")
    post$prop.time <- post$time / sum(post$time,na.rm=T)
    post$prop.time[is.na(post$prop.time)] <- 0
    post$subid <- subid
    
    post.data <- rbind(post.data,post)

    # orientations
    data$orientation <- data$orientation + 1 # index from 1
    data$orientation[data$orientation==3] <- 2 # make close side and close front same
    data$orientation[data$orientation==4] <- 3 # replace 4s with 3 for continuity
    data$orientation[data$orientation==6] <- 4 # replace 6s with 4 for continuity
    data$orient <- factor(orientations[data$orientation],levels=orientations)
    
    data <- subset(data,orient!="other")
    data$orient <- factor(data$orient,levels=orientations.noother)
      
    orient <- data.frame(tapply(data$diff.s,data$orient,sum),orientations.noother,
                           row.names=NULL)
    names(orient) <- c("time","orientation")
    orient$prop.time <- orient$time / sum(orient$time,na.rm=T)
    orient$prop.time[is.na(orient$prop.time)] <- 0
    orient$subid <- subid
  
    orient.data <- rbind(orient.data,orient)
}


### POSTURE ANALYSIS
posts <- merge(post.data, demo.data, by.x="subid",by.y="subid")

ps <- aggregate(prop.time ~ posture + age.grp,posts,mean)
ps$sem <- aggregate(prop.time ~ posture + age.grp,posts,sem)$prop.time
      
quartz()

qplot(age.grp,prop.time,colour=posture,pch=posture,
      ymin=prop.time-sem,ymax=prop.time+sem,
      data=ps,position=position_dodge(.7),
	ylab="Proportion Time",xlab="Age (months)",xlim=c(4,20),
	geom=c("pointrange","line")) + 
  scale_x_continuous(breaks=c(4,8,12,16,20)) +
  theme_bw() + plot.style 

# lmer(prop.time ~ posture*age + (posture|subid),data=posts)


### ORIENTATION ANALYSIS
orients <- merge(orient.data, demo.data, by.x="subid",by.y="subid")

os <- aggregate(prop.time ~ orientation + age.grp,orients,mean)
os$sem <- aggregate(prop.time ~ orientation + age.grp,orients,sem)$prop.time

quartz()
qplot(age.grp,prop.time,colour=orientation,pch=orientation,
      ymin=prop.time-sem,ymax=prop.time+sem,
      data=os,position=position_dodge(.7),
      ylab="Proportion Time",xlab="Age (months)",xlim=c(4,20),
      geom=c("pointrange","line")) + 
  scale_x_continuous(breaks=c(4,8,12,16,20)) +
  theme_bw() + plot.style 

# lmer(prop.time ~ orientation*age + (orientation|subid),data=orients)
