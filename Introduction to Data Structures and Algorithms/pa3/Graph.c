/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa3
 * Graph.c
 * Implementation file for Graph ADT
 * Programming Assignment: PA3
 *********************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include "Graph.h"
#include "List.h"


typedef struct GraphObj {
    List *arrayList;
    int *colors;
    int *parents;
    int *disctime;
    int *fintime;
    int orderofgraph; //stores number of vertices
    int numofedge; //stores number of edges
    int DFSbool;

} GraphObj;

enum state {meh, white, gray, black}color;

// private helper function(s)
void sortList(Graph G, List L, int vert);

void visit(Graph G, int vert, int* timer, List L);

/*** Constructors-Destructors ***/
Graph newGraph(int n) { //returns a Graph pointing to a newly created GraphObj representing a graph having n vertices and no edges
   Graph G = malloc(sizeof(GraphObj));
    if (G != NULL) {
        G->arrayList = malloc(sizeof(List*) * (n + 1));
        G->colors = malloc(sizeof(int) * (n + 1));
        G->parents = malloc(sizeof(int) * (n + 1));
        G->disctime = malloc(sizeof(int) * (n + 1));
        G->fintime = malloc(sizeof(int) * (n + 1));
        G->orderofgraph = n; //getOrder()
        G->numofedge = 0; //getSize()
        G->DFSbool = 0;
        for (int x = 1; x < n + 1; x++) {
        
                G->arrayList[x] = newList();
                G->colors[x] = white;
                G->parents[x] = NIL;
            
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
    free((*pG)->disctime);
    free((*pG)->fintime);
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


int getParent(Graph G, int u) { //returns the parent of vertex u in the DFS() or NIL
    if (G->DFSbool != 0 && ((1 <= u) && (u <= getOrder(G))))
    {
        return G->parents[u];
    }
    else
    {
        return NIL;
    }
}


int getDiscover(Graph G, int u) {
    if (G->DFSbool != 0 && ((1 <= u) && (u <= getOrder(G)))) {
        return G->disctime[u];
    }
    else
    {
        return UNDEF;
    }
}

int getFinish(Graph G, int u) {
    if (G->DFSbool != 0 && ((1 <= u) && (u <= getOrder(G)))) {
        return G->fintime[u];
    }
    else
    {
        return UNDEF;
    }
}
/*** Manipulation procedures ***/

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
    G->DFSbool = 1;
    for (int i = 1; i < getOrder(G) + 1; i++) {
        G->colors[i] = white;
        G->parents[i] = NIL;
    }

    G->colors[s] = gray;
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
                G->parents[currentvec] = i; //v.pi = u in pseudo
                append(temp, currentvec);
            }
            moveNext(G->arrayList[i]);
        }
        G->colors[i] = black;
    }
    freeList(&temp);


}
//First it defines the order in which vertices are to be processed in the main loop (5-7) of DFS
void DFS(Graph G, List S) {
    if (length(S) == getOrder(G)) {
        G->DFSbool = 1;
        List temp = newList();
        for (int i = 1; i < getOrder(G) + 1; i++) {
            G->colors[i] = white;
            G->parents[i] = NIL;
        }
        int time = 0;
        moveFront(S);
        for (int i = 0; i < length(S); i++) {
            if (G->colors[get(S)] == white) {
                visit(G, get(S), &time, temp);
            }
            moveNext(S);
        }
        clear(S);
        moveFront(temp);
        for (int i = 0; i < length(temp); i++) {
            append(S, get(temp));
            moveNext(temp);
        }
        freeList(&temp);
    }
    
}

void visit(Graph G, int vert, int *timer, List L) {
    *timer += 1;
    G->disctime[vert] = *timer;
    G->colors[vert] = gray;
    moveFront(G->arrayList[vert]);
    for (int i = 0; i < length(G->arrayList[vert]); i++) {
        int y = get(G->arrayList[vert]);
        if (G->colors[y] == white) {
            G->parents[y] = vert;
            visit(G, y, timer, L);
        }
        moveNext(G->arrayList[vert]);
    }
    G->colors[vert] = black;
    *timer += 1;
    G->fintime[vert] = *timer;
    prepend(L, vert);
}

/*** Other operations ***/ 
void printGraph(FILE* out, Graph G) { //prints the adjacency list representation of G to the file pointed to by out
    for (int x = 1; x < getOrder(G) + 1; x++) {
        fprintf(out, "%d: ", x);
        printList(out, G->arrayList[x]);
    }

}

Graph copyGraph(Graph G) {
    Graph temp = newGraph(getOrder(G));
    for (int x = 1; x < getOrder(G) + 1; x++) {
        temp->arrayList[x] = copyList(G->arrayList[x]);
        temp->disctime[x] = G->disctime[x];
        temp->fintime[x] = G->disctime[x];
        temp->parents[x] = getParent(G, x);
    }
    temp->numofedge = getSize(G);
    temp->orderofgraph = getOrder(G);
    temp->DFSbool = G->DFSbool;
    return temp;
}

Graph transpose(Graph G) {
    Graph temp = newGraph(getOrder(G));
    for (int i = 1; i < getOrder(G) + 1; i++) {
        moveFront(G->arrayList[i]);
        for (int j = 0; j < length(G->arrayList[i]); j++) {
            addArc(temp, get(G->arrayList[i]), i);
            moveNext(G->arrayList[i]);
        }
    }
    return temp;
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