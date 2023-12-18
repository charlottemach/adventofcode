def pprint(arr)
    arr.each_index do |i|
        puts arr[i].join("") + "\n"
    end
    return 0
end


def flood_fill(grid, x, y, new)
  current = grid[y][x]
  queue = Queue.new
  queue.enq([x,y])
  until queue.empty?
    px,py = queue.pop
    next unless grid[py][px] == current
    wx, wy = find_border(grid, px, py, current, :west)
    ex, ey = find_border(grid, px, py, current, :east)
    for i in wy..ey do
        for j in wx..ex do
            grid[i][j] = new
        end
    end
    qx,qy = wx,wy
    while qx <= ex
      %i[north south].each do |dir|
        nx,ny = neighbour(grid, qx, qy, dir)
        queue.enq([nx,ny]) if grid[ny][nx] == current
      end
      qx, qy = neighbour(grid, qx, qy, :east)
    end
  end
end

def neighbour(grid, x, y, dir)
  case dir
  when :north then [x, y - 1]
  when :south then [x, y + 1]
  when :east  then [x + 1, y]
  when :west  then [x - 1, y]
  end
end

def find_border(grid, px, py, fill, dir)
  nx,ny = neighbour(grid, px, py, dir)
  while grid[ny][nx] == fill
    px,py = nx,ny
    nx,ny = neighbour(grid, px, py, dir)
  end
  [px,py]
end


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

#def filling(lines)
#    x,y = 0,0
#    points = [[x,y]]
#    peri = 0
#    dict = { "U" => [-1,0], "R" => [0,1], "D" => [1,0], "L" => [0,-1] }
#    lines.each_line do |line|
#        (dir, mv, col) = line.split
#        (dirx,diry) = dict[dir]
#        m = mv.to_i
#
#        x = x + (dirx * m)
#        y = y + (diry * m)
#        points << [x,y]
#        peri += m
#    end
#    p points
#    return pick_shoe(points,peri)
#end


lines = File.read("input.txt")

n = lines.length() / 10
dig = Array.new(n) { Array.new(n) { '.' } }
x,y = n/2,n/2
dict = { "U" => [-1,0], "R" => [0,1], "D" => [1,0], "L" => [0,-1] }

lines.each_line do |line|
    (dir, mv, col) = line.split
    (dirx,diry) = dict[dir]
    for m in 1..mv.to_i do
        x += dirx
        y += diry
        dig[x][y] = "#"
    end
end

flood_fill(dig, n/2+1, n/2+1,'#')
#pprint(dig)
puts "A: #{dig.flatten.select {|x|'#' == x}.count}"

puts "B: #{filling_b(lines)}"
