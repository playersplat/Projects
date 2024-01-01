/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa2
 * List.c
 * Implementation file for List ADT
 * Programming Assignment: PA2
 *********************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "List.h"
// private helper function(s) ;)
int isEmpty(List L);

// structs --------------------------------------------------------------------

// private NodeObj type
typedef struct NodeObj {
    int data;
    struct NodeObj *next;
    struct NodeObj *prev;
} NodeObj;

// private Node type
typedef NodeObj *Node;

// private ListObj type
typedef struct ListObj {
    Node front;
    Node back;
    Node cursor;
    int cursorindex;
    int length;
} ListObj;

// Constructors-Destructors ---------------------------------------------------

// newNode()
// Returns reference to new Node object. Initializes next and data fields.
Node newNode(int data) {
    Node N = malloc(sizeof(NodeObj));
    if (N != NULL) {
        N->data = data;
        N->next = NULL;
        N->prev = NULL;
    }
    return (N);
}

// freeNode()
// Frees heap memory pointed to by *pN, sets *pN to NULL.
void freeNode(Node *pN) {
    if (pN != NULL && *pN != NULL) {
        free(*pN);
        *pN = NULL;
    }
}

// newList()
// Returns reference to new empty List object.
List newList() {
    List L;
    L = malloc(sizeof(ListObj));
    if (L != NULL) {
        L->front = L->back = L->cursor = NULL;
        L->length = 0;
        L->cursorindex = -1;
    }
    return (L);
}

// freeList()
// Frees all heap memory associated with List *pL, and sets *pL to NULL.
void freeList(List *pL) {
    if (pL != NULL && *pL != NULL) {
        while (!isEmpty(*pL)) {
            deleteBack(*pL);
        }
        free(*pL);
        *pL = NULL;
    }
}

// Access functions -----------------------------------------------------------

// length()
// Returns the length of L.
int length(List L) {
    if (L == NULL) {
        printf("List Error: calling getLength() on NULL List reference\n");
        exit(EXIT_FAILURE);
    }
    return (L->length);
}

// index()
// returns index of cursor element if defined, -1 otherwise.
int l_index(List L) {
    return (L->cursorindex);
}

// Front()
// Returns the value at the front of L.
// Pre: !isEmpty(L)
int front(List L) {
    if (L == NULL) {
        printf("List Error: calling getFront() on NULL List reference\n");
        exit(EXIT_FAILURE);
    }
    if (isEmpty(L)) {
        return -1;
    }
    return (L->front->data);
}

// back()
// Returns the value at the back of L.
// Pre: !isEmpty(L)
int back(List L) {
    if (L == NULL) {
        printf("List Error: calling back() on NULL List reference\n");
        exit(EXIT_FAILURE);
    }
    if (isEmpty(L)) {
        printf("List Error: calling back() on an empty List\n");
        exit(EXIT_FAILURE);
    }
    return (L->back->data);
}

// get()
// Returns cursor element of L. Pre: length()>0, index()>=0
int get(List L) {
    if (L->length > 0 && L->cursorindex >= 0) {
        return (L->cursor->data);
    } else {
        printf("List Error: calling get() on an empty List\n");
        return -1;
    }
}

// equals()
// Returns true (1) iff Lists A and B are in the same
// state, and returns false (0) otherwise
int equals(List A, List B) {
    if (length(A) != length(B)) {
        return 0;
    }
    moveFront(A);
    moveFront(B);
    for (int x = 0; x < length(A); x++) {
        if (get(A) != get(B)) {
            return 0;
        }
        moveNext(A);
        moveNext(B);
    }
    return 1;
}
// isEmpty()
// Returns true (1) if L is empty, otherwise returns false (0)
int isEmpty(List L) {
    if (L == NULL) {
        printf("List Error: calling isEmpty() on NULL List reference\n");
        exit(EXIT_FAILURE);
    }
    if (L->length == 0) {
        return 1;
    } else {
        return 0;
    }
}

// Manipulation procedures ----------------------------------------------------

// Resets L to its original empty state.
void clear(List L) {
    while (!isEmpty(L)) {
        deleteBack(L);
    }
}
//Overwrites the cursor element's data with x.
//Pre: Length()>0, index()>=0
void set(List L, int x) {
    if (L->length > 0 && L->cursorindex >= 0) {
        L->cursor->data = x;
    }
}

//If L is non-empty, sets cursor under the front element, otherwise does nothing
void moveFront(List L) {
    if (L->length > 0) {
        L->cursor = L->front;
        L->cursorindex = 0;
    }
}

//If L is nonempty, sets cursor under the back element, otherwise does nothing
void moveBack(List L) {
    if (L->length > 0) {
        L->cursor = L->back;
        L->cursorindex = length(L) - 1;
    }
}

//If cursor if defined and not at front, move cursor one
//step toward the front of L; if cursor is defined and at
//front, cursor becomes undefined; if cursor is undefined
//do nothing
void movePrev(List L) {
    if (L->cursor != NULL) {
        if (L->cursor == L->front) {
            L->cursor = NULL;
            L->cursorindex = -1;
        } else {
            L->cursor = L->cursor->prev;
            L->cursorindex -= 1;
        }
    }
}

