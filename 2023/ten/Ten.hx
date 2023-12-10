typedef Point = { x : Int, y : Int }


class Ten{

    static public function main():Void {
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");
        var n = lines.length - 1;

	var start:Point = {x: 0, y: 0};
        var mat:Array<Array<String>> = [for (x in 0...n) [for (y in 0...n) ""]];
        for (x in 0...n) {
            var chars = lines[x].split("");
            for (y in 0...chars.length) {
                if (chars[y] == "S") {
                  start.x = x;
                  start.y = y;
                }
                mat[x][y] = chars[y];
            }
	}
        var x = start.x;
        var y = start.y;
        var next = [
		{x: x+1, y: y},
		{x: x, y: y+1},
                {x: x-1, y: y},
                {x: x, y: y-1}];
        //for (nx in next) {
        //    trace(validPathSteps(start, nx, mat, 0));
        //}
        trace(validPathSteps(start, next[0], mat, 0));

        //pprint(mat);
    }

    static function pprint(mat) {
        trace(mat.map(i -> i.join("")).join("\n"));
    }

    static function same(p1, p2):Bool {
        return p1.x == p2.x && p1.y == p2.y;
    }
    
    static function validPathSteps(from, to, mat, steps):Int {
        var n = mat.length;
        var valid = [
            "|" => [{x: 1, y: 0},{x: -1, y: 0}],
            "-" => [{x: 0, y: 1},{x: 0, y: -1}],
            "L" => [{x: -1, y: 0},{x: 0, y: 1}],
            "J" => [{x: -1, y: 0},{x: 0, y: -1}],
            "7" => [{x: 1, y: 0},{x: 0, y: -1}],
            "F" => [{x: 1, y: 0},{x: 0, y: 1}],
            "." => [],
        ];

        var nx = mat[to.x][to.y];
        while (nx != "S") {
            nx = mat[to.x][to.y];
            if (nx == "S") {
                return Math.round(steps/2);
            }

            var dirs = valid[nx];
            var prev_dist = {x:from.x-to.x, y:from.y-to.y};
            var dir = dirs.filter(function(p) return !same(p,prev_dist));
            if (dir.length == dirs.length) {
                return 0;
            }

            var next = {x: to.x + dir[0].x, y: to.y + dir[0].y};
            from = to;
            to = next;
            steps = steps + 1;
        }
        return 0;
    } 
}
