#!/usr/bin/env python

import sys, os, subprocess

target = sys.argv[1]
destination = sys.argv[2]

print("target: " + target + "\n")
print("destination: " + destination + "\n")

targetfiles = os.listdir(target)

for file in targetfiles:
    if file.find(".mov") > 0: # if this is a movie
        dirname = file.replace(".mov","")
        print "***********" + dirname + "**********"
        try:
            os.mkdir(destination + "/" + dirname)
        except OSError:
            print "directory already exists"

        subprocess.call(["ffmpeg","-i", target + "/" + file,"-vf","vflip,hflip",destination + "/" + dirname + "/frame_%05d.jpg"])
