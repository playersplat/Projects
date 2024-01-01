/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa1
 * Lex.c
 * Implementation file for Lex
 * Programming Assignment: PA1
 *********************************************************************************/


#include<stdio.h>
#include<stdlib.h>
#include "List.h"
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
        strcpy(strings[x], string1);
    }
    List L = newList();
    prepend(L, 0);
    moveFront(L);

    for (int i = 1; i < ind; i++) {
        moveFront(L);
        if (strcmp(strings[i], strings[get(L)]) < 0) {
            prepend(L, i);
        }
        else {
            while (1) {
                moveNext(L);
                if (index(L) == -1) {
                    append(L, i);
                    break;
                }

                if (strcmp(strings[i], strings[get(L)]) < 0) {
                    insertBefore(L, i);
                    break;
                }
            }
        }



    }
    moveFront(L);
    for (int x = 0; x < ind; x++) {
        fprintf(fpout, "%s", strings[get(L)]);
        moveNext(L);
    }
    fclose(fp);
    fclose(fpout);
    freeList(&L);
    for (int x = 0; x < ind; x++) {
        free(strings[x]);
    }
    free(strings);


}
