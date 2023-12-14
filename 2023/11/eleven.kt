import java.io.File
import java.math.BigInteger
import java.util.Collections

fun main() {
    val input = File("input.txt").readText()
    println(cosmicExpansion(input,2))
    println(cosmicExpansion(input,1000000))
}

fun cosmicExpansion(input: String, times: Int):BigInteger{
    var lines = input.split("\n").dropLast(1)
    var n = lines.size
    var map = Array(n) {Array(n) {""} }
    var galaxies = arrayOf<Pair<Int,Int>>()
    for (y in 0..n-1) {
        val line = lines[y].split("").drop(1).dropLast(1)
        for (x in 0..n-1) {
            var v = line[x]
            map[y][x] = v 
            if (v == "#") {
                galaxies += Pair(x,y)
            }
        }
    }
    //pprint(map)

    var distSum = 0.toBigInteger()
    var (xs,ys) = getExpandLines(map,n)
    for (gi in 0..galaxies.size) {
        for (gj in gi+1..galaxies.size-1) {
            var p1 = galaxies[gi]
            var p2 = galaxies[gj]
            distSum += getDist(p1,p2,xs,ys,times)
         }
    }
    return distSum
}

fun getDist(p1:Pair<Int,Int>, p2:Pair<Int,Int>, xs:Array<Int>, ys: Array<Int>, times:Int):BigInteger {
    var (x1,y1) = p1
    var (x2,y2) = p2
    var dist = Math.abs(x2-x1) + Math.abs(y2-y1)
    if (x1 < x2) {
        x2 = x1.apply{x1 = x2} 
    }
    if (y1 < y2) {
        y2 = y1.apply{y1 = y2} 
    }

    var cnt = 0
    for (xx in x2..x1) {
        if (xs.any({x -> x==xx})) {
            cnt += 1
        }
    }
    for (yy in y2..y1) {
        if (ys.any({y -> y==yy})) {
            cnt += 1
        }
    }
    return dist.toBigInteger() + (cnt.toBigInteger() * (times-1).toBigInteger())
}

fun getExpandLines(map:Array<Array<String>>, n:Int):Pair<Array<Int>,Array<Int>> {
    var ys = arrayOf<Int>()
    for (x in 0..n-1) {
        var col = arrayOf<String>()
        for (y in 0..n-1) {
            col += map[y][x]
        }
        if (col.all({y -> y=="."})) {
            ys += x
        }
    }
    var xs = arrayOf<Int>()
    for (x in 0..n-1) {
        if (map[x].all({x -> x!="#"})) {
            xs += x
        }
    } 
    return Pair(ys,xs)
}

fun pprint(map: Array<Array<String>>) {
    for (line in map) {
        for (l in line) {
            print(l)
        }
        print("\n")
    }
}
