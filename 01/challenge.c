#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int sort_descending(const void* lh, const void* rh);

int main() {
    FILE *file;
    file = fopen("../input/input.txt", "r");

    char line[10];
    int elves[500];
    int current_sum = 0;
    int number_of_elves = 0;
    while (fgets(line, sizeof line, file) != NULL) {
        line[strlen(line) - 1] = '\0';
        if (strcmp(line, "") == 0) {
            elves[number_of_elves++] = current_sum;
            current_sum = 0;
        } else {
            current_sum += atoi(line);
        }
    }

    // store last elf, there's no newline at the end of the file
    elves[number_of_elves++] = current_sum;

    // sort
    qsort(elves, number_of_elves, sizeof(int), sort_descending);

    // part 1
    printf("Elf with most calories carries %d\n", elves[0]);

    // part 2
    printf("Three elves with most calories carry in total %d\n", elves[0] + elves[1] + elves[2]);


    return 0;
}

int sort_descending(const void* lh, const void* rh)
{
    int int_lh = *((int*)lh);
    int int_rh = *((int*)rh);

    if (int_lh == int_rh) return 0;
    else if (int_lh > int_rh) return -1;
    else return 1;
}
