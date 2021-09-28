#include <stdio.h>

int main() {
    int x = 0;
    int y =0;
    int z;
    
    while (y < 10) {
        y = y + 1;
        scanf ("%d", &z);
        if(z>x) {
            x = z;
        }
    }
    printf("%d", x);

}