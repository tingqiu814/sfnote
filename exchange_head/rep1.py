import re
import os

f=open("a.txt", "r+")
for line in f.readlines():
    print(line , line.find("world"))
    if line.find("world") >= 0:
        s = line.replace("world", "python")
        print(s)
        f.writelines(s)
        

f.close()
