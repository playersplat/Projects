/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa2
 * FindPath.c
 * Implementation file for FindPath
 * Programming Assignment: PA2
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
                printGraph(fpout, mainGraph);
                fprintf(fpout, "\n");
            }
            char* token = strtok(strings[x], " ");
            int vert1 = atoi(token);
            token = strtok(NULL, " ");
            int vert2 = atoi(token);
            addEdge(mainGraph, vert1, vert2);
        }
       else if (readorwrite == 1) {
            if (strcmp(strings[x], "0 0\n") == 0 || strcmp(strings[x], "0 0") == 0) {
                readorwrite = 2;
                
            }
            if (readorwrite == 1) {
                char* token = strtok(strings[x], " ");
                int sourcevert = atoi(token);
                BFS(mainGraph, sourcevert);
                token = strtok(NULL, " ");
                int pathvert = atoi(token);
                List pathList = newList();
                getPath(pathList, mainGraph, pathvert);
                if (getDist(mainGraph, pathvert) == INF) {
                    fprintf(fpout, "The distance from %d to %d is infinity\n", sourcevert, pathvert);
                    fprintf(fpout, "No %d-%d path exists\n", sourcevert, pathvert);
                }
                else {
                    fprintf(fpout, "The distance from %d to %d is %d\n", sourcevert, pathvert, getDist(mainGraph, pathvert));
                    fprintf(fpout, "A shortest %d-%d path is: ", sourcevert, pathvert);
                    printList(fpout, pathList);
                }
                fprintf(fpout, "\n");
            }


        }
        
    }
    printGraph(stdout, mainGraph);
    for (int x = 0; x < ind; x++) {
        free(strings[x]);
    }
    free(strings);
    freeGraph(&mainGraph);
    fclose(fp);
    fclose(fpout);



}
