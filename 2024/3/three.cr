def multiply(content) 
  re = /mul\((?<a>\d*)\,(?<b>\d*)\)/
  sum = 0
  content.scan(re) do |match|
    sum += match["a"].to_i * match["b"].to_i
  end
  return sum.to_s
end

content = File.read("input.txt").gsub("\n","")
puts "A: " + multiply(content)

del = /don\'t\(\).*?do\(\)/
puts "B: " + multiply(content.gsub(del,""))
