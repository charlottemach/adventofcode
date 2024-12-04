readMatrix <- function(f) {
    n <- 140
    mat <- matrix(, ncol = n, nrow = n)
    conn <- file(f, "r")
    x <- 1
    while(length(line <- readLines(conn, 1)) > 0) {
        line = as.list(strsplit(line,"")[[1]])
        y <- 1
        for (l in line) {
            mat[x,y] <- l
            y <- y + 1
        }
        x <- x + 1
    }
    close(conn)
    return(mat)
}

findX <- function(mat,letter) {
    xs <- list()
    n <- dim(mat)[1]
    for (i in 1:n) {
        for (j in 1:n) {
            if (mat[j,i] == letter) {
               xs[[length(xs)+1]] <- list(y=j,x=i)
            }
        }
    } 
    return(xs)
}

findMas <- function(mat,coord) {
    n <- dim(mat)[1]
    dir <- list(-1,0,1)
    x <- coord$x
    y <- coord$y
    cnt <- 0
    for (dirx in dir) {
        for (diry in dir) {
            maxy <- y + (3*diry)
            maxx <- x + (3*dirx)
            if (maxy > 0 & maxy <= n & maxx > 0 & maxx <= n){
                if (mat[y+diry,x+dirx] == "M") {
                    if (mat[y+(2*diry),x+(2*dirx)] == "A" & mat[maxy,maxx] == "S") {
                        cnt <- cnt + 1
                    }
                }
            }
        }
    }
    return(cnt)
}

findCross <- function(mat,as) {
    n <- dim(mat)[1]
    cnt <- 0
    dir <- list(-1,1)
    for (a in as) {
        x <- a$x
        y <- a$y
        ms <- list()
        for (dirx in dir) {
            for (diry in dir) {
                maxy <- y + diry
                maxx <- x + dirx
                if (maxy > 0 & maxy <= n & maxx > 0 & maxx <= n){
                    ms <- append(ms, mat[maxy,maxx])
                }
            }
        }
        s <- paste(ms,collapse="")
        if (s == "MMSS" | s == "SMSM" | s == "SSMM" | s == "MSMS") {
            cnt <- cnt + 1
        }
    }
    return(cnt)
}


main <- function() {
    mat <- readMatrix("input.txt")

    xs <- findX(mat,"X")
    cnt <- 0
    for (i in xs) {
       cnt <- cnt + findMas(mat,i)
    }
    # part A
    cat("A: ",cnt,"\n")

    # part B
    as <- findX(mat,"A")
    cat("B: ",findCross(mat,as),"\n")
}
main()
