import java.io.File

val nx = 101
val ny = 103
val file = "input.txt"

fun main() {
    val input = File(file).readText()
    val dict = getRobots(input.trim().split("\n"), 100)
    val map = printRobots(input.trim().split("\n"), 6870)
    pprint(map)

    val c = countRobots(dict)
    println("A: $c")
    println("B: 6870") // manually checked printed maps
}

fun getRobots(inp: List<String>, times:Int):MutableMap<Int,Pair<Int,Int>> {
    var dict = mutableMapOf<Int, Pair<Int,Int>>()
    var r = 0
    for (line in inp) {
        val (sx,sy,vx,vy) = line.substring(2,line.length).split(","," v=").map { it.toInt() }
        val (x,y) = move(Pair(sx,sy),Pair(vx,vy),times)
        dict[r] = Pair(x,y)
        r += 1
    }
    return dict
}

fun printRobots(inp: List<String>, times:Int):ArrayList<ArrayList<Int>> {
    val map = ArrayList<ArrayList<Int>>()
    var dict = getRobots(inp,0)
    for (y in 0..(ny-1)) {
        var row = ArrayList<Int>()
        for (x in 0..(nx-1)) {
            row.add(0)
        }
        map.add(row)
    }
    for (i in 1..times) {
        dict.forEach { kv ->
            val r = kv.key
            val (sx,sy) = kv.value
            val (_,_,vx,vy) = inp[r].substring(2,inp[r].length).split(","," v=").map { it.toInt() }

            map[sy][sx] = maxOf(map[sy][sx] - 1,0)
            val (x,y) = move(Pair(sx,sy),Pair(vx,vy),1)
            map[y][x] = map[y][x] + 1
            dict[r] = Pair(x,y)
        }
    }
    return map
}

fun move(s:Pair<Int,Int>, vel:Pair<Int,Int>, times:Int):Pair<Int,Int> {
    if (times == 0) {
        return s
    }
    var (sx,sy) = s
    var (vx,vy) = vel
    var x = (sx + vx) % nx
    var y = (sy + vy) % ny
    if (x < 0) { x += nx }
    if (y < 0) { y += ny }
    return move(Pair(x,y), vel, times-1)
}

fun countRobots(d: Map<Int,Pair<Int,Int>>):Int {
    val xmid = nx/2
    val ymid = ny/2
    val left = d.values.filter( { it.first != xmid && it.second != ymid })
    var one = 0; var two = 0; var three = 0; var four = 0
    for (rob in left) {
        var (x,y) = rob
        if (x < xmid && y < ymid) {
            one += 1
        } else if (x < xmid && y > ymid) {
            two += 1
        } else if (x > xmid && y < ymid) {
            three += 1
        } else {
            four += 1
        }
    }
    return one * two * three * four
}

fun pprint(map: ArrayList<ArrayList<Int>>) {
    for (line in map) {
        for (l in line) {
            if (l == 0) {
                print(" ")
            } else {
                print("X")
            }
        }
        print("\n")
    }
}
