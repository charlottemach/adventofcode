import Foundation

let path = "input.txt"
var map = [[String]]()
var counted = [[String]]()

func readFile() -> String {
    var data: NSString
    do {
        data = try NSString(contentsOfFile: path, encoding: String.Encoding.ascii.rawValue)
        } catch {
            return (error.localizedDescription)
        }
    return data as String
}

struct Point: Hashable {
    let x: Int
    let y: Int
}

func getMap(lines: [String]) -> [[String]] {
    return lines.map({Array($0.map({String($0)}))})
}

func getSameNeighbours(p: Point) -> [Point]{
    var nb = [Point]()
    for dir in [[1,0],[0,1],[-1,0],[0,-1]] {
        let nx = p.x + dir[0]
        let ny = p.y + dir[1]
        if (inRange(x:nx,y:ny)) {
            if (map[p.y][p.x] == map[ny][nx]) {
                nb.append(Point(x:nx,y:ny))
            }
        }
    }
    return nb
}

func getNeighbours(p: Point, prev: Point) -> [Point]{
    var nb = [Point]()
    for dir in [[1,0],[0,1],[-1,0],[0,-1]] {
        let nx = p.x + dir[0]
        let ny = p.y + dir[1]
        if (!(nx == prev.x && ny == prev.y) && inRange(x:nx,y:ny)) {
            nb.append(Point(x:nx,y:ny))
        }
    }
    return nb
}

func getPerimeter(p: Point) -> Int {
   let nb = getNeighbours(p: p, prev:p)
   let diff = nb.filter({map[p.y][p.x] != map[$0.y][$0.x]}).count
   return 4 - nb.count + diff
}

func inRange(x:Int,y:Int) -> Bool {
    let n = map.count
    return (x >= 0 && x < n && y >= 0 && y < n)
}

func getSides(areaPoints: [Point]) -> Int {
    var s = 0
    for p in areaPoints {
        let (x,y) = (p.x,p.y)
        let nb = getSameNeighbours(p:p)
        switch (nb.count) {
            case 0:
                return 4
            case 1:
                s += 2
            case 2:
                if (nb[0].x != nb[1].x && nb[0].y != nb[1].y) {
                    s += 1
                    if (nb[0].x != x) {
                        if (map[y][x] != map[nb[1].y][nb[0].x]) { 
                            s += 1
                        }
                    } else if (map[y][x] != map[nb[0].y][nb[1].x]) { 
                        s += 1
                    }
                }
            case 3:
                let (n0,n1,n2) = (nb[0],nb[1],nb[2])
                let coord = [(n0.x,n1.y),(n0.x,n2.y),(n1.x,n0.y),(n1.x,n2.y),(n2.x,n0.y),(n2.x,n1.y)]
                let filt_coord = coord.filter({!($0.0 == n0.x && $0.1 == n0.y) || 
                              !($0.0 == n1.x && $0.1 == n1.y) ||
                              !($0.0 == n2.x && $0.1 == n2.y) ||
                              !($0.0 == x && $0.1 == y) }).filter({map[$0.1][$0.0] != map[y][x]})
                s += filt_coord.count
            case 4:
                let corners = [map[y+1][x+1],map[y+1][x-1],map[y-1][x+1],map[y-1][x-1]]
                s += corners.filter({$0 != map[y][x]}).count
            default:
                print("wrong turn")
        }
    }
    return s
}

func arPer(p: Point, todo: inout [Point]) -> [(Int,Int,[Point])]{
    if (todo.count == 0) {
        return [(0,0,[])]
    }
    let next = todo[0]
    todo.removeFirst()
    if counted[next.y][next.x] == "-" {
        return arPer(p:p, todo:&todo)
    }
    let v1 = map[p.y][p.x]
    let v2 = map[next.y][next.x]
    if (v1 == v2) {
        counted[next.y][next.x] = "-"
        var nb = getNeighbours(p: next, prev: p)
        let perim = getPerimeter(p:next)
        return [(1,perim,[next])] + arPer(p:p, todo:&todo) + arPer(p: next, todo:&nb)
    }
    return arPer(p:p, todo:&todo)
}

func main() {
    let data = readFile().trimmingCharacters(in: .newlines)
    let lines = data.components(separatedBy: "\n")
    map = getMap(lines: lines)
    counted = map
    
    var prices = 0
    var discountPrices = 0
    for (y,line) in map.enumerated() {
        for (x,_) in line.enumerated() {
            if counted[y][x] != "-" {
                let start = Point(x:x,y:y)
                var todo = getNeighbours(p:start,prev:start)
                counted[y][x] = "-"
                let arPer = arPer(p: start, todo: &todo)
                let perimeter = arPer.map({$0.1}).reduce(0, +) + getPerimeter(p:start)
                let areaPoints = arPer.flatMap({$0.2}) + [start]
                let area = areaPoints.count
                let sides = getSides(areaPoints:areaPoints)

                prices += area * perimeter
                discountPrices += area * sides
            }
        }
    }
    print("A: ",prices)
    print("B: ",discountPrices)
}

main()
