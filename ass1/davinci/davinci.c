#include <stdio.h>

int main() {
    FILE *f = fopen("slika.raw", "rb");
    for (int i = 0; i < 128 * 128; i++) {
        int p = fgetc(f);
        putchar(" .:-=+*#%@"[p * 9 / 255]);
        if (i % 128 == 127) putchar('\n');
    }
    fclose(f);
}