import std.file: readText;
import std.stdio;
import std.array: split;
import std.algorithm;
import std.conv;

void printMat(char [][] mat){
    foreach (i,line; mat){
        foreach (j,v; line){ write(v,","); }
        writeln();
    }
}

char[][] getMat(string txt){
    string[] lines = txt.split("\n");
    int n = to!int(lines.length);
    int m = to!int(lines[0].length);
    char[][] mat = new char[][](n,m);
    foreach (i,line ; lines) {
        foreach(j,val; line) {
            mat[i][j] = val; 
        }
    }
    return mat;
}

bool isMirror(char[][] a, char[][]b) {
    foreach(i,c; a) {
        int j = to!int(a.length-1-i);
        if (c != b[j]) {
            return false; 
        }
    }
    return true;
}

int findReflectionLine(char[][] lines, int not) {
    for (int i = 1; i<lines.length; i++) {
        int size = min(i,lines.length-i);
        char[][] a = lines[i-size..i];
        char[][] b = lines[i..i+size];
        if (isMirror(a,b) && i!= not) {
            return i;
        }
    }
    return 0;
}

// swap = true: lines left of vertical reflection
// swap = false: lines above horizontal reflection
int getLines(char[][] mat, int prev, bool swap) {
    if (swap) {
        char[][] columns;
        for (int i=0;i<mat[0].length;i++) {
            char[] column;
            for (int j=0;j<mat.length;j++) {
                column ~= mat[j][i]; 
            }
            columns ~= column;
        }
        return findReflectionLine(columns, prev);
    }
    return findReflectionLine(mat, prev);
}

int flip(char [][] mat, int prev, bool swap){
    char[][] newMat = mat;
    foreach (i,m;mat){
        foreach(j,c;m) {
           newMat[i][j] = (mat[i][j] == '.')? '#' : '.'; 	 
           int lines = getLines(newMat,prev,swap);
           if (lines != prev && lines != 0) {
               return lines;
           }
           newMat[i][j] = (newMat[i][j] == '.')? '#' : '.'; 	 
        }
    }
    return 0;
}

void main() {
    string[] patterns = readText("input.txt").split("\n\n");
    int sum = 0;
    int sumB = 0;
    foreach (i,p;patterns){
        char[][] mat = getMat(p);
        //printMat(mat);
        
        // invert matrix = columns (true), else rows (false)
        int h = getLines(mat, 0, false);
        int v = getLines(mat, 0, true);
        int h2 = flip(mat, h, false);
        int v2 = flip(mat, v, true);
        sum += (h * 100) + v;
        sumB += (h2 * 100) + v2;
    }
    writeln("A: ",sum);
    writeln("B: ",sumB);
}
