import strutils
import sets
import tables

type Rope = array[10,(int,int)]
var dirs = {"R": (0,1), "L": (0,-1), "U": (1,0), "D": (-1,0)}.toTable()
var visited = initHashSet[(int,int)]()
var visitedB = initHashSet[(int,int)]()

proc moveTail(xh:int,yh:int,xt:int,yt:int,dir:string,ln:int): ((int,int),(int,int)) =
  var
    (xh,yh) = (xh,yh)
    (xt,yt) = (xt,yt)
  for i in countup(1,ln):
    let d = dirs[dir]
    (xh,yh) = (xh+d[0],yh+d[1])
    if (abs(xh-xt) > 1 or abs(yh-yt) > 1):
      if xh != xt:     
        xt = if (xt < xh): xt+1 else: xt-1
      if yh != yt:
        yt = if (yt < yh): yt+1 else: yt-1
    visited.incl((xt,yt))
  return ((xh,yh),(xt,yt))

proc moveTails(rope:Rope,dir:string,ln:int): Rope =
  var rope = rope
  for i in countup(1,ln):
    var (xh,yh) = rope[0]
    var (xt,yt) = (0,0)
    let d = dirs[dir]
    (xh,yh) = (xh+d[0],yh+d[1])
    for i in 1..9:
      let r = rope[i]
      (xt,yt) = r
      if (abs(xh-xt) > 1 or abs(yh-yt) > 1):
        if xh != xt:     
          xt = if (xt < xh): xt+1 else: xt-1
        if yh != yt:
          yt = if (yt < yh): yt+1 else: yt-1
      rope[i-1] = (xh,yh)
      rope[i] = (xt,yt)
      (xh,yh) = (xt,yt)
    visitedB.incl((xt,yt))   
  return rope

proc main() = 
  var
    (xh,yh) = (0,0)
    (xt,yt) = (0,0)
  var rope: Rope

  for line in lines "nine.txt":
    let l = line.split(" ")
    let dir = l[0]
    let ln = parseInt(l[1])
    # A
    let new = moveTail(xh,yh,xt,yt,dir,ln)
    (xh,yh) = new[0]
    (xt,yt) = new[1]
    # B
    rope = moveTails(rope,dir,ln)
  echo "A: ",len(visited)
  echo "B: ",len(visitedB)

main()
