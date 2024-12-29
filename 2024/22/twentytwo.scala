import scala.io.Source
import scala.collection.mutable.Map
import scala.math.BigInt

object TwentyTwo{

    val globalMarket = Map[List[BigInt],BigInt]()

    def main(args: Array[String]) = {
        val input = Source.fromFile("input.txt").getLines.toList
        val s = calc(input)
        println(s"A: $s")

        calcB(input)
        val r = globalMarket.values.max
        println(s"B: $r")
    }

    def calc(ls: List[String]): BigInt = ls match {
        case l :: Nil  => evolve_n(l.toInt,2000)
        case l :: rest => evolve_n(l.toInt,2000) + calc(rest)
    }

    def mixAndPrune(secret: BigInt, num: BigInt): BigInt = {
        (secret ^ num) % 16777216
    }

    def evolve(num: BigInt): BigInt = {
        val a = mixAndPrune(num,num*64)
        val b = mixAndPrune(a,a/32)
        mixAndPrune(b,b*2048)
    }

    def evolve_n(num:BigInt, times: Int): BigInt = times match {
        case 1 => evolve(num)
        case _ => evolve_n(evolve(num),times-1)
    }

    def marketPrice(seq: List[BigInt], markets: List[Map[List[BigInt],BigInt]]): BigInt = {
        val prices:List[BigInt] = markets.map(x => x.getOrElse(seq,0))
        prices.sum
    }

    def calcB(ls: List[String]) = {
        var markets = ls.map(l => getMarket(l.toInt,2000))
        for (m <- markets) {
            for (mseq <- m.keySet) {
                if (!globalMarket.keySet.exists(_==mseq)) {
                    globalMarket.put(mseq,marketPrice(mseq,markets))
                }
            }
        }
    }

    def getMarket(num: BigInt, times: Int): Map[List[BigInt],BigInt] = {
        val prices = num%10 :: price(num,List[BigInt](),2000)
        val diffs = diff(prices)
        val market = Map[List[BigInt],BigInt]()
        for (i <- (0 to (diffs.length-4))) {
            val seq = diffs.drop(i).take(4)
            if (!market.keySet.exists(_==seq)) {
                market.put(seq,prices.take(i+5).last)
            }
        }
        market
    }
    def price(num:BigInt, ls:List[BigInt], times: Int): List[BigInt] = times match {
        case 0 => ls
        case _ => val e = evolve(num)
                  price(e, ls :+ (e % 10), times - 1)
    }

    def diff(ls: List[BigInt]): List[BigInt] = ls match {
        case a :: b :: rest => b-a :: diff(b :: rest)
        case _ => Nil
    }
}
