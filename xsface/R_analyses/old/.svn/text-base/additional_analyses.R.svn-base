### MEASURES BY AGE
mss <- ddply(d,~subid + age.grp,summarise,
             face=weighted.mean(face,diff.s,na.rm=TRUE),
             size=weighted.mean(size.pct,diff.s,na.rm=TRUE),
             xcenter=weighted.mean(xcenter,diff.s,na.rm=TRUE),
             ycenter=weighted.mean(ycenter,diff.s,na.rm=TRUE))

ms <- ddply(mss,~age.grp,summarise,face=mean(face,na.rm=TRUE),
            cih=ci.high(face,na.rm=TRUE),cil=ci.low(face,na.rm=TRUE))

qplot(age.grp,face,data=mss,
      geom="point",ylim=c(0,.20),
      xlab="Age (Months)",ylab="Proportion Faces Detected") + 
  geom_line(aes(x=age.grp,y=face),data=ms,colour="red") +
  plot.style


### MEASURES BY POSTURE
mss <- ddply(d,~subid + posture + age.grp,summarise,
             face=weighted.mean(face,diff.s,na.rm=TRUE),
             size=weighted.mean(size.pct,diff.s,na.rm=TRUE),
             xcenter=weighted.mean(xcenter,diff.s,na.rm=TRUE),
             ycenter=weighted.mean(ycenter,diff.s,na.rm=TRUE))

ms <- ddply(mss,~posture+age.grp,summarise,
            face=mean(face,na.rm=TRUE),f.cih=ci.high(face,na.rm=TRUE),f.cil=ci.low(face,na.rm=TRUE))
qplot(age.grp,face,ymax=face+f.cih,ymin=face-f.cil,colour=posture,
      geom=c("line","pointrange"),position=position_dodge(.7),
      xlab="Age (Months)",ylab="Proportion Faces Detected",
      data=ms)

### MEASURES BY ORIENTATION
mss <- ddply(d,~subid + orient + age.grp,summarise,
             face=weighted.mean(face,diff.s,na.rm=TRUE),
             size=weighted.mean(size.pct,diff.s,na.rm=TRUE),
             xcenter=weighted.mean(xcenter,diff.s,na.rm=TRUE),
             ycenter=weighted.mean(ycenter,diff.s,na.rm=TRUE))

ms <- ddply(mss,~orient+age.grp,summarise,
            face=mean(face,na.rm=TRUE),f.cih=ci.high(face,na.rm=TRUE),f.cil=ci.low(face,na.rm=TRUE),
            size=mean(face,na.rm=TRUE),s.cih=ci.high(face,na.rm=TRUE),s.cil=ci.low(face,na.rm=TRUE))

qplot(age.grp,face,ymax=face+f.cih,ymin=face-f.cil,colour=orient,
      geom=c("line","pointrange"),position=position_dodge(.7),
      xlab="Age (Months)",ylab="Proportion Faces Detected",
      data=ms)
