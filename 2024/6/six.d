import std.algorithm;
import std.conv;
import std.file: readText;
import std.meta : AliasSeq;
import std.stdio;
import std.string;
import std.typecons : tuple;


void printMat(char [][] mat){
    foreach (i,line; mat){
        foreach (j,v; line){ write(v); }
        writeln();
    }
}

auto parseMat(string txt){
    string[] lines = txt.split("\n");
    int x = 0; int y = 0;
    int n = to!int(lines.length);
    int m = to!int(lines[0].length);
    char[][] mat = new char[][](n,m);
    foreach (i,line ; lines) {
        foreach(j,val; line) {
            if (val == '^')  {
                x = to!int(i);
                y = to!int(j);
            }
            mat[i][j] = val; 
        }
    }
    return tuple(mat, x, y);
}

bool inRange(int n, int x, int y) {
    return (x >= 0 && x < n && y >= 0 && y < n);
}

int walk(char[][] mat, int x, int y) {
    // start walking north
    int dirx = -1;
    int diry = 0;
    int n = to!int(mat.length);

    int steps = 1;
    int safeguard = 0;
    do {
        int nextx = x + dirx;
        int nexty = y + diry;
        if (mat[nextx][nexty] == '#') {
            // turn right 90 degrees
            int tmp = dirx;
            dirx = diry;
            diry = -tmp;
        } else {
            x = nextx;
            y = nexty;
            if (mat[x][y] == '.') {
                steps += 1;
                mat[x][y] = 'X';
            }
        }
        safeguard += 1;
        if (safeguard > n * n) { return -1; }
    } while (inRange(n,x+dirx,y+diry));
    return steps;
}

int walkWithObstacles(char[][] mat, int x, int y) {
    int n = to!int(mat.length);
    int loop = 0;
    foreach (i,line; mat){
        foreach (j,v; line){ 
            if (mat[i][j] == 'X') {
                mat[i][j] = '#';
                int steps = walk(mat,x,y);
                if (steps == -1) {
                    loop += 1;
                }
                mat[i][j] = 'X';
            }
        }
    }
    return loop;
}

void main() {
    string content = readText("input.txt");
    char[][] mat;
    int x, y;
    AliasSeq!(mat,x,y) = parseMat(strip(content));
    
    int a = walk(mat,x,y);
    int b = walkWithObstacles(mat,x,y);

    // printMat(mat);
    writeln("A: ",a);
    writeln("B: ",b);
}
