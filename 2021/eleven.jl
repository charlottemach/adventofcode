f = "eleven.txt"

function flash(mat,i,j)
    if i > 1
        if j > 1
            mat[i-1][j-1] += 1  # nw
        end 
        if j < 10
            mat[i-1][j+1] += 1  # sw
        end
        mat[i-1][j] += 1        # w
    end
    if i < 10
        if j > 1
            mat[i+1][j-1] += 1  # ne
        end
        if j < 10
            mat[i+1][j+1] += 1  # se
        end
        mat[i+1][j] += 1        # e
    end
    if j > 1 
        mat[i][j-1] += 1        # n
    end
    if j < 10
        mat[i][j+1] += 1        # s
    end
    mat[i][j] = 0
    mat
end

function done(mat)
    ! any(map(line -> any(x->x >= 10, line), mat))
end

mat = map(x -> map(y -> parse(Int64, y), split(x, "")), split(strip(read(f, String)), "\n"))

cntA = 0
# Part A: 
# for s in 1:100
for s in 1:500
    global mat = map(x -> map(y -> y+1, x), mat)
    flashed = []
    while !done(mat)
        for (i) in eachindex(mat)
            for (j) in eachindex(mat[i])
                if !((i,j) in flashed) && mat[i][j] >= 10
                    global mat = flash(mat,i,j)
                    global cntA += 1
                    push!(flashed, (i,j))
                end
            end
        end
    end
    for (x,y) in flashed
        global mat[x][y] = 0
    end
    # Part B:
    if all(map(line -> all(x->x == 0, line), mat))
        println("Part B: ",s)
        break
    end
end
# print("Part A: ",cntA)
