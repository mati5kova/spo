#include <stdio.h>

int f(int n){
    if (n == 0) {
        return 1;
    }
    return n * f(n-1);
}

int main(){

    printf("f(5) = %d\n", f(5));

    return 0;
}