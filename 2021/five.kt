import java.io.File
import kotlin.math.abs

fun main() {
    val input = File("five.txt").readText()
    val coord = input.trim().split("\n").map{ it.split(" -> ")}
    val mat = Array(1000) {Array(1000) {0} }
    //val mat = Array(10) {Array(10) {0} }
    for (c in coord) {
        val start = c.first().split(","); val stop = c.last().split(",")
        val x1 = start.first().toInt(); val y1 = start.last().toInt()
        val x2 = stop.first().toInt(); val y2 = stop.last().toInt()

        if (x1 == x2) {
            val mnY = minOf(y1,y2); val mxY = maxOf(y1,y2)
            for (y in mnY..mxY) {
                    mat[y][x1] += 1
            }
        } else if (y1 == y2) {
            val mnX = minOf(x1,x2); val mxX = maxOf(x1,x2)
            for (x in mnX..mxX) {
                mat[y1][x] += 1
            }
        // Part B
        } else {
            for (i in 0..abs(x1-x2)) {
                if (y1 < y2) {
                    if (x1 < x2) {
                        mat[y1 + i][x1 + i] += 1
                    } else {
                        mat[y1 + i][x1 - i] += 1
                    }
                } else {
                    if (x1 < x2) {
                        mat[y1 - i][x1 + i] += 1
                    } else {
                        mat[y1 - i][x1 - i] += 1
                    }
                }
            }
        }
    }
    //mPrint(mat)
    print(mCount(mat))
}

fun mPrint(mat: Array<Array<Int>>) { 
    for (array in mat) {
        for (value in array) {
            print(value)
        }
        println()
    }
}

fun mCount(mat: Array<Array<Int>>) : Int { 
    var count = 0
    for (array in mat) {
        for (value in array) {
            if (value >= 2){
              count += 1
            }
        }
    }
    return(count)
}
