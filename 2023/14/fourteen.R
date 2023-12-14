library(digest)

up <- function(o,i,mat) {
    if (o > 1) {
       if (mat[o-1,i] == ".") {
           mat[o-1,i] <- mat[o,i]
	   mat[o,i] <- "."
           mat <- up(o-1,i,mat)
       }
    }
    return(mat)
}

rotate <- function(x) t(apply(x, 2, rev))

stringify <- function(mat) {
    s <- ""
    n <- dim(mat)[1]
    for (i in 1:n) {
        for (j in 1:n) {
            s <- paste(s,mat[j,i])
        }
    }
    return(digest(object=s))
}

load <- function(mat) {
    load <- 0
    n <- dim(mat)[1]
    for (i in 1:n) {
        for (j in 1:n) {
            if (mat[j,i] == "O") {
                load <- load + (n-j) + 1
            }
        }
    }
    return(load)
}

tilt <- function(mat) {
    for (times in 1:4){
        n <- dim(mat)[1]
        for (i in 1:n) {
            for (j in 1:n) {
                if (mat[j,i] == "O") {
                   mat <- up(j,i,mat)
                }
            }
        }
        mat <- rotate(mat)
    }
    return(mat)
}

readMatrix <- function(f) {
    n <- 100
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

main <- function() {
    mat <- readMatrix("input.txt")

    # part A
    matA <- mat
    n <- dim(mat)[1]
    for (i in 1:n) {
        for (j in 1:n) {
            if (matA[j,i] == "O") {
               matA <- up(j,i,matA)
            }
        }
    }
    cat("A: ",load(matA),"\n")

    # part B
    previous <- new.env(hash=T, parent=emptyenv())
    previous[[stringify(mat)]] <- 1
    start <- 0
    i <- 0
    for (i in 1:1000000000) {
        mat <- tilt(mat)
        sm <- stringify(mat)
        if (exists(sm, envir = previous)) {
            if (start == 0) {
                start <- previous[[sm]]
                i <- ((1000000000 -i) %% (i - start) + 1)
                break
            }
        } else {
            previous[[sm]] <- i
        }
    }
    print("skipping ahead")
    while (i > 1) {
        mat <- tilt(mat)
        i <- i - 1
    }
    cat("B: ",load(mat))
}
main()
