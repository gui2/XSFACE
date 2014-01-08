#!/usr/bin/env python

import os, sys, re
from PyRTF import *

target = sys.argv[1]
targetfiles = os.listdir(target)
#print target
#print targetfiles

for f in filter (lambda a: a.find(".txt") != -1, targetfiles):
    # print f
    fin = open(target + "/" + f,"r")
    fout = open(target + "/parsed/" + f + ".parsed.csv","w")
    fout.write("frame,time\n")
    
    contents = fin.read().split("[PACKET]")

    i = 1
    for c in contents:
        if c.find("codec_type=video") != -1:
            m = re.search(r"pts_time=\d+.\d+",c)
            if m != None:
                fout.write(str(i) + "," + m.group(0).replace("pts_time=","") + "\n")
                i = i + 1

    print f + "," + str(i-1) + "," + m.group(0).replace("pts_time=","") 
        
    
    
