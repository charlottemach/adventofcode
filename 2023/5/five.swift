import Foundation

let path = "input.txt"

func readFile() -> String {
    var data: NSString
    do {
        data = try NSString(contentsOfFile: path, encoding: String.Encoding.ascii.rawValue)
        } catch {
            return (error.localizedDescription)
        }
    return data as String
}

struct Pair: Hashable {
    let a: Int
    let b: Int
}

func int(_ s: String) -> Int {
    return Int(s) ?? 0
}

func getMaps(maps: ArraySlice<String>) -> [String: [Pair: (Int,Int)]] {
    var m = [String: [Pair: (Int,Int)]]()
    for map in maps {
        let c = map.components(separatedBy: "\n")
        let name = c[0].components(separatedBy: " ")[0]

        var mapping = [Pair: (Int,Int)]()
        let nums = c[1...]
        for n in nums {
            let line = n.components(separatedBy: " ")
            let startFrom = int(line[1]) 
            let startTo = int(line[1]) + int(line[2]) - 1
            let endFrom = int(line[0])
            let endTo = int(line[0]) + int(line[2]) - 1
            mapping[Pair(a: startFrom, b: startTo)] = (endFrom, endTo)
        }
        m[name] = mapping
    }
    return m
}

func findKey(k:String, dict:[String: [Pair: (Int,Int)]]) -> String {
    for key in dict.keys {
        if key.hasPrefix(k) {
            return key
        } 
    }
    return ""
}

func findLocation(s: Int, dict:[String: [Pair: (Int,Int)]]) -> Int {
    var key = "seed"
    var s = s
    while (key != "location") {
        let next = findKey(k:key,dict:dict)
        let d = dict[next]!
        for pair in d.keys {
            if (s >= pair.a && s <= pair.b) {
                s = (s - pair.a) + d[pair]!.0
                break
            }
        }
        key = next.components(separatedBy: "-")[2]
    }
    return s
}

func main() {
    let data = readFile().trimmingCharacters(in: .newlines)
    let dataArr = data.components(separatedBy: "\n\n")
    let seeds = dataArr[0].components(separatedBy: " ")[1...]
    let dict = getMaps(maps: dataArr[1...])
    
    var minimal = 2147483647
    for seed in seeds {
        let s = int(seed)
        let loc = findLocation(s:s,dict:dict)
        minimal = loc < minimal ? loc : minimal
    }
    print("A: ",minimal)

    // this takes forever, instead stride by 1000s, find lowest output and check above and below
    minimal = 2147483647
    for i in stride(from: 1, to: seeds.count, by: 2) {
        let s1 = int(seeds[i])
        let s2 = int(seeds[i+1]) + s1
        print("seeds: ",s1,s2)
        //for s in s1...s2 {
        for s in stride(from: s1, to: s2, by: 1000) {
            let loc = findLocation(s:s,dict:dict)
            print(s,loc)
            if (loc < minimal) {
                minimal = loc
            }
        }
    }
    print(findLocation(s:391178260, dict:dict))
    print(findLocation(s:391178506, dict:dict))
    print("B: ",minimal)
}

main()
