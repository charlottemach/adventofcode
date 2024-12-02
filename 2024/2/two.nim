import strutils
import sequtils
import std/algorithm


proc differ(line: seq[int]): bool =
  var cur = line[0]
  for i,l in line[1 .. ^1]:
    var diff = abs(cur - l)
    if diff < 1 or diff > 3:
      return false
    cur = l
  return true

proc safe(line: seq[int]): bool =
  return (isSorted(line) or isSorted(line.reversed)) and differ(line)

proc safe_dampened(line: seq[int]): bool =
  for i,l in line:
    var dampen = concat(line[0 .. i-1],line[i+1 .. ^1])
    if safe(dampen):
      return true
  return false

proc main() = 
  let content = readFile("input.txt")
  var a = 0
  var b = 0
  for line in splitLines(strip(content)):
    let splitLine = splitWhitespace(line).map(parseInt)
    if safe(splitLine):
      a += 1
    if safe_dampened(splitLine):
      b += 1
  echo "A: ",a
  echo "B: ",b

main()
