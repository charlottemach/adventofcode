#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_LEN 36

#define MIN_COORD -200
#define MAX_COORD 200
#define MAX_IT 350


char* read_input(char* filename) {
    FILE* fp;
    fp = fopen(filename, "r");
    char* buffer = malloc(MAX_LEN);
    fscanf(fp, "%[^\n]", buffer);
    fclose(fp);
    return buffer;
}

int to_zero(int n) {
    if (n != 0) {
        n = (n > 0) ? n -1 : n + 1;
    }
    return n;
}


int main() {
    char *text = read_input("seventeen.txt");
    printf("%s\n", text);
    // input
    int x0 = 60; int xn = 94; int y0 = -171; int yn = -136;

    int reslist = 0; int resy = 0; int resmax = 0;
    for (int vx = MIN_COORD; vx < MAX_COORD; ++vx){
        for (int vy = MIN_COORD; vy < MAX_COORD; ++vy){
            int x = 0; int y = 0;
            int tmpx = vx; int tmpy = vy;
            int maxy = 0;
            bool valid = false;
            for (int step = 0; step < MAX_IT; ++step){
                if (x >= x0 && x <= xn && y >= y0 && y <= yn) {
                    valid = true;
                    if (vy > resy){
                        resy = vy;
                        resmax = maxy;
                        break;
                    }
                 }
                 x += tmpx; y += tmpy; 
                 tmpx = to_zero(tmpx); tmpy -= 1; 
                 maxy = (y > maxy) ? y : maxy;
                 if ((tmpx == 0 && x > xn) || (tmpy < 0 && y < y0)){
                    break;
                 }
            }
            if (valid) {reslist += 1;}
        }
    }
    printf("Max y: %i\n", resmax);
    printf("Size: %i\n", reslist);
    return 0;
}
