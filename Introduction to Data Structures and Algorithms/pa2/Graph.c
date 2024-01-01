/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa1
 * Graph.c
 * Implementation file for Graph ADT
 * Programming Assignment: PA2
 *********************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include "Graph.h"
#include "List.h"


typedef struct GraphObj {
    List *arrayList;
    int *colors;
    int *parents;
    int *dist;
    int orderofgraph; //stores number of vertices
    int numofedge; //stores number of edges
    int BFSbool;
    int sourceVertex;

} GraphObj;

enum state {meh, white, gray, black}color;

// private helper function(s)
void sortList(Graph G, List L, int vert);

/*** Constructors-Destructors ***/
Graph newGraph(int n) { //returns a Graph pointing to a newly created GraphObj representing a graph having n vertices and no edges
   Graph G = malloc(sizeof(GraphObj));
    if (G != NULL) {
        G->arrayList = malloc(sizeof(List*) * (n + 1));
        G->colors = malloc(sizeof(int) * (n + 1));
        G->parents = malloc(sizeof(int) * (n + 1));
        G->dist = malloc(sizeof(int) * (n + 1));
        G->orderofgraph = n; //getOrder()
        G->numofedge = 0; //getSize()
        G->sourceVertex = NIL;
        G->BFSbool = 0;
        for (int x = 1; x < n + 1; x++) {
        
                G->arrayList[x] = newList();
                G->colors[x] = white;
                G->parents[x] = NIL;
                G->dist[x] = INF;
            
        }
    }

    return G;
}

void freeGraph(Graph* pG) { //frees all dynamic memory associated with the Graph *pG, then sets the handle *pG to NULL

    for (int x = 1; x < getOrder(*pG) + 1; x++)
    {
        if ((*pG)->arrayList[x]) {
            freeList(&(*pG)->arrayList[x]);
        }
        
    }
    free((*pG)->arrayList);
    free((*pG)->colors);
    free((*pG)->parents);
    free((*pG)->dist);
    free(*pG);
    *pG = NULL;
    
}

/*** Access functions ***/
int getOrder(Graph G) {  //returning corresponding field values 
    return G->orderofgraph;
}

int getSize(Graph G) { //returns size of Graph
    return G->numofedge;
}

int getSource(Graph G) //returns the source vertex most recently used in functions BFS() or NIL if BFS() has not yet been called
{
    if (G->BFSbool != 0)
    {
        return G->sourceVertex;
    }
    else
    {
        return NIL;
    }
}
int getParent(Graph G, int u) { //returns the parent of vertex u in the Breadth-First tree created by BFS() or NIL if BFS() has not yet been called
    if (G->BFSbool != 0)
    {
        return G->parents[u];
    }
    else
    {
        return NIL;
    }
}

int getDist(Graph G, int u) { //returns the distance from the most recent BFS source to vertex u, or INF if BFS() has not yet been called

    if (G->BFSbool != 0)
    {
        return G->dist[u];
    }
    else
    {
        return INF;
    }

}

void getPath(List L, Graph G, int u) { //appends to the List L the vertices of a shortest path G from source to u or appends to L the value NIL if no such path exits
    if (G->sourceVertex == u) {
        append(L, G->sourceVertex);
    }
    else if (G->parents[u] == NIL) {
        append(L, NIL);
    }
    else {
        getPath(L, G, G->parents[u]);
        append(L, u);
    }
    
}
    //preconditions for getParent(), getDist(), and getPath() precon: 1<= u <= getOrder(G)
    //use PrintPath(G,s,x) pseudo code
    
/*** Manipulation procedures ***/
void makeNull(Graph G) { //deletes all edges of G, restoring it to its original (no edge) state. 
    for (int x = 1; x < getOrder(G) + 1; x++) {
        clear(G->arrayList[x]);
    }
    G->numofedge = 0;

    for (int x = 1; x < getOrder(G) + 1; x++) {

        G->arrayList[x] = newList();
        G->colors[x] = white;
        G->parents[x] = NIL;
        G->dist[x] = INF;
        G->sourceVertex = NIL;
        G->BFSbool = 0;
    }
}
void addEdge(Graph G, int u, int v) { //inserts a new edge joining u to v, i.e. u is added to the adjaceny List of v, and v to the adjacency List of u. 
//expected to maintain these lists in sorted order by increasing labels
    if ((1 <= u && u <= getOrder(G)) && (1 <= v && v <= getOrder(G))) {
        addArc(G, u, v);
        addArc(G, v, u);
        G->numofedge--;
    }
}
void addArc(Graph G, int u, int v) { //inserts a new directed edge from u to v, i.e. v is added to the adjacency List of u (but not u to the adjaceny List of v)
//preconditions for addEdge() and addArc() their two int arguments must lie in the range 1 to getOrder(G)
    if ((1 <= u && u <= getOrder(G)) && (1 <= v  && v <= getOrder(G))) {
        sortList(G, G->arrayList[u], v);
        G->numofedge += 1;
    }
}
void BFS(Graph G, int s) { //runs the BFS algorithm on the Graph G with source s, setting the color, distance, parent, and source fields of G accordingly
    G->BFSbool = 1;
    for (int i = 1; i < getOrder(G) + 1; i++) {
        G->colors[i] = white;
        G->dist[i] = INF;
        G->parents[i] = NIL;
    }

    G->colors[s] = gray;
    G->dist[s] = 0;
    G->parents[s] = NIL;

    List temp = newList();
    prepend(temp, s);
    while (length(temp) != 0) {
        moveFront(temp); //Enqueue(Q,s)
        int i = get(temp); //Enqueue(Q,s)

        delete(temp); //Enqueue(Q,s)
        moveFront(G->arrayList[i]);
        for (int x = 0; x < length(G->arrayList[i]); x++) { //loops x amount of times depending on the length of arrayList[]
            int currentvec = get(G->arrayList[i]);
            if (G->colors[currentvec] == white) {
                G->colors[currentvec] = gray;
                G->dist[currentvec] = G->dist[i] + 1;
                G->parents[currentvec] = i; //v.pi = u in pseudo
                append(temp, currentvec);
            }
            moveNext(G->arrayList[i]);
        }
        G->colors[i] = black;
    }
    freeList(&temp);
    G->sourceVertex = s;


}
/*** Other operations ***/ 
void printGraph(FILE* out, Graph G) { //prints the adjacency list representation of G to the file pointed to by out
    for (int x = 1; x < getOrder(G) + 1; x++) {
        fprintf(out, "%d: ", x);
        printList(out, G->arrayList[x]);
    }
    for (int x = 1; x < getOrder(G) + 1; x++) {
        fprintf(out, "%d: ", x);
        fprintf(out, "%d \n", getParent(G, x));
    }

}

void sortList(Graph G, List L, int vert) { //basic "insertion" sort on a list
    if (length(L) > 0)
    {
        moveFront(L);
        int isback = 0;
        int dup = 0;
        while (vert > get(L)) {
            if (length(L) > 1) {
                moveNext(L);
            }
            if (vert == get(L)) {
                dup = 1;
                G->numofedge -= 1;
                break;
            }
            if (get(L) == back(L)) {
                isback = 1;
                break;
            }
        }

        if (isback == 1)
        {
            if (back(L) > vert) {
                insertBefore(L, vert);
            }
            else if (back(L) == vert) {
                G->numofedge -= 1;
            }
            else
            {
                insertAfter(L, vert);
            }
        }
        else if (dup == 0) {
            insertBefore(L, vert);
        }

    }
    else
    {
        prepend(L, vert);
    }
   
}
/**
* other requirements:
* test client called GraphTest.c - tests your Graph operations in isolation
* 
* stuffs
* make a partial sort list thingy
* work on bfs code
* findpath
* finish other functions 
*/