typedef Point = { x : Int, y : Int }


class Ten {
    static public function main():Void {
        var lines = sys.io.File.getContent('input.txt').split("\n");
        var n = lines.length - 1;

	var start:Point = {x: 0, y: 0};
        var mat:Array<Array<String>> = [for (x in 0...n) [for (y in 0...n) " "]];
        var path:Array<Array<String>> = [for (x in 0...n) [for (y in 0...n) " "]];
        for (x in 0...n) {
            var chars = lines[x].split("");
            for (y in 0...chars.length) {
                if (chars[y] == "S") {
                  start = {x: x, y: y};
                }
                mat[x][y] = chars[y];
            }
	}
        var x = start.x;
        var y = start.y;
        var next = [{x: x+1, y: y},
		{x: x, y: y+1},
                {x: x-1, y: y},
                {x: x, y: y-1}];

        for (nx in next) {
            trace(validPathSteps(start, nx, mat, path));
        }

        // part two
        path = leftOrRight(start, next[0], mat, path);
        var p = path.map(p -> p.join("")).join("").split("");
        var inside = p.filter(function (i) return i == "i").length;
        trace(inside);
    }

    static function pprint(mat) {
        trace(mat.map(i -> i.join("")).join("\n"));
    }

    static function set(path,x,y,val) {
        if (path[x] != null) {
            if (path[x][y] == " ") {
                path[x][y] = val;
            }
        } 
    }

    static function same(p1, p2):Bool {
        return p1.x == p2.x && p1.y == p2.y;
    }
    
    static function validPathSteps(from, to, mat, path):Int {
        var steps = 0;
        var n = mat.length;

        var nx = mat[to.x][to.y];
        while (nx != "S") {
            nx = mat[to.x][to.y];
            if (nx == "S") {
                return Math.round(steps/2);
            }

            var d = getNext(from, to, nx);
            if (d == null) {
                return 0;
            }
            path[to.x][to.y] = nx;

            var next = {x: to.x + d.x, y: to.y + d.y};
            from = to;
            to = next;
            steps = steps + 1;
        }
        return 0;
    }

    static function getNext(from,to,nx) {
       var valid = [
          "|" => [{x: 1, y: 0},{x: -1, y: 0}],
          "-" => [{x: 0, y: 1},{x: 0, y: -1}],
          "L" => [{x: -1, y: 0},{x: 0, y: 1}],
          "J" => [{x: -1, y: 0},{x: 0, y: -1}],
          "7" => [{x: 1, y: 0},{x: 0, y: -1}],
          "F" => [{x: 1, y: 0},{x: 0, y: 1}],
          "." => [],
       ];
       var dirs = valid[nx];
       var prev_dist = {x:from.x-to.x, y:from.y-to.y};
       var dir = dirs.filter(function(p) return !same(p,prev_dist));
       if (dir.length == dirs.length) {
           return null;
       }
       return dir[0];
    }

    static function leftOrRight(from, to, mat,path): Array<Array<String>> {
        var nx = mat[to.x][to.y];
        while (nx != "S") {
            nx = mat[to.x][to.y];
            if (nx == "S") {
                break;
            }

           var d = getNext(from,to,nx);
           if (nx == "|") {
                if (d.x == 1) {
                    set(path,to.x,to.y+1,"i"); // left
                    set(path,to.x,to.y-1,"o"); // right
                } else {
                    set(path,to.x,to.y+1,"o"); // right
                    set(path,to.x,to.y-1,"i"); // left
                }
            } else if (nx == "-") {
                if (d.y == 1) {
                    set(path,to.x-1,to.y,"i"); // left
                    set(path,to.x+1,to.y,"o"); // right
                } else {
                    set(path,to.x-1,to.y,"o");
                    set(path,to.x+1,to.y,"i");
                }
            } else if (nx == "L") {
                if (d.y == 1) {
                    set(path,to.x,to.y-1,"o"); // right
                    set(path,to.x+1,to.y,"o"); // right
                } else {
                    set(path,to.x,to.y-1,"i"); //left
                    set(path,to.x+1,to.y,"i"); //left
                }
            } else if (nx == "F") {
                if (d.y == 1) {
                    set(path,to.x,to.y-1,"i"); // left
                    set(path,to.x-1,to.y,"i"); // left
                } else {
                    set(path,to.x,to.y-1,"o"); //right
                    set(path,to.x-1,to.y,"o"); //right
                }
            } else if (nx == "7") {
                if (d.y == -1) {
                    set(path,to.x-1,to.y,"o"); // right
                    set(path,to.x,to.y+1,"o"); // right
                } else {
                    set(path,to.x-1,to.y,"i"); // left
                    set(path,to.x,to.y+1,"i"); // left
                }
            } else if (nx == "J") {
                if (d.y == -1) {
                    set(path,to.x+1,to.y,"i"); // left
                    set(path,to.x,to.y+1,"i"); // left
                } else {
                    set(path,to.x+1,to.y,"o"); // right
                    set(path,to.x,to.y+1,"o"); // right
                }
            }

            var next = {x: to.x + d.x, y: to.y + d.y};
            from = to;
            to = next;
        }

        var n = path.length-1;
        for (x in 0...n) {
            for (y in 0...n) {
                if ((x == 0) || (x == n) || 
                   (y == 0) || (y == n)) {
                    path[x][y] = " ";
                } else if ((path[x][y] == " ") &&
                   ((path[x+1][y] == "i") ||
                   (path[x-1][y] == "i") ||
                   (path[x][y-1] == "i") ||
                   (path[x][y+1] == "i"))) {
                       path[x][y] = "i";
                }
            }
        }
        return path;
    }
}
