######## ANALYSIS OF DETECTIONS ##########  
ms <- ddply(d, ~ subid + age.grp, summarise, 
            face=mean(face))            

pdf("~/Projects/xsface/writeup/figures/prop_faces_age.pdf",width=3,height=3)
qplot(age.grp,face,      
      data=ms,geom=c("point"),
      position=position_jitter(.5),ylim=c(0,.3),
      ylab="Proportion Face Detections",xlab="Age (months)",xlim=c(4,20)) + 
  scale_x_continuous(breaks=c(4,8,12,16,20)) + 
  stat_summary(fun.data="mean_cl_boot",colour="red",aes(x=age.grp)) +
  plot.style
dev.off()

######## ANALYSIS OF POSTURES ##########  
ms <- ddply(d, ~ subid + posture, summarise, 
            face=mean(face))          
ms <- subset(ms,!is.na(posture) & posture!="lie" & posture!="other")
ms$posture <- factor(ms$posture)

m <- ddply(ms, ~ posture, summarise, 
           face=mean(face))            
s <- sort(m$face,index.return=TRUE)
l <- levels(m$posture)[s$ix]

pdf("~/Projects/xsface/writeup/figures/prop_faces_posture.pdf",width=3,height=3)
ms$posture <- factor(ms$posture,levels=l)
qplot(posture,face,position=position_jitter(.05),
      data=ms,ylim=c(0,.3),
      geom=c("point"),
      ylab="Proportion Face Detections",xlab="Posture") + 
  stat_summary(fun.data="mean_cl_boot",colour="red",aes(x=as.numeric(posture)),
               data=subset(ms,!is.na(posture) & posture!="lie")) +
  plot.style
dev.off()

######## ANALYSIS OF ORIENTATIONS ##########  
ms <- ddply(d, ~ subid + orientation, summarise, 
            face=mean(face))          
ms <- subset(ms,!is.na(orientation) & orientation!="other")
ms$orientation <- factor(ms$orientation)

m <- ddply(ms, ~ orientation, summarise, 
           face=mean(face))            
s <- sort(m$face,index.return=TRUE)
l <- levels(m$orientation)[s$ix]
ms$orientation <- factor(ms$orientation,levels=l)

pdf("~/Projects/xsface/writeup/figures/prop_faces_orientation.pdf",width=3,height=3)
qplot(orientation,face,position=position_jitter(.05),
      data=ms,ylim=c(0,.3),
      geom=c("point"),
      ylab="Proportion Face Detections",xlab="Orientation") + 
  stat_summary(fun.data="mean_cl_boot",colour="red",aes(x=as.numeric(orientation)),
               data=ms) +
  plot.style
dev.off()

######## ANALYSIS OF POSTURES AND ORIENTATIONS ##########
mss <- ddply(d,~subid + orientation + posture + age.grp,summarise,
             face=mean(face),
             time=sum(dt),
             log.time=log(sum(dt)))

ms <- ddply(subset(mss,!is.na(posture)),
            ~orientation + posture + age.grp, summarise,
            face=mean(face),
            f.cih=ci.high(face),
            f.cil=ci.low(face),
            f.sem=sem(face))

pdf("~/Projects/xsface/writeup/figures/faces_by_posture.pdf",width=7.5,height=2.5)
qplot(age.grp,face,colour=orientation,pch=orientation,facets = .~ posture,
      size=log.time,
      #       ymin=face - f.cil, ymax = face + f.cih,
      #       geom=c("line","pointrange"),
      position=position_jitter(width=.7,height=0),ylim=c(0,.25),
      xlab="Age (Months)",ylab="Proportion Faces Detected",
      data=subset(mss,orientation!="other" & posture!="lie")) +
  scale_x_continuous(breaks=c(4,8,12,16,20)) +
  scale_size(guide="none") +
  plot.style
dev.off()