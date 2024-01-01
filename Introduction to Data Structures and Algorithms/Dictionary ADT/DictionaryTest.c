/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa6
 * DictionaryTest.c
 * Tester file for Dictionary ADT
 * Programming Assignment: PA6
 *********************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include"Dictionary.h"

int main() {
	Dictionary A = newDictionary(0);
    insert(A, "d", 1);
    insert(A, "b", 5);
    insert(A, "a", 10);
    insert(A, "c", 15);
    insert(A, "f", 20);
    insert(A, "e", 25);
    insert(A, "g", 30);
    beginForward(A);
    delete(A, "a");
    if (currentKey(A) != KEY_UNDEF || currentVal(A) != VAL_UNDEF) return 1;
    beginReverse(A);
    delete(A, "d");
    if (strcmp(currentKey(A), "g") != 0 || currentVal(A) != 30) return 2;
    prev(A);
    printf("%s, %d", currentKey(A), currentVal(A));
    printDictionary(stdout, A);
    makeEmpty(A);
    printDictionary(stdout, A);
    freeDictionary(A);

    return 0;

    return 0;
}