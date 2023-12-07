#! /usr/bin/env groovy

String readFile() {
    File file = new File("input.txt")
    return file.text
}

Integer type(h) {
    String[] ls = h.split("").sort()
    String[] u = ls.toUnique()

    if (ls[0] == ls[4]) {
        return 7
    } else if (ls[0] == ls[3] || ls[1] == ls[4]) {
        return 6
    } else if ((ls[0] == ls[2] && ls[3] == ls[4]) ||
                (ls[0] == ls[1] && ls[2] == ls[4])) {
        return 5
    } else if (u.size() == 5) {
        return 1
    } else if (u.size() == 4) {
        return 2
    } else { // triple + pair
        if ((ls[0] == ls[1] && ls[1] == ls[2]) ||
           (ls[1] == ls[2] && ls[2] == ls[3]) ||
           (ls[2] == ls[3] && ls[3] == ls[4])) {
            return 4
        } else { // two pairs
            return 3
        }
    }
}

Integer order(a,b) {
    def order = ["A": 14, "K": 13, "Q": 12,"J": 11,"T":10, "9":9, "8":8, "7":7, "6":6, "5":5, "4":4, "3":3, "2":2]
    for (int i = 0; i < a.length(); i++) {
        def aa = order[a[i]]
        def bb = order[b[i]]
        if (aa == bb) {
            continue
        } else if (aa > bb) {
            return 1
        } else {
            return -1
        }
    }
}

Integer compare(a, b) {
    def ta = type(a)
    def tb = type(b)
    if (ta < tb) {
        return -1
    } else if (ta > tb) {
        return 1
    } else {
        return order(a,b)
    }
}



Integer orderB(a,b) {
    def order = ["A": 14, "K": 13, "Q": 12,"T":10, "9":9, "8":8, "7":7, "6":6, "5":5, "4":4, "3":3, "2":2, "J":1]
    for (int i = 0; i < a.length(); i++) {
        def aa = order[a[i]]
        def bb = order[b[i]]
        if (aa == bb) {
            continue
        } else if (aa > bb) {
            return 1
        } else {
            return -1
        }
    }
}

Integer compareB(a, b) {
    def ta = bestType(a)
    def tb = bestType(b)
    if (ta < tb) {
      return -1
    } else if (ta > tb) {
      return 1
    } else {
      return orderB(a,b)
    }
}

Integer bestType(h) {
    if (!h.contains("J")) {
        return type(h)
    }
    String[] ls = h.split("").sort()
    def mx = 0
    for ( String l : ls ) {
        def t = type(h.replace("J",l))
        if (t > mx) {
            mx = t
        } 
    }
    return mx
}


public static void main(String[] args) {

    String[] lines = readFile().split("\n")
    def dict = [:]
    def hands = []
    for( String ln : lines ) {
        String[] entry = ln.split(" ")
        dict[entry[0]] = entry[1] as Integer
        hands.add(entry[0])
    }
    def sum = 0
    sorted = hands.sort { a, b -> compare(a, b) }
    sorted.eachWithIndex { s, index ->
        sum += (index+1) * dict[s]
    }
    println "A: "+sum

    def sumB = 0
    sorted = hands.sort { a, b -> compareB(a, b) }
    sorted.eachWithIndex { s, index ->
        sumB += (index+1) * dict[s]
    }
    println "B: "+sumB
}
