const fs = require("fs");

function readFile(path) {
    const lines = fs.readFileSync(path).toString().trim().split("\n\n");
    const vals = lines[0].split("\n");
    const rest = lines[1].split("\n");
    return [vals,rest];
};

function getWire(val) {
    if (val in dict) {
        return dict[val];
    } else {
        let [op,a,b] = instr[val];
        switch (op) {
            case "AND":
                dict[val] = getWire(a, instr) & getWire(b, instr);
                break;
            case "OR":
                dict[val] = getWire(a, instr) | getWire(b, instr);
                break;
            case "XOR":
                dict[val] = getWire(a, instr) ^ getWire(b, instr);
                break;
            default:
                console.log("invalid op, did you take a bad turn?")
                return -1;
        }
        return dict[val];
    }
}

function getRule(z) {
    let [op,a,b] = instr[z]
    if ((a.startsWith("x") || a.startsWith("y")) 
        && (b.startsWith("x") || b.startsWith("y"))) {
        const arr = [a,b];
        arr.sort();
        return "(" + arr[0] + " " + op + ":" + z + " " + arr[1] + ")";
    } else {
        return "(" + getRule(a) + " " + op + ":" + z + " " + getRule(b) + ")";
    }
}

function fillInstrForZs(vals,lines) {
    var zs = [];
    for (i in vals) {
        var kv = vals[i].split(": ");
        dict[kv[0]] = Number(kv[1]);
    }
    for (j in lines) {
        var [a,op,b,_,key] = lines[j].split(" ");
        instr[key] = [op,a,b];
        if (key.startsWith("z")) {
            zs.push(key);
        }
    }
    return zs;
}

const [vals,rest] = readFile('input.txt')

let dict = {};
let instr = {};
let zs = fillInstrForZs(vals,rest);
zs.sort().reverse()
var a = zs.map(z => getWire(z)).join("");
console.log("A:", parseInt(a,2));

let rules = {};
for (i in zs) {
    let r = getRule(zs[i]);
    rules[zs[i]] = r;
}

// check rules match format, if they don't find swap target of named operation with the correct one in the input file
// Z3 = (X3 XOR Y3)
//     XOR ((X2 AND Y2)
//      OR ((X2 XOR Y2) AND (X1 AND Y1))
//      OR ((X2 XOR Y2) AND (X1 XOR Y1) AND (X0 AND Y0))

//console.log(rules);

let fixed = ["z08","vvr","rnq","bkr","tfb","z28","mqh","z39"];
fixed.sort();
console.log("B:",fixed.join(","));
