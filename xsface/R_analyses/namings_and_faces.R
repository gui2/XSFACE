######## ANALYSIS OF NAMINGS ##########
# sb <- ddply(d,~subid, summarize.naming, window=c(-3,0))
# sa <- ddply(d,~subid, summarize.naming, window=c(0,3))
# sb$window <- "before"
# sa$window <- "after"
# s <- rbind(sb,sa)
# s$window <- factor(s$window)

s <- ddply(d,~subid, summarize.naming, window=c(-2,.2))

s$first.instance <- s$naming.instance == 1
s$log.instance <- round(log10(s$naming.instance)*4)/4
s$binned.instance <- 10^(round(log10(s$naming.instance)*4)/4)
s$face.logical <- s$face != 0

## try plotting individuals
mss <- ddply(s,~subid+age.grp+familiarity,summarise,
             face = na.mean(face))

pdf("~/Projects/xsface/writeup/figures/naming_faces.pdf",width=4,height=3)
qplot(age.grp,face,colour=familiarity,
      position = position_dodge(.7),log="x",
      xlab="Age (Months)",ylab="Proportion faces detected in window",
      data=mss,geom=c("point")) + 
  scale_x_continuous(breaks=c(4,8,12,16,20)) +
  stat_summary(fun.data="mean_cl_boot",position=position_dodge(.7)) +
  plot.style
dev.off()

ni <- lmer(face.logical ~ familiarity * naming.instance * age.grp + 
       (familiarity + naming.instance | age.grp) + 
       (naming.instance | name),
     family="binomial",
     data = s)

lni <- lmer(face.logical ~ familiarity * log.instance * age.grp + 
             (familiarity + log.instance | age.grp) + 
             (1 | name),
           family="binomial",
           data = s)


## try plotting individuals
mss <- ddply(s,~subid+age.grp+familiarity,summarise,
             face = na.mean(face))

## try plotting individuals
ms <- ddply(mss,~age.grp+familiarity,summarise,
             face = na.mean(face))

qplot(age.grp,face,colour=familiarity,
      geom="point",
      data=s) + geom_smooth()

