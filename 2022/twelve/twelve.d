import std.file: readText;
import std.stdio;
import std.array: split;
import std.algorithm;
import std.conv;
import std.typecons;

alias Point= Tuple!(int, int);
Point start; Point end;

char[][] mat;
int[][] distMat;
int n; int m;
Point[] todo;

void printMat(char [][] mat){
    foreach (i,line; mat){
        foreach (j,v; line){ write(v,","); }
        writeln();
    }
}
void printMat(int [][] mat){
    foreach (i,line; mat){
        foreach (j,v; line){
            if (v == -1){ 
                write(". ");
            } else {
                write(v," ");
            }
        }
        writeln();
    }
}

void setMat(string txt){
    string[] lines = txt.split("\n");
    n = to!int(lines.length);
    m = to!int(lines[0].length);
    mat = new char[][](n,m);
    distMat = new int[][](n,m);
    foreach (i,line ; lines) {
        foreach(j,val; line) {
            distMat[i][j] = -1;
            mat[i][j] = val; 
            if (val == 'S') {
              start = Point(to!int(i),to!int(j));
              mat[i][j] = 'a';
            }
            else if (val == 'E') {
              end = Point(to!int(i),to!int(j));
              mat[i][j] = 'z';
              distMat[i][j] = 0;
            }
        }
    }
}

void fillDist(int x,int y){
   Point[] dirs = [Point(-1,0),Point(1,0),Point(0,-1),Point(0,1)];
   foreach (i,d; dirs) {
        Point p = Point(x+d[0],y+d[1]);
        if (p[0] < 0 || p[0] >= n-1 || p[1] < 0 || p[1] >= m-1) {
           continue;
        } 
        int cur = to!int(mat[x][y]);
        char nxtVal = mat[x+d[0]][y+d[1]];
        int nxt = to!int(nxtVal);
        if (cur == nxt || cur == nxt + 1 || cur < nxt) {
            int nxtDist = distMat[p[0]][p[1]];
            int fromDist = distMat[x][y] + 1;
            if (nxtDist == -1 || nxtDist > fromDist) {
                distMat[p[0]][p[1]] = fromDist;
                todo = todo ~ [p];
            }
        }
   }
   todo = todo[1..$];
}

void main() {
    setMat(readText("twelve.txt"));
    todo = [end];
    do {
        Point t = todo[0];
        fillDist(t[0],t[1]);
    } while (todo.length > 0);
    writeln("A: ",distMat[start[0]][start[1]]);
    //printMat(distMat);

    int minA = distMat[start[0]][start[1]+1];
    foreach (i,m;mat){
    	foreach(j,v;mat[i]){
            if (v == 'a') {
                if (distMat[i][j] != -1){
                  minA = min(minA,distMat[i][j]);
                }
            }
        }
    }
    writeln("B: ",minA);
}
