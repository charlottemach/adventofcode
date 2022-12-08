visible <- function(x,y,mat) {
    l <- length(mat[1,])
    if (x == 1 || x == l || y == 1 || y == l) {
        return(TRUE)
    }
    row_left <- mat[x,1:(y-1)]
    row_right <- mat[x,(y+1):l]
    col_up <- mat[1:(x-1),y]
    col_down <- mat[(x+1):l,y]
    val <- mat[x,y]
    return(all(row_left < val) || all(row_right < val) || all(col_up < val) || all(col_down < val))
}

count_dist <- function(lst,val) {
    cnt <- 0
    for (l in lst) {
        cnt <- cnt + 1
        if (l >= val) {
            break
        }
    }
    return(cnt)
}

view_dist <- function(x,y,mat) {
    l <- length(mat[1,])
    if (x == 1 || x == l || y == 1 || y == l) {
        return(0)
    }
    row_left <- mat[x,1:(y-1)]
    row_right <- mat[x,(y+1):l]
    col_up <- mat[1:(x-1),y]
    col_down <- mat[(x+1):l,y]
    val <- mat[x,y]
    x1 <- count_dist(rev(row_left),val)
    x2 <- count_dist(row_right,val)
    y1 <- count_dist(rev(col_up),val)
    y2 <- count_dist(col_down,val)
    return(x1 * x2 * y1 * y2)
}

main <- function() {
    n <- 99
    mat <- matrix(, ncol = n, nrow = n)
    conn <- file("eight.txt", "r")
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
    cnt <- 0
    view <- 0
    for (ix in 1:n) {
        for (iy in 1:n) {
            if (visible(ix,iy,mat)) {
                cnt <- cnt + 1 
            }
            v <- view_dist(ix,iy,mat) 
            if (v > view) {
                view <- v
            }
        }
    }
    cat("A: ",cnt,"\n")
    cat("B: ",view,"\n")
}
main()
