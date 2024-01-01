/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa3
 * Graph.h
 * Implementation file for Graph ADT
 * Programming Assignment: PA3
 *********************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include "List.h"

#define UNDEF -1
#define NIL  0

typedef struct GraphObj* Graph;

/*** Constructors-Destructors ***/
Graph newGraph(int n); //return a reference to a new graph object containing n vertices and no edges

void freeGraph(Graph* pG); //frees all heap memory associated with a graph and sets its Graph argument to NULL

/*** Access functions ***/
int getSize(Graph G); //returns the size of G

int getOrder(Graph G); //returns the number of vertices in G

int getParent(Graph G, int u); //returns parent o

int getDiscover(Graph G, int u);

int getFinish(Graph G, int u);
/*** Manipulation procedures ***/

void addEdge(Graph G, int u, int v);

void addArc(Graph G, int u, int v);

void DFS(Graph G, List S);


/*** Other operations ***/
void printGraph(FILE* out, Graph G);

Graph transpose(Graph G);

Graph copyGraph(Graph G);
