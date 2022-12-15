import scala.io.Source
import scala.collection.Iterable
import scala.collection.mutable.ListBuffer

object Fifteen{
    def main(args: Array[String]) = {
        val maxRow = 4000000
        val yRow = 2000000
        val filename = "fifteen.txt"
        val fileContents = Source.fromFile(filename).getLines.mkString
        val coords = ("""-*\d+""".r findAllIn fileContents).toList.grouped(4).toList 

        var sensors = new ListBuffer[(Int,Int,Int)]()
        for (c <- coords) {
            val x1 = c(0).toInt; val y1 = c(1).toInt
            val x2 = c(2).toInt; val y2 = c(3).toInt
            val dist = manhattan(x1,y1,x2,y2)
            sensors += ((x1,y1,dist))
        }
        var sen = sensors.toList

        for (r <- 0 to maxRow){
            var full = List[(Int,Int)]()
            for (s <- sen) {
                val x1 = s(0); val y1 = s(1)
                val dist = s(2)
                full = full ++ List(getPos(x1,y1,dist,r))
            }
            val m = merge(full.sorted,List())
            if (r == yRow) {
                val res = (m(0)(0)-m(0)(1)).abs
                println(s"A: $res") 
            }
            if (m.length > 1) {
                val x = m(0)(1).toLong + 1
                val y = r.toLong
                val b = ((x*maxRow) + y)
                println(s"B: $b")
            }
        }
    }

    def merge(ranges: List[(Int,Int)], acc: List[(Int,Int)]): List[(Int,Int)] = ranges match {
      case a :: b :: rest if a(1) >= b(0) => merge((a(0), (a(1).max(b(1)))) :: rest, acc)
      case a :: b :: rest                 => merge(b :: rest, acc :+ a )
      case a :: Nil                       => acc :+ a
    }

    def getPos(x1: Int, y1: Int, dist: Int, row: Int): (Int,Int) = {
        var j = (row - y1).abs
        var d = (dist-j).max(0)
        (x1-d,x1+d)
    }

    def manhattan(x1: Int, y1: Int, x2: Int, y2: Int): Int = {
        (x2 - x1).abs + (y2 - y1).abs
    }
}
