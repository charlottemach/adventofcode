#!/usr/bin/julia

function findantennas(mat)
    dict = Dict{String,Array{Tuple{Int, Int}}}()
    n = length(mat)
    for x in 1:n
        for y in 1:n
            val = mat[y][x]
            if val != "."
                prev = get(dict, val, [])
                push!(prev,(x,y))
                dict[val] = prev
            end
        end
    end
    return dict
end

function findantinodes(mat,dict)
    n = length(mat)
    an = Tuple{Int,Int}[]
    a4 = Tuple{Int,Int}[]
    for (antenna, loc) in dict
       for i in 1:length(loc)-1
           for j in i+1:length(loc)
               p1 = loc[i]
               p2 = loc[j]
               append!(an,antinodes(p1,p2,n))
               append!(a4,antinodes4ever(p1,p2,n))
           end
       end
    end
    return an,a4
end

function inrange(n,p)
    x,y = p
    return x > 0 && x <=n && y > 0 && y <= n
end

function antinodes(p1,p2,n)
    x1,y1 = p1
    x2,y2 = p2
    vx,vy = x1-x2, y1-y2
    prev = (x1 + vx, y1 + vy)
    next = (x2 - vx, y2 - vy)
    return filter(x -> inrange(n,x),[prev,next])
end

function antinodes4ever(p1,p2,n)
    x1,y1 = p1
    x2,y2 = p2
    vx,vy = x1-x2,y1-y2
    an = [p1,p2]
    for i in 1:n
        prev = (x1 + i * vx, y1 + i * vy)
        next = (x2 - i * vx, y2 - i * vy)
        push!(an,prev,next)
    end
    return filter(x -> inrange(n,x),an)
end

function main()
    s = split(strip(read("input.txt", String)), "\n")
    mat = map(x -> split(x,""), s)
    # println(mat)

    dict = findantennas(mat)
    
    an,a4 = findantinodes(mat,dict) 
    println("A: ",length(unique!(an)))
    println("B: ",length(unique!(a4)))
end

main()
