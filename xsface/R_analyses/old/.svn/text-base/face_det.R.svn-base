library(ggplot2)
rm(list=ls())

plot.style <- opts(panel.grid.major = theme_blank(), panel.grid.minor = theme_blank(),
	 axis.line = theme_segment(colour="black",size=.5),
	 axis.ticks = theme_segment(size=.5),legend.justification=c(1,0),
	 legend.position=c(1,0),legend.title=theme_blank(),
	 axis.title.x = theme_text(vjust=-.5),
	 axis.title.y = theme_text(angle=90,vjust=0.25))
	 
data <- read.csv("~/Projects/xsface/data/demographics/face_looking.csv")
demo.data <- read.csv("~/Projects/xsface/data/demographics/demographics.csv")

data <- merge(data,demo.data,all.x=T)
data$age[30] <- 20
qplot(age,face,data=data,
	xlab="Age (months)", ylab="Proportion detected faces") +
	stat_smooth(method="loess",span=1) + 
	theme_bw() + 
	plot.style

qplot(age,ycenter,data=data,
      xlab="Age (months)", ylab="Vertical center") +
  stat_smooth(method="loess",span=1) + 
  theme_bw() + 
  plot.style

qplot(age,size.pct,data=data,
      xlab="Age (months)", ylab="Mean size") +
  stat_smooth(method="loess",span=1) + 
  theme_bw() + 
  plot.style


cor.test(data$age,data$prop.faces)