#!/usr/bin/env python
import functools 

def ordered(left,right):
  if len(left) == 0:
    return True
  if len(right) == 0:
    return False
  l,r = left[0],right[0]
  if (isinstance(l,int) and isinstance(r,int)):
    if l == r:
      return ordered(left[1:],right[1:])
    else:
      return l < r
  l = [l] if isinstance(l,int) else l
  r = [r] if isinstance(r,int) else r
  return ordered(l,r)

def cmp_ordered(left,right):
  return -1 if ordered(left,right) else 1

def main():
  with open('thirteen.txt', 'r') as file:
      data = file.read().split('\n\n')
  data = list(map(lambda x: x.split('\n'),data))
  
  cnt = 0
  for i,d in enumerate(data):
    if ordered(eval(d[0]),eval(d[1])):
      cnt += i+1
  print("A: ",cnt)

  div1 = [[2]]; div2 = [[6]]
  dataB = [p for pair in data for p in pair if p != '']
  dataB = list(map(eval,dataB)) + [div1,div2]
  sorted_data = sorted(dataB, key=functools.cmp_to_key(cmp_ordered))
  print("B: ",(sorted_data.index(div1)+1) * (sorted_data.index(div2)+1))

if __name__ == "__main__":
    main()
