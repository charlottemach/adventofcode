def read_file (file) 
  content = File.read(file)
  instr, maps = content.split("\n\n")
  instr = instr.split("")

  dirs = Hash(String, Tuple(String,String)).new
  nodes = [] of String
  maps.rstrip().split("\n").each do |m|
    key, lr = m.split(" = ") 
    l = lr[1..3]
    r = lr[6..8]
    dirs[key] = {l,r}
    if key[-1] == 'A'
      nodes << key
    end
  end

  return instr, dirs, nodes
end

def get_steps (pos, instr, dirs, regex)
  steps = 0
  while (!regex.matches?(pos))
    instr.each do |i|
      steps += 1
      if (i == "L")
        pos = dirs[pos][0]
      else
        pos = dirs[pos][1]
      end
    end
  end
  return steps 
end

instr,dirs,nodes = read_file("input.txt")
puts "A: " + get_steps("AAA", instr, dirs, Regex.new("ZZZ")).to_s

lcm = UInt64.new(1)
nodes.each do |k|
  steps = get_steps(k, instr, dirs, Regex.new("\.\.Z"))
  lcm = lcm*steps // lcm.gcd(UInt64.new(steps))
end
puts "B: " + lcm.to_s
