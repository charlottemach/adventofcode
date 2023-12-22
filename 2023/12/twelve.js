const fs = require("fs");

function readFile(path) {
    return fs.readFileSync(path).toString().trim();
};


function hotSpring(spring, group, cache = {}) {
    var [curGroup, ...restGroup] = group;
    var block = spring.slice(0, restBlock(group));

    const cacheKey = curGroup + block.join('') + restGroup.join('');
    if (cache[cacheKey] !== undefined) {
        return cache[cacheKey];
    }

    let total = 0;
    for (let i=0; i<=block.length-curGroup; i++) {
        const leftOfSub = block.slice(0,i);
        const subBlock = block.slice(i,curGroup+i);
        if (subBlock[0] == ".") { continue; }

        const restSprings = spring.slice(curGroup+i+1,spring.length);

        if (leftOfSub.includes("#")) {
            break;
        }
        if (block[curGroup+i] == "#") {
            if (block[Number(i)] != "#") {
                continue;
            } else { break; }
        }
        if (match(subBlock,curGroup)) {
            if (restGroup.length == 0) {
                if (restSprings.includes("#")) {
                    if (subBlock[0] == "#") {
                        break;
                    } else {
                        continue;
                    }
                } else {
                    if (restSprings.length == 0) {
                        cache[cacheKey] = total + 1;
                        return total + 1;
                    }
                    total += 1;
                } 
            } else {
                var arr = hotSpring(restSprings, restGroup, cache)
                total += arr;
            }
        } else {
            if (subBlock[0] == "#") {
               break;
            }
        }
    }
    cache[cacheKey] = total;
    return total;
}


function match(spring, g) {
    const springs = "#".repeat(g)
    for (i in spring) {
        if (spring[i] != springs[i] && spring[i] != "?") {
            return false;
        }
    }
    return true;
}

function restBlock(group) {
    const tail = group.slice(1)
    const sum = tail.reduce((acc, x) => acc + x, 0);
    return group.length - (sum + tail.length) - 2
}

const lines = readFile('input.txt').split("\n")
let arrangements = 0;
let arrangementsUnfolded = 0;

for (let i in lines){
    var line = lines[i].split(" ");
    var spring = ("." + line[0] + ".").split("");
    var group = line[1].split(",").map(Number);
    arrangements += hotSpring(spring, group)
   
    var uspring = ("." + (line[0] + "?").repeat(4) + line[0] + ".").split("")
    var ugroup = group.concat(group).concat(group).concat(group).concat(group)
    var b = hotSpring(uspring, ugroup)
    arrangementsUnfolded += hotSpring(uspring,ugroup)
};

console.log("A:", arrangements);
console.log("B:", arrangementsUnfolded);
