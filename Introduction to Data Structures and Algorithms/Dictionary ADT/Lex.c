/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa6
 * Lex.c
 * Implementation file for Dictionary ADT
 * Programming Assignment: PA6
 *********************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include"Dictionary.h"

#include <string.h>

#define MAX_LEN 150

int main(int argc, char* argv[])
{
    if (argc != 3) {
        printf("You used (Less arguments than 2 or more arguments than 2");
        return stderr;
    }
    FILE* fp;
    char string1[MAX_LEN];

    if ((fp = fopen(argv[1], "r")) == NULL) {
        printf("Error opening input file!\n");
        return stderr;
    }

    FILE* fpout = fopen(argv[2], "w");
    int ind = 0;
    while (fgets(string1, MAX_LEN, fp) != NULL) {
        ind++;
    }
    rewind(fp);

    char** strings = malloc(ind * sizeof(char*));
    for (int x = 0; x < ind; x++) {
        strings[x] = malloc(MAX_LEN * sizeof(char));
        fgets(string1, MAX_LEN, fp);
        string1[strcspn(string1, "\n")] = 0;
        strcpy(strings[x], string1);
    }

    Dictionary D = newDictionary(1);

    for (int i = 0; i < ind; i++) {
        insert(D, strings[i], i);
    }
    printDictionary(fpout, D);

    fclose(fp);
    fclose(fpout);
    for (int x = 0; x < ind; x++) {
        free(strings[x]);
    }
    freeDictionary(D);
    free(strings);


}
