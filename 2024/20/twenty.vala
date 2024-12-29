struct Pnt {
    public int x;
    public int y;
    public Pnt(int x,int y) {
        this.x = x;
        this.y = y;
    }
}

struct Context {
    Pnt[] path;
    string[,] time;
}

string pprint(string[,] map) {
    string s = "";
    for (int a = 0; a < map.length[0]; a++) {
        for (int b = 0; b < map.length[1]; b++) {
            s += map[a,b];
        }
        s += "\n";
    }
    return s;
}

Context get_path_and_time(string[,] map, Pnt s, Pnt e) {
    Pnt[] path = {e};
    string[,] t = map;
    int cnt = 0;
    Pnt p = e;
    while (true) {
        int[,] nb = {{1,0},{0,1},{-1,0},{0,-1}};
        for (int i = 0; i < nb.length[0]; i++) {
            Pnt n = {e.x + nb[i,0], e.y + nb[i,1]};
            if (n == s) { 
                path += n;
                t[e.y,e.x] = cnt.to_string();
                t[s.y,s.x] = (cnt+1).to_string();
                Context c = {path, t};
                return c;
            }
            if (map[n.y,n.x] != "#" && !(p == n) ) {
                t[e.y,e.x] = cnt.to_string();
                p = e; e = n;
                cnt += 1;
                path += n;
                break;
            }
        }
    }
}

//Pnt[] get_neighbours(string[,] map, Pnt s){
//    Pnt[] res = {};
//    int ln = map.length[0]-1;
//    int[,] dir = {{1,0},{0,1},{-1,0},{0,-1}};
//    for (int j = 0; j < dir.length[0]; j++) {
//        int nx = s.x + dir[j,0]; int ny = s.y + dir[j,1];
//        if (nx >= 0 && ny >= 0 && nx < ln && ny < ln) {
//            if (map[ny,nx] == "#") {
//                res += Pnt(nx,ny);
//            }
//        }
//    }
//    return res;
//}
//
//Pnt[] get_all_neighbours(string[,] map, Pnt s){
//    Pnt[] res = {};
//    int ln = map.length[0]-1;
//    int[,] dir = {{1,0},{0,1},{-1,0},{0,-1}};
//    for (int j = 0; j < dir.length[0]; j++) {
//        int nx = s.x + dir[j,0]; int ny = s.y + dir[j,1];
//        if (nx >= 0 && ny >= 0 && nx < ln && ny < ln) {
//            res += Pnt(nx,ny);
//        }
//    }
//    return res;
//}
//
//  int bfs(string[,] map,int sx,int sy,int ex,int ey) {
//      Pnt[] visited = {};
//      Pnt start = {sx,sy};
//      Pnt[] todo = {start};
//      int[,] dist = new int[142,142];
//      Pnt e = {ex,ey};
//      while (todo.length != 0) {
//          Pnt s = todo[0];
//          if (((s.x - e.x).abs() == 1 && s.y == e.y)
//              || ((s.y - e.y).abs() == 1 && s.x == e.x)) {
//                  return dist[s.y,s.x] + 1;
//          }
//          todo = todo[1:];
//          Pnt[] nb = get_all_neighbours(map,s);
//          for (int i = 0; i < nb.length; i++) {
//              Pnt n = nb[i];
//              if (!(n in visited) && dist[n.y,n.x] < dist[s.y,s.x]+1) {
//                  todo += n;
//                  dist[n.y,n.x] = dist[s.y,s.x]+1;
//                  visited += n;
//              }
//          }
//      }
//      return dist[ey,ex];
//  }

int cheatable(string[,] map, string[,]times, Pnt s, Pnt e, int mx, int c_len) {
    int dist = (s.x-e.x).abs() + (s.y - e.y).abs();
    if (dist <= c_len) {
        int sdiff = int.parse(times[s.y,s.x]);
        int ediff = mx - int.parse(times[e.y,e.x]);
        return mx - (sdiff + dist + ediff);
    }
    return 0;
}

int track(string[,] map, Pnt s, Pnt e, int c_len) {
    int cnt = 0;
    Context c = get_path_and_time(map,s,e);
    string[,] times = c.time;
    Pnt[] path = c.path;
    int mx = int.parse(times[s.y,s.x]);

    for (int i = 0; i < path.length; i++) {
        Pnt p = path[i];
        for (int j = i+2; j < path.length; j++) {
            Pnt t = path[j];
            int saved = cheatable(map,times,p,t,mx,c_len);
            if (saved >= 100) {
                cnt += 1;
            }
        }
    }
    return cnt;
}

void main() {
    string content;
    FileUtils.get_contents("input.txt", out content);
    string[] lines = content.split("\n");

    int y = 0;
    Pnt start = {0,0};
    Pnt end = {0,0};
    int n = lines.length;
    string[,] racetrack = new string[n,n];
    foreach (string line in lines){
        if (line != "") {
            for (int x = 0; x < line.length; x++) {
                string v = line.slice(x,x+1);
                if (v == "S") { start = {x,y}; }
                if (v == "E") { end = {x,y}; }
                racetrack[y,x] = v;
            }
            y += 1;
        } 
    }
    // stdout.printf ("%s ", pprint(racetrack));
    stdout.printf ("A: %d\n", track(racetrack,start,end,2));
    stdout.printf ("B: %d\n", track(racetrack,start,end,20));
}
