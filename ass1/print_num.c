#include <stdio.h>

int main(){

    int digit = 8013670;
    int div = 1000000; // 1 mio
    bool started = false;

    while (div > 0) {
        int current_digit = digit / div;

        if (current_digit != 0 || started || div == 1) {
            started = true; 
            int k = current_digit + '0';
            printf("k=%c; digit/%d=%d\n", k, div, current_digit);
        }

        digit = digit % div;
        div /= 10;
    }

    return 0;
}