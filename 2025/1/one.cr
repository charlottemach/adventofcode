def turn(cur, zeros, instrs)
  if instrs.empty?
    return zeros
  else
    instr = instrs.first
    len = instr.lchop.to_i
    dir = instr[0].to_s
    if dir == "R"
      cur = (cur + len) % 100
    else
      cur = (cur - len + 100) % 100
    end
    zeros = cur == 0 ? zeros + 1 : zeros
  end
  return turn(cur,zeros,instrs[1..])
end

def turnB(cur, zeros, instrs)
  if instrs.empty?
    return zeros
  else
    instr = instrs.first
    len = instr.lchop.to_i
    dir = instr[0].to_s
    if dir == "R"
      diff = (cur + len) // 100
      cur = (cur + len) % 100
    else
      diff = ((cur - len) // 100).abs
      diff = cur == 0 ? (diff - 1) : diff
      cur = (cur - len + 100) % 100
      diff = cur == 0 ? (diff + 1) : diff
    end
  end
  return turnB(cur,zeros+diff,instrs[1..])
end

content = File.read("input.txt")
puts "A: " + turn(50,0,content.lines).to_s
puts "B: " + turnB(50,0,content.lines).to_s
