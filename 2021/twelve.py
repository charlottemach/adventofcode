#!/usr/bin/env python

def readFile(fname):
    d = {}
    with open(fname) as f:
        for line in f:
            (key, val) = line.replace("start", "s").strip().split("-")
            d[key] = [val] + d.get(key,[])
            d[val] = [key] + d.get(val,[])

    return d

def getNext(cur, path, nexts):
    if cur == "end":
        print path+cur
        return path+cur
    for n in nexts:
        if cur.islower():
            if cur not in path:
                getNext(n, path+cur, d[n])
        elif cur.isupper():
            getNext(n, path+cur, d[n])
 
def getNextB(cur, path, nexts, visited):
    if cur == "end":
        print path+cur
        return path+cur
    for n in nexts:
        if n != "s":
            if cur.islower():
                if cur not in path:
                    getNextB(n, path+cur, d[n], visited)
                elif cur in path and not visited:
                    getNextB(n, path+cur, d[n], not visited)
            elif cur.isupper():
                getNextB(n, path+cur, d[n], visited)
 
d = readFile("twelve.txt")
init = "s"
# Part A
#getNext(init,"",d[init])
# Part B
getNextB(init,"",d[init], False)

