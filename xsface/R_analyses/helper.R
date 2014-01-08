######## MERGE IN EXACT TIMES FOR FRAMES #########
add.times <- function(x) {
  times <- read.csv(paste("data/frame_counts/parsed/",
                          x$subid[1],
                          "_objs.mov.frames.txt.parsed.csv",
                          sep=""))
  x <- merge(x,times, by.x = "frame", by.y = "frame", all.x = TRUE, all.y = FALSE)
  
  x$dt <- c(diff(x$t),.032)
  return(x)
}

######## ADD POSTURE CODING #########
add.posture <- function(x) {
  postures <- read.csv(paste("data/posture/cleaned/",
                             x$subid[1],
                             ".csv",
                             sep=""),
                       stringsAsFactors=FALSE)
  
  postures <- regularize.postures(postures)
  
  x$posture <- factor(NA,levels=levels(postures$posture))
  x$orientation <- factor(NA,levels=levels(postures$orientation))
  
  # for each row of p, populate posture and orientation to x
  for (i in 1:nrow(postures)) {
    range <- x$time > postures$start[i] & x$time <= postures$end[i]
    x$posture[range] <- postures$posture[i]
    x$orientation[range] <- postures$orientation[i]
  }
  
  return(x)
}

######## GET POSTURE CODING SORTED OUT #########
regularize.postures <- function (p) {
  postures <- c("lie","carry","prone","sit","stand","other")
  orientations <- c("far","close","behind","other")
  
  # replace postures with the ones we want
  p$posture[p$posture=="l"] <- "lie"  
  p$posture[p$posture=="c"] <- "prone"  
  p$posture[p$posture=="si"] <- "sit"
  p$posture[p$posture=="st"] <- "stand"
  p$posture[p$posture=="w"] <- "stand"  # walking is standing  
  p$posture <- factor(p$posture, levels = postures)
  
  # replace orientations with the ones we want
  p$orientation[p$orientation==0] <- "far"
  p$orientation[p$orientation==1] <- "close"
  p$orientation[p$orientation==2] <- "close"
  p$orientation[p$orientation==3] <- "behind"
  p$orientation[p$orientation==5] <- "other"
  p$orientation <- factor(p$orientation, levels = orientations)
  
  # convert times to readable time format
  p$start <- strptime(p$start,"%M:%OS")
  p$end <- strptime(p$end,"%M:%OS")
  
  # re-zero the times
  begin <- p$start[1]
  p$start <- as.numeric(difftime(p$start,begin,units="secs"))
  p$end <- as.numeric(difftime(p$end,begin,units="secs"))
  
  return(p)
}

######## GET NAMING CODING SORTED OUT #########
regularize.naming <- function (n) {
  words <- c("ball","car","brush","cat","tima","gimo","gasser","zem","manu")
  
  # replacements
  n$name[n$name == "truck"] <- "car"
  n$name[n$name == "kittycat"] <- "cat"
  n$name[n$name == "bobcat"] <- "cat"

  n$name <- factor(n$name, levels=words)
  
  n$familiarity <- "familiar"
  n$familiarity[n$name == "tima" |
    n$name == "gimo" |
    n$name == "gasser" |
    n$name == "zem" |
    n$name == "manu"] <- "novel"
  n$familiarity <- factor(n$familiarity)
  
  # make the times seconds since onset
  n$time <- as.numeric(difftime(strptime(n$time,"%H:%M:%OS"),
                                strptime("00:00:00.0","%H:%M:%OS"),units="secs"))
  
  n <- subset(n,!is.na(name))
  n$naming.instance <- naming.instance(n$name)
  return(n)
}

######## ADD NAMING INSTANCES #########
naming.instance <- function(ns) {
  ni <- rep(0,length(ns))

  for (l in levels(ns)) {
      this.name <- ns==l
      ni[this.name] <- cumsum(this.name)[this.name]
  }
  
  return(ni)
}


######## GET SUMMARY MEASURES OVER NAMINGS #########
summarize.naming <- function (x, window = c(-2,2)) {  
  words <- c("ball","zem","car","manu","brush","gimo","tima","kittycat","bobcat","cat","gasser","puppy")

  # read in naming times
  namings <- read.csv(paste("data/naming/cleaned/",
                      x$subid[1],
                      "_objs_annotation.csv",
                      sep=""),
                stringsAsFactors=FALSE)
  
  # rectify the coding
  namings <- regularize.naming(namings)
  
  # for each row of p, populate posture and orientation to x
  namings$posture <- factor(NA, levels=levels(x$posture))
  namings$orientation <- factor(NA, levels=levels(x$orientation))
  
  for (i in 1:nrow(namings)) {
    t <- namings$time[i]
    range <- c(max(c(0,t + window[1])),
               min(c(t+window[2],max(x$time))))
    
    namings$face[i] <- mean(x$face[x$time > range[1] & x$time < range[2]])
    namings$posture[i] <- x$posture[(x$time > namings$time[i])][1]
    namings$orientation[i] <- x$orientation[(x$time > namings$time[i])][1]
  }
  
  namings$age.grp <- x$age.grp[1]

  return(namings)
}

######## PLOTTING FUNCTION #########

plot.individual <- function(x) {
  n <- summarize.naming(x)
  x$face.tf <- factor(x$face==1)
  ggplot() + 
    geom_point(aes(x=time,y=posture,colour=face.tf,pch=face.tf),
        data=x,xlab="Time (s)",
               ylab="Posture") + 
    geom_text(aes(x=time,y=4 +naming.instance*.4,label=name),data=n)
}