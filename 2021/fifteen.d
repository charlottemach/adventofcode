import std.file: readText;
import std.stdio;
import std.array: split;
import std.algorithm;
import std.conv;
import std.math.algebraic;


void printMat(int [][] mat){
    foreach (i,line; mat){
        foreach (j,v; line){ write(v,","); }
        writeln();
    }
}

int[][] getMat(string txt){
    string[] lines = txt.split("\n");
    int ln = to!int(lines.length);
    int[][] matrix = new int[][](ln-1,ln-1);
    foreach (i,line ; lines) {
        foreach(j,val; line) {
            matrix[i][j] = cast(int)(val-48);
        }
    }
    return matrix;
}

// Naive impl, only going right + down
int getRiskA(int x, int y, int[][] mat, int[][] risks){
    auto ln = mat.length;
    if (x == ln-1 && y == ln-1){
        risks[x][y] = mat[x][y];
        return risks[x][y];
    } else if (x == ln-1) {
        risks[x][y] = mat[x][y] + getRiskA(x,y+1,mat,risks);
    } else if (y == ln-1) {
        risks[x][y] = mat[x][y] + getRiskA(x+1,y,mat,risks);
    } else if (risks[x][y] == 0) {
         risks[x][y] = mat[x][y] + min(getRiskA(x,y+1,mat,risks), getRiskA(x+1,y,mat,risks));
    }
    return risks[x][y];
}

// iterating through distances, fixing up and left paths
int[][] fix(int[][] mat, int[][] risks){
    for (int it=0;it<4;it++) {
        auto ln = to!int(mat.length);
        for (int x = ln-1; x >= 0; x--) {
            for (int y = ln-1; y >= 0; y--) {
                int cur = risks[x][y];
                int check = 10000000;
                if (x > 0) {
                  check = min(check, risks[x-1][y]);
                } if (x < ln-1) {
                  check = min(check, risks[x+1][y]);
                } if (y > 0) {
                  check = min(check, risks[x][y-1]);
                } if (y < ln-1) {
                  check = min(check, risks[x][y+1]);
                }
                int newmin = mat[x][y] + check;
                if (newmin < cur) { risks[x][y] = newmin; }
            }
        }
    }
    return risks;
}

int[][] unfoldMat(int[][] mat){
    int ln = to!int(mat.length);
    int[][] newm = new int[][](5*ln,5*ln);
    foreach (x,line; mat){
        foreach (y,v; line){
            for (int n = 0; n < 5; n++){
                for (int m = 0; m < 5; m++){
                    auto newval = (v+n+m == 9) ? 9 : (v+n+m) % 9;
                    newm[x + n*ln][y + m*ln] = newval;
                }
            } 
        }
    }
    return newm;
}
 
void main() {
    // Part A:
    int[][] matrix = getMat(readText("fifteen.txt"));
    int[][] risks = new int[][](matrix.length,matrix.length);
    writeln("Part A:");
    getRiskA(0,0,matrix,risks);
    fix(matrix,risks);
    writeln(getRiskA(0,0,matrix,risks) - matrix[0][0]);

    // Part B:
    int[][] matB = unfoldMat(matrix);
    int[][] risksB = new int[][](matB.length,matB.length);
    writeln("Part B:");
    getRiskA(0,0, matB, risksB);
    fix(matB,risksB);
    writeln(getRiskA(0,0, matB, risksB) - matB[0][0]);
}
