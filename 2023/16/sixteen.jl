#!/usr/bin/julia

function energize(mat,e,move,done)
    (x,y,dx,dy) = move
    if !(move in done)
        push!(done,move) 
        n = length(mat)
        if (x > 0 && x <= n && y > 0 && y <= n)
            e[y][x] = "#"
            val = mat[y][x]
            if (val == "/")
                if (dx != 0)
                    dx,dy = dy,-dx
                else
                    dx,dy = -dy,dx
                end
                energize(mat,e,(x+dx,y+dy,dx,dy),done)
            elseif(val == "\\")
                if (dy != 0)
                    dx,dy = dy,-dx
                else
                    dx,dy = -dy,dx
                end
                energize(mat,e,(x+dx,y+dy,dx,dy),done)
            elseif(val == "|" && dx != 0)
                energize(mat,e,(x,y+1,0,1),done)
                energize(mat,e,(x,y-1,0,-1),done)
            elseif(val == "-" && dy != 0)
                energize(mat,e,(x+1,y,1,0),done)
                energize(mat,e,(x-1,y,-1,0),done)
            else
                energize(mat,e,(x+dx,y+dy,dx,dy),done)
            end
        end
    end
end

function copypaste(mat,x,y,dx,dy)
    e = deepcopy(mat)
    energize(mat,e,(x,y,dx,dy),[])
    return sum(map((row) -> count(i->(i=="#"),row),e))
end

function main()
    s = split(strip(read("input.txt", String)), "\n")
    mat = map(x -> split(x, ""), s)

    cnt = copypaste(mat,1,1,1,0)
    println("A: ",cnt)

    mx = 0
    n = length(mat)
    for x in 1:n
        mx = max(copypaste(mat,x,1,0,1),mx)
        mx = max(copypaste(mat,x,n,0,-1),mx)
    end
    for y in 1:n
        mx = max(copypaste(mat,1,y,1,0),mx)
        mx = max(copypaste(mat,n,y,-1,0),mx)
    end
    println("B: ",mx)
end

main()
