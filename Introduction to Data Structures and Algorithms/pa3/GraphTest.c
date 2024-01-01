/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa3
 * GraphTest.c
 * Implementation file for GraphTest
 * Programming Assignment: PA3
 *********************************************************************************/


#include<stdio.h>
#include<stdlib.h>
#include "List.h"
#include <string.h>
#include "Graph.h"
#define MAX_LEN 150


int main()
{ 
    {
        Graph A = newGraph(8);
        List L = newList();
        append(L, 1);
        append(L, 2);
        append(L, 3);
        append(L, 4);
        append(L, 5);
        append(L, 6);
        append(L, 7);
        append(L, 8);

        addArc(A, 1, 2);
        addArc(A, 2, 5);
        addArc(A, 2, 6);
        addArc(A, 4, 1);
        addArc(A, 5, 4);
        addArc(A, 5, 7);
        addArc(A, 6, 5);
        addArc(A, 6, 3);
        addArc(A, 8, 5);
        DFS(A, L);
        for (int i = 1; i < 9; i++) {
            int ah = getParent(A, i);
            printf("%d: %d ", i, ah);
        }


    }
    /*
    {//test case tester :)
        Graph A = newGraph(100);
        List L = newList();
        for (int i = 1; i <= 100; i++)
            if (getParent(A, i) != NIL) return 1;
        addArc(A, 64, 4);
        addArc(A, 64, 3);
        addArc(A, 42, 2);
        addArc(A, 2, 64);
        addArc(A, 4, 2);
        addArc(A, 3, 42);
        for (int i = 1; i <= 100; i++) {
            append(L, i);
        }
        DFS(A, L);
        if (getParent(A, 100) != NIL) return 2;
        if (getParent(A, 2) != NIL) return 3;
        if (getParent(A, 42) != 3) return 4;
        if (getParent(A, 3) != 64) return 5;
        printf("parent: %d", getParent(A, 4));
        

        freeGraph(&A);
        freeList(&L);
    }
    
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
        printGraph(stdout, A);
    }
    
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
        addEdge(A, 5, 2);
        if (getSize(A) != 4) {
            printf("Size != to 4 after addEdge\n");
        }
        freeGraph(&A);


    }
    {//tests getDiscover, getFinish, DFS(), getParent()
        Graph A = newGraph(100);
        List L = newList();
        
        for (int i = 1; i <= 100; i++)
            if (getParent(A, i) != NIL) return 1;
        addArc(A, 64, 4);
        addArc(A, 64, 3);
        addArc(A, 42, 2);
        addArc(A, 2, 64);
        addArc(A, 4, 2);
        addArc(A, 3, 42);
        if (getDiscover(A, 2) != UNDEF) return 2;
        if (getFinish(A, 3) != UNDEF) return 3;

        for (int i = 1; i <= 100; i++) {
            append(L, i);
        }
        DFS(A, L);

        if (getFinish(A, 2) != 12) return 3;


        if (getDiscover(A, 2) != 3) return 4;


    }
    
    {//printGraph() and transpose and copygraph
        Graph A = newGraph(100);
        List L = newList();

        for (int i = 1; i <= 100; i++)
            if (getParent(A, i) != NIL) return 1;
        addArc(A, 64, 4);
        addArc(A, 64, 3);
        addArc(A, 42, 2);
        addArc(A, 2, 64);
        addArc(A, 4, 2);
        addArc(A, 3, 42);
        for (int i = 1; i <= 100; i++) {
            append(L, i);
        }
        DFS(A, L);
        Graph pose = transpose(A);
        printGraph(stdout, pose);
        printGraph(stdout, A);
        Graph copied = copyGraph(A);
        printGraph(stdout, copied);
        free(&copied);
        free(&pose);
        freeGraph(&A);
        freeList(&L);
    }


    */
    return 0;

}
