#!/usr/bin/python

import os, sys, re
from PyRTF import *

target = sys.argv[1]
targetfiles = os.listdir(target)

print target
print targetfiles

delim = "#"

for f in filter (lambda a: a != "cleaned", targetfiles):
    fin = open(target + "/" + f, "r")
    fout = open(target + "/cleaned/" + f.replace("rtf","csv"),"w")
    contents = fin.read().splitlines()
    print("*******" + f + "*******")

    word = list()
    time = list()
    for c in contents:
        if ("\\f0\\fs26 \\cf0" in c) and (not c[-1] == "\\") and (not c[-1] == "}"):
            word.append(c.replace("\\f0\\fs26 \\cf0 ","").replace(" ",""))
            
        if ((not "\\" in c) and (not c == "") and (not c == "}")):
            word.append(c.replace("\f0\fs26 \cf0 ","").replace(" ",""))

        if ":" in c:
            time.append(c.split("#")[1])

    print time

    fout.write("name,time\n")
    for w,t in zip(word, time):
        fout.write(w + "," + t + "\n")

    fin.close()
    fout.close()
            
    
    
