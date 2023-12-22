#include <fstream>
#include <sstream> 
#include <iostream> 
#include <string>
#include <cstring>
#include <map>

using namespace std;

const int STEPS = 64;
const int N = 131;
const string F = "input.txt";
const int STEPS2 = 26501365;


void printMat(char mat[N][N]) {
    for (int y = 0; y < N; y++) {
        for (int x = 0; x < N; x++) {
            cout << mat[y][x];
        }
        cout << "\n";
    }
    cout << "\n";
}

int cntPlots(char mat[N][N]) {
    int plots = 0;
    for (int y = 0; y < N; y++) {
        for (int x = 0; x < N; x++) {
            if (mat[y][x] == 'O') { plots += 1; }
        }
    }
    return plots;
}

int walk(char mat[N][N], pair<int,int> start, int steps, map<pair<int,int>,int>& m) {
    char cells[N][N];
    memcpy(cells, mat, N*N*sizeof(char));
    mat[start.second][start.first] = 'O';
    for (int k = 0; k < steps; k++) {
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                int sum = 0;
                for (int ii = i - 1; ii <= i + 1; ii++) {
                    for (int jj = j - 1; jj <= j + 1; jj++) {
                        int dist = abs(ii-i) + abs(jj-j);
                        char c = mat[ii][jj];
                        if ((c == 'O') && dist == 1) {
                            sum += 1;
                        }
                    }
                }
                if (mat[i][j] != '#') {
                    if (sum > 0) {
                        cells[i][j] = 'O';

                        int start_dist = abs(start.first - j) + abs(start.second - i);
                        pair<int,int> coord = make_pair(i,j);
                        if (m.count(coord) == 0) {
                            m.insert(make_pair(coord, start_dist));
                        }
                    } else {
                        cells[i][j] = '.';
                    }
                }
            }
        }
        //cout << k;
        //printMat(cells);
        memcpy(mat, cells, N*N*sizeof(char));
    }
    return cntPlots(mat);   
}

// entirely based on https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21
long int oh_god_geometry(map<pair<int,int>,int>& visited) {
    int even_corners = 0; int odd_corners = 0;
    int even = 0; int odd = 0;
    map<pair<int,int>, int>::iterator iter;
    for (iter = visited.begin(); iter != visited.end(); iter++) {
        pair<int,int> coord = iter->first;
        int dist = iter->second;
        if (dist % 2 == 0) {
            even += 1;
            if (dist > 65) { even_corners += 1; }
        } else {
            odd += 1;
            if (dist > 65) { odd_corners += 1; }
        }
    }
    long int n = (STEPS2 - (N/2)) / N;
    long int ogg = ((n+1)*(n+1) * odd) + ((n*n) * even) - ((n+1) * odd_corners) + (n * even_corners);
    return ogg;
}

int main() {

    int x = 0; int y = 0; char c;
    char mat[N][N];
    pair<int,int> start;
    ifstream in(F);

    for (string line; getline(in, line);) {
        for (x = 0; x < line.length(); x++) {
            char c = line[x];
            mat[y][x] = c;
            if (c == 'S') { start = make_pair(x,y); }
        }
        y += 1;
    }
    map<pair<int,int>, int> visited;
    cout << "A: " <<  walk(mat, start, STEPS, visited) << "\n";

    int even = walk(mat, start, N-STEPS, visited);
    cout << "B: " << oh_god_geometry(visited) << "\n";
    return 0;
}
