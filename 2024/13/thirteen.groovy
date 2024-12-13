#! /usr/bin/env groovy

String readFile() {
    File file = new File("input.txt")
    return file.text
}

Integer[] count(ax,ay,bx,by,prizex,prizey,max) {
    for (int i = 0; i <= max; i++) {
        for (int j = max; j >= 0; j--) {
             int xx = ax * i + bx * j
             int yy = ay * i + by * j
             if (xx == prizex && yy == prizey) {
                 return [i,j]
             }
        }
    }
    return [0,0]
}

BigInteger[] cramersRule(ax,ay,bx,by,cx,cy) {
    BigInteger x = (cx * by - bx * cy).intdiv(ax * by - bx * ay)
    BigInteger y = (ax * cy - cx * ay).intdiv(ax * by - bx * ay)
    if ((ax * x + bx * y == cx) && (ay * x + by * y == cy)) {
        return [x,y]
    }
    return [0,0]
}

Integer[] parseGame(game) {
    return game.findAll(/[0-9]+/).collect{Integer.valueOf(it)}
}

BigInteger[] parseHarderGame(game) {
    return game.findAll(/[0-9]+/).collect{Integer.valueOf(it)+10000000000000}
}

public static void main(String[] args) {

    String[] machines= readFile().split("\n\n")

    Integer sum = 0
    BigInteger sumB = 0
    for ( String game : machines ) {
        String[] g = game.split("\n")
        Integer[] a = parseGame(g[0])
        Integer[] b = parseGame(g[1])

        Integer[] prize = parseGame(g[2])
        BigInteger[] prizeB = parseHarderGame(g[2])

        // Integer[] cost = count(a[0],a[1],b[0],b[1],prize[0],prize[1],100)
        Integer[] cost = cramersRule(a[0],a[1],b[0],b[1],prize[0],prize[1])
        BigInteger[] costB = cramersRule(a[0],a[1],b[0],b[1],prizeB[0],prizeB[1])

        sum += cost[0] * 3 + cost[1] * 1
        sumB += costB[0] * 3 + costB[1] * 1
    }
    println "A: "+sum
    println "B: "+sumB
}
