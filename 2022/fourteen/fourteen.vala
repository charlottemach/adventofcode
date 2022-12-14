

int min(int x,int y){
    return (x < y) ? x : y;
}
int max(int x,int y){
    return (x >= y) ? x : y;
}

bool add_sand_b(string[,] cave_b,int maxy){
    int curx = 500; int cury = 0;
    bool stop = false;
    while (!stop){
        if (cave_b[curx,cury] == "o"){
            return false;
        }
        if (cury + 1 == maxy){
            cave_b[curx,cury] = "o";
	    stop = true;
        }
        else if (cave_b[curx,cury+1] == null){
            cury = cury + 1;
        } else {
            if (cave_b[curx-1,cury+1] == null){
                curx = curx - 1; cury = cury + 1;
            } else if (cave_b[curx+1,cury+1] == null){
                curx = curx + 1; cury = cury + 1;
            } else {
                cave_b[curx,cury] = "o";
                stop = true;
            }
        } 
    }
    return true;
}

bool add_sand(string[,] cave_a){
    int curx = 500; int cury = 0;
    bool stop = false;
    while (!stop){
        if (curx > 600 || cury > 200) {
            return false;
        }
        if (cave_a[curx,cury+1] == null){
            cury += 1;
        } else {
            if (cave_a[curx-1,cury+1] == null){
                curx = curx - 1; cury = cury + 1;
            } else if (cave_a[curx+1,cury+1] == null){
                curx = curx + 1; cury = cury + 1;
            } else {
                cave_a[curx,cury] = "o";
                stop = true;
            }
        } 
    }
    return true;
}

void main() {
    string content;
    FileUtils.get_contents("fourteen.txt", out content);
    string[] lines = content.split("\n");

    string[,] cave_a = new string[700,200];
    string[,] cave_b = new string[700,200];
    int maxy = 0;
    foreach (string line in lines){
        if (line != "") {
            string[] points = line.split(" -> ");
            string[] p = points[0].split(",");
            int p1 = int.parse(p[0]);
            int p2 = int.parse(p[1]);
            maxy = max(maxy,p2);
            string[] next = points[1:points.length];

            foreach (string n in next){
                string[] ns = n.split(",");
                int n1 = int.parse(ns[0]);
                int n2 = int.parse(ns[1]);
                maxy = max(maxy,n2);
                for (int x=min(p1,n1);x<=max(p1,n1);x++) {
                    for (int y=min(p2,n2);y<=max(p2,n2);y++) {
                        cave_a[x,y] = "#";
                        cave_b[x,y] = "#";
                    }
                }
                p1 = n1;
                p2 = n2;
            }
        } 
    }
    bool ok = true; int cnt = 0;
    while (ok) {
        ok = add_sand(cave_a);
        cnt = cnt + 1;
    }
    stdout.printf ("A: %d\n", cnt-1);
    ok = true; cnt = 0;
    while (ok) {
        ok = add_sand_b(cave_b,maxy+2);
        cnt = cnt + 1;
    }
    stdout.printf ("B: %d\n", cnt-1);
}
