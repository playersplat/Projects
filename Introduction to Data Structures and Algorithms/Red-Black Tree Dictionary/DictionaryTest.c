/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa7
 * DictionaryTest.c
 * Tester file for Dictionary RBT ADT
 * Programming Assignment: PA7
 *********************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include"Dictionary.h"

int main() {
	Dictionary A = newDictionary(0);
    int* pI = calloc(10, sizeof(int));
    for (int i = 0; i < 10; i++) {
        pI[i] = i + 10;
    }
    insert(A, "m", &pI[0]);
    insert(A, "n", &pI[1]);
    insert(A, "o", &pI[2]);
    insert(A, "p", &pI[3]);
    insert(A, "q", &pI[4]);
    insert(A, "f", &pI[5]);
    insert(A, "e", &pI[6]);
    beginForward(A);
    next(A);
    next(A);
    if (strcmp(currentKey(A), "m") != 0 || *currentVal(A) != pI[0]) return 1;
    next(A);
    next(A);
    if (strcmp(currentKey(A), "o") != 0 || *currentVal(A) != pI[2]) return 2;
    next(A);
    next(A);
    next(A);
    if (currentKey(A) != KEY_UNDEF || currentVal(A) != VAL_UNDEF) return 3;
    beginReverse(A);
    prev(A);
    printDictionary(stdout, A, "pre");
    delete(A, "f");
    delete(A, "q");
    printDictionary(stdout, A, "pre");
    return 0;
    return 0;
}