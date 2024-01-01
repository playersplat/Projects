/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa3
 * FindComponents
 * Implementation file for FindComponents
 * Programming Assignment: PA3
 *********************************************************************************/



#include<stdio.h>
#include<stdlib.h>
#include "List.h"
#include "Graph.h"
#include <string.h>

#define MAX_LEN 150

int main(int argc, char* argv[])
{
    if (argc != 3) {
        printf("You used (Less arguments than 2 or more arguments than 2");
        exit(-1);
    }
    FILE* fp;
    char state1[MAX_LEN];

    if ((fp = fopen(argv[1], "r")) == NULL) {
        printf("Error opening input file!\n");
        exit(-1);
    }

    FILE* fpout = fopen(argv[2], "w");
    int ind = 0;
    while (fgets(state1, MAX_LEN, fp) != NULL) {
        ind++;
    }
    rewind(fp);

    char** strings = (char**)malloc(ind * sizeof(char*));
    for (int x = 0; x < ind; x++) {
        strings[x] = (char*)malloc(MAX_LEN * sizeof(char));
        fgets(state1, MAX_LEN, fp);
        strcpy(strings[x], state1);
    }
 
    //reads through the strings array for the first state
    
    int num = atoi(strings[0]);
    Graph mainGraph = newGraph(num);
    int readorwrite = 0;
    for (int x = 1; x < ind; x++) {
        if (readorwrite == 0) {
            if (strcmp(strings[x], "0 0\n") == 0 || strcmp(strings[x], "0 0") == 0) {
                readorwrite = 1;
                fprintf(fpout, "Adjacency list representation of G: \n");
                printGraph(fpout, mainGraph);
                fprintf(fpout, "\n");
            }
            char* token = strtok(strings[x], " ");
            int vert1 = atoi(token);
            token = strtok(NULL, " ");
            int vert2 = atoi(token);
            addArc(mainGraph, vert1, vert2);
        }
        
    }

    List L = newList();
    for (int i = 1; i < getOrder(mainGraph) + 1; i++) {
        append(L, i);
    }
    Graph pose = transpose(mainGraph);
    DFS(mainGraph, L);
    DFS(pose, L);
    int nil = 0;
    moveFront(L);
    List temp = newList();
    for (int i = 0; i < length(L); i++) {
        if (getParent(pose, get(L)) == NIL) {
            prepend(temp, get(L));
            moveFront(temp);
            nil++;
        }
        else {
            insertAfter(temp, get(L));
            moveNext(temp);
        }
        moveNext(L);
    }
    moveFront(temp);
    fprintf(fpout, "G contains %d strongly connected components: ", nil);

    int com = 0;
    for (int i = 0; i < length(L); i++) {
        if (getParent(pose, get(temp)) == NIL) {
            com++;
            fprintf(fpout, "\nComponent %d: ", com);
        }
        fprintf(fpout, "%d ", get(temp));
        moveNext(temp);
    }
    for (int x = 0; x < ind; x++) {
        free(strings[x]);
    }
    freeGraph(&pose);
    freeList(&L);
    freeList(&temp);
    free(strings);
    freeGraph(&mainGraph);
    fclose(fp);
    fclose(fpout);



}
