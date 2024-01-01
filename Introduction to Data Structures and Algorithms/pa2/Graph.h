/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa1
 * Graph.h
 * Implementation file for Graph ADT
 * Programming Assignment: PA2
 *********************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include "List.h"

#define INF -1
#define NIL  0

typedef struct GraphObj* Graph;

/*** Constructors-Destructors ***/
Graph newGraph(int n);

void freeGraph(Graph* pG);

/*** Access functions ***/
int getSize(Graph G);

int getOrder(Graph G);

int getSource(Graph G);

int getParent(Graph G, int u);

int getDist(Graph G, int u);

void getPath(List L, Graph G, int u);

/*** Manipulation procedures ***/
void makeNull(Graph G);

void addEdge(Graph G, int u, int v);

void addArc(Graph G, int u, int v);

void BFS(Graph G, int s);

/*** Other operations ***/
void printGraph(FILE* out, Graph G);
