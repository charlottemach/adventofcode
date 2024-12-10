typedef Point = { x : Int, y : Int }

class Ten {
    static public function main():Void {
        var lines = sys.io.File.getContent('input.txt').split("\n");
        var n = lines.length - 1;

	var startPoints:Array<Point> = [];
        var mat:Array<Array<Int>> = [for (x in 0...n) [for (y in 0...n) 0]];
        for (x in 0...n) {
            var chars = lines[x].split("");
            for (y in 0...chars.length) {
                if (chars[y] == "0") {
                  startPoints = startPoints.concat([{x:x,y:y}]);
                }
                if (chars[y] == ".") {
                  mat[x][y] = 0;
                } else {
                mat[x][y] = Std.parseInt(chars[y]);
                }
            }
	}
        // pprint(mat);
        var paths = 0;
        var upaths = 0;
        for (start in startPoints) {
           var todo:Array<Point> = getNeighbours(start, start, n);
           var tpaths = dfs(start, todo, [], mat);
           paths += getUnique(tpaths).length;
           upaths += tpaths.length;
        }
        trace("A:"+Std.string(paths));
        trace("B:"+Std.string(upaths));
    }

    static function getUnique<T>(array:Array<Point>) {
        var l = [];
        for (p in array) {
            var s = Std.string(p.x) + "." + Std.string(p.y);
            if (l.indexOf(s) == -1) {
                l.push(s);
            }
         }
        return l;
    }

    static function pprint(mat) {
        trace(mat.map(i -> i.join("")).join("\n"));
    }

    static function getNeighbours(p, src, n) {
        var nb:Array<Point> = [];
        for (dir in [[1,0],[-1,0],[0,1],[0,-1]]) {
            var nx:Int = p.x + dir[0];
            var ny:Int = p.y + dir[1];
            if (!(nx == src.x && ny == src.y) && (nx >=0 && nx < n && ny >= 0 && ny < n)) {
                nb = nb.concat([{x:nx,y:ny}]);
            }
        }
        return nb; 
    }

    static function dfs(p:Point, todo:Array<Point>, visited:Array<Point>, map:Array<Array<Int>>) {
        if (todo.length == 0) {
            return [];
        }
        visited = visited.concat([p]);
        var next:Point = todo[0];
        todo.remove(next);
        if (visited.contains(next)) {
            return [];
        }

        var curVal:Int = map[p.x][p.y]; 
        var nextVal:Int = map[next.x][next.y]; 
        if (curVal == 9) {
            return [p];
        }
        if (curVal == nextVal - 1) {
            var n = map.length;
            var nextN = getNeighbours(next, p, n);
            return dfs(next, nextN, [p], map).concat(dfs(p, todo, visited, map));
        }
        return dfs(p, todo, visited, map);
    }
}
