import scala.io._

object Nine {
    def main(args: Array[String]): Unit = {
        var lines = Source.fromFile("nine.txt").getLines().toList
        val (cntA, lows) = partA(lines)
        println(cntA)
        println(partB(lines,lows))
    }

    def partB(lines: List[String], lows: List[(Int,Int)]): Int = {
        var bas: List[Int] = Nil 
        for ((x,y) <- lows) {
            bas = getNext(lines,x,y).size :: bas
        }
        return bas.sortWith(_ > _).take(3).product
    }

    def getNext(lines: List[String], x:Int,y:Int): Set[(Int,Int)] = {
        var cur = lines(x)(y)
        var path = Set[(Int, Int)]()
        if (cur == '9' || cur == 'x') {
            return path
        }
        var ll = lines.updated(x,lines(x).substring(0,y) + 'x' + lines(x).substring(y+1))
        if (x > 0) {
           if (cur <= lines(x-1)(y)) { path = getNext(ll,x-1,y) ++ path }
        } 
        if (x < lines.size-1) {
           if (cur <= lines(x+1)(y)) { path = getNext(ll,x+1,y) ++ path }
        }
        if (y > 0) {
           if (cur <= lines(x)(y-1)) { path = getNext(ll,x,y-1) ++ path }
        }
        if (y < lines(0).size-1) {
           if (cur <= lines(x)(y+1)) { path = getNext(ll,x,y+1) ++ path }
        }
        return path + ((x,y))
    }

    def partA(lines: List[String]): (Int, List[(Int,Int)]) = {
        var m = lines.size
        var n = lines(0).size
        var cnt = 0
        var lows: List[(Int, Int)] = Nil
        for (x <- 0 until m) {
            for (y <- 0 until n) {
                 var lowest = true
                 var cur = lines(x)(y)
                 if (x > 0) { lowest = lowest && (cur < lines(x-1)(y)) } // left
                 if (x < m-1) { lowest = lowest && (cur < lines(x+1)(y)) } // right
                 if (y > 0) { lowest = lowest && (cur < lines(x)(y-1)) } // below
                 if (y < n-1) { lowest = lowest && (cur < lines(x)(y+1)) } // above
                 if (lowest) {
                     cnt = cnt + cur.asDigit + 1
                     lows = (x,y) :: lows
                 }
            }
        }
        return (cnt, lows)
    }
}


