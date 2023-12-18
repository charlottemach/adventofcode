def pick_shoe(points,peri)
    sum = 0
    points.each_cons(2) do |((x1,y1),(x2,y2))|
        sum += (x1 * y2 - x2 * y1)
    end
    area = (sum.abs)/2
    return area + (peri/2) + 1
end

def filling_b(lines)
    xb,yb = 0,0
    points = [[xb,yb]]
    peri = 0
    dict_b = { 3 => [-1,0], 0 => [0,1], 1 => [1,0], 2 => [0,-1] }
    lines.each_line do |line|
        (dir, mv, col) = line.split
    
        col.gsub!(/[\W]+/,'')
        (dbx,dby) = dict_b[col[-1].to_i]
        mv = col[0..-2].to_i(16)

        xb = xb + (dbx * mv)
        yb = yb + (dby * mv)
        points << [xb,yb]
        peri += mv
    end
    return pick_shoe(points,peri)
end

def filling(lines)
    x,y = 0,0
    points = [[x,y]]
    peri = 0
    dict = { "U" => [-1,0], "R" => [0,1], "D" => [1,0], "L" => [0,-1] }
    lines.each_line do |line|
        (dir, mv, col) = line.split
        (dirx,diry) = dict[dir]
        m = mv.to_i

        x = x + (dirx * m)
        y = y + (diry * m)
        points << [x,y]
        peri += m
    end
    return pick_shoe(points,peri)
end


lines = File.read("input.txt")

puts "A: #{filling(lines)}"
puts "B: #{filling_b(lines)}"