//If cursor is defined and not at back, move cursor one
//step toward the back of L; if cursor is defined and at
//back, cursor becomes undefined; if cursor is undefined
//do nothing
void moveNext(List L) {
    if (L->cursor != NULL) {
        if (L->cursor == L->back) {
            L->cursor = NULL;
            L->cursorindex = -1;
        } else {
            L->cursor = L->cursor->next;
            L->cursorindex += 1;
        }
    }
}

//Insert new element into L. If L is non-empty,
//insertion takes place before front element.
void prepend(List L, int x) {
    Node N = newNode(x);
    if (isEmpty(L)) {
        L->front = L->back = N;
    } else {
        L->front->prev = N;
        N->next = L->front;
        L->front = N;
    }
    if (L->cursorindex != -1) {
        L->cursorindex++;
    }

    L->length += 1;
}

//Insert new element into L. If L is non-empty,
//insertion takes place after back element.
void append(List L, int x) {
    Node N = newNode(x);
    if (isEmpty(L)) {
        L->front = L->back = N;
    } else {
        L->back->next = N;
        N->prev = L->back;
        L->back = N;
    }
    L->length += 1;
}

//Insert new elemnt before cursor
//Pre: length()>0, index()>=0
void insertBefore(List L, int x) {
    if (L->length > 0 && L->cursorindex >= 0) {
        Node N = newNode(x);
        //if cursor is on the front
        if (L->cursor == L->front) {
            N->next = L->front;
            L->front = N;
            L->cursor->prev = N;
            L->cursorindex += 1;
            L->length += 1;
        }
        //if cursor is not on the front
        else {
            N->prev = L->cursor->prev;
            N->next = L->cursor;
            L->cursor->prev = N;
            N->prev->next = N;
            L->cursorindex += 1;
            L->length += 1;
        }
    }
}

//Insert new element after cursor
//Pre: length()>0, index()>= 0
void insertAfter(List L, int x) {
    if (L->length > 0 && L->cursorindex >= 0) {
        Node N = newNode(x);
        //if cursor is not connected to another node
        if (L->cursor == L->back) {
            N->next = NULL;
            N->prev = L->cursor;
            L->cursor->next = N;
            L->back = N;
        }
        //cursor is connected to another node
        else {
            N->next = L->cursor->next;
            N->next->prev = N;
            L->cursor->next = N;
            N->prev = L->cursor;
        }
        L->length += 1;
    }
}

//Delete the front element. Pre: length()>0
void deleteFront(List L) {
    if (L->length > 0) {
        Node N = NULL;
        N = L->front;
        if (length(L) > 1) {
            L->front = L->front->next;

        } else {
            L->front = L->back = NULL;
        }

        if (L->cursorindex == 0) {
            L->cursorindex = -1;
            L->cursor = NULL;
        } else {
            L->cursorindex--;
        }
        L->length--;
        freeNode(&N);
    }
}

//Delete the back element. Pre: length()>0
void deleteBack(List L) {
    if (L->length > 0) {
        Node N = NULL;
        N = L->back;
        if (length(L) > 1) {
            L->back = L->back->prev;

        } else {
            L->back = L->front = NULL;
        }
        if (L->cursorindex == length(L) - 1) {
            L->cursorindex = -1;
            L->cursor = NULL;
        }
        L->length--;
        freeNode(&N);
    }
}

//Delete cursor element, making cursor undefined
//Pre: length()>0, index()>=0
void delete (List L) {
    if (L->length > 0 && L->cursorindex >= 0) {
        Node N = NULL;
        N = L->cursor;
        //cursor is on the back
        if (L->cursor == L->back) {
            deleteBack(L);
        } else if (L->cursor == L->front) {
            deleteFront(L);
        } else {
            L->cursor->prev->next = L->cursor->next;
            L->cursor->next->prev = L->cursor->prev;
            L->length--;
            freeNode(&N);
            L->cursorindex = -1;
            L->cursor = NULL;
        }
    }
}

// Other Functions ------------------------------------------------------------

// printList()
// Prints a string representation of L consisting of a space separated list
// of ints to stdout.
void printList(FILE *out, List L) {

    Node N = NULL;

    if (L == NULL) {
        printf("List Error: calling printList() on NULL List reference\n");
        exit(EXIT_FAILURE);
    }
    if (!isEmpty(L)) {
        N = L->front;
        for (int x = 0; x < length(L); x++) {
            fprintf(out, "%d ", N->data);
            N = N->next;
        }
    }
    fprintf(out, "\n");
}

//Returns a new List representing the same integer
//sequence as L. The cursor in the new list is undefined,
//regardless of the state of the cursor in L. The state
//of L is unchanged.
List copyList(List L) {
    List copy = newList();
    Node N = L->cursor;
    int index = L->cursorindex;
    moveFront(L);
    for (int x = 0; x < length(L); x++) {
        int i = get(L);
        moveNext(L);
        append(copy, i);
    }
    L->cursor = N;
    L->cursorindex = index;
    return copy;
}
