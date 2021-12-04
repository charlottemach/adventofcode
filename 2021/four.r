#!/usr/bin/env Rscript

getInput <- function(){
    fname <- "four.txt"
    contents <- readChar(fname, file.info(fname)$size)
    ls <- strsplit(contents, "\n\n")
    return(ls)
}
lines <- getInput()
inpNums <- strsplit(lines[[1]][1], ",")[[1]]
mx <- lapply(lines, tail, length(lines[[1]])-1)[[1]]

# A 
checkBingo <- function(mat){
    for (i in 1:5) {
        row <- mat[i,]; col <- mat[,i]
        if (all(is.na(row)) || all(is.na(col))){
            return (TRUE) 
        }
    }
    return (FALSE)
}

mat <- matrix(0, nrow = 5, ncol = 5)
count <- length(inpNums) ### A
count <- 0 ### B

for (m in mx) {
    mm <- matrix(scan(text = m, what = integer()),nrow = 5,byrow = TRUE)
    for (n in inpNums) {
        mm[mm == n] <- NA
        if (checkBingo(mm)) {
            i <- which (n == inpNums)
            ### A: if (i < count) {
            if (i > count) {
                print(count)
                mat <- mm
                count <- i
                ### A: next
            }
            break ## B
        }
    }
}
mat[is.na(mat)] <- 0
print(strtoi(inpNums[count]) * sum(mat))
