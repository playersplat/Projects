/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa2
 * GraphTest.c
 * Implementation file for GraphTest
 * Programming Assignment: PA2
 *********************************************************************************/


#include<stdio.h>
#include<stdlib.h>
#include "List.h"
#include <string.h>
#include "Graph.h"
#define MAX_LEN 150


void main()
{
    {//tests freeGraph()
        Graph A = newGraph(9);
        addArc(A, 1, 2);
        addArc(A, 4, 1);
        addArc(A, 5, 4);
        addArc(A, 5, 7);
        addArc(A, 8, 5);
        addArc(A, 2, 5);
        addArc(A, 2, 6);
        addArc(A, 6, 3);
        addArc(A, 6, 9);
        BFS(A, 4);
        printGraph(stdout, A);
    }
    /*
    {//tests getOrder()
        Graph A = newGraph(6);
        if (getOrder(A) != 6) {
            printf("Size != to 6\n");
            return 1;
        }
        Graph B = newGraph(7);
        if (getOrder(B) != 7) {
            printf("Size != to 6\n");
            return 2;
        }
        freeGraph(&A);

        freeGraph(&B);

    }
    {//tests addArc() && getSize()
        Graph A = newGraph(6);
        addArc(A, 1, 2);
        addArc(A, 2, 3);
        addArc(A, 3, 4);
        if (getSize(A) != 3) {
            printf("Size != to 3\n");
            return 1;
        }
        BFS(A, 3);
        if (getSize(A) != 3) {
            printf("Size != to 3 after BFS()\n");
        }
        freeGraph(&A);


    }
    {//tests addEdge() && getSize()
        Graph A = newGraph(6);
        addEdge(A, 1, 2);
        addEdge(A, 2, 3);
        addEdge(A, 3, 4);
        if (getSize(A) != 3) {
            printf("Size != to 3\n");
            
        }
        BFS(A, 3);
        addEdge(A, 5, 2);
        if (getSize(A) != 4) {
            printf("Size != to 4 after BFS() and addEdge\n");
        }
        freeGraph(&A);


    }

    {//tests getSource and BFS()
        Graph A = newGraph(6);
        addEdge(A, 1, 2);
        addEdge(A, 2, 3);
        addEdge(A, 3, 4);
        if (getSource(A) != NIL) {
            printf("did not return NIL as BFS() was not called\n");
        }
        BFS(A, 3);
        addEdge(A, 5, 2);
        if (getSource(A) != 3) {
            printf("did not return Source Vertex: 3\n");
        }
        freeGraph(&A);

    }

    {//tests getParent, BFS(), getPath, getDist, printGraph, makeNull
        Graph A = newGraph(6);
        addEdge(A, 3, 2);
        addEdge(A, 4, 5);
        addEdge(A, 5, 1);
        addEdge(A, 2, 1);

        if (getParent(A, 5) != NIL) {
            printf("did not return NIL as BFS() was not called\n");
        }
        BFS(A, 1);
        if (getParent(A, 5) != 1) {
            printf("did not return correct parent vertex: 1\n");
        }
        List L = newList();
        getPath(L, A, 3);
        if (getDist(A, 3) != 2) {
            printf("did not return correct dist: \n");
        }

        printGraph(stdout, A);
        makeNull(A);
        printGraph(stdout, A);
        freeGraph(&A);

    }
    */



    return 0;

}
