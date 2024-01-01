/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa6
 * Dictionary.c
 * Implementation file for Dictionary ADT
 * Programming Assignment: PA6
 *********************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include"Dictionary.h"


 //helper functions

  // private NodeObj type
typedef struct NodeObj {
    VAL_TYPE data;
    KEY_TYPE key;
    struct NodeObj* parent;
    struct NodeObj* left;
    struct NodeObj* right;
} NodeObj;

// private Node type
typedef NodeObj* Node;

typedef struct DictionaryObj {
    Node rootnode;
    Node cursornode;
    Node nilnode;
    int unique;
    int size;
    int reverseforward;
} DictionaryObj;

// newNode()
// Returns reference to new Node object. Initializes next and data fields.
Node newNode(VAL_TYPE data, KEY_TYPE key) {
    Node N = malloc(sizeof(NodeObj));
    if (N != KEY_UNDEF) {
        N->data = data;
        N->key = key;
        N->left = KEY_UNDEF;
        N->right = KEY_UNDEF;
        N->parent = KEY_UNDEF;
    }
    return(N);
}

// freeNode()
// Frees heap memory pointed to by *pN, sets *pN to NULL.
void freeNode(Node* pN) {
    if (pN != KEY_UNDEF && *pN != KEY_UNDEF) {
        free(*pN);
        *pN = KEY_UNDEF;
    }
}

Node retrieveNode(Node N, KEY_TYPE k);

// newDictionary()
// Creates a new empty Dictionary. If unique==false (0), then the Dictionary 
// will accept duplicate keys, i.e. distinct pairs with identical keys. If 
// unique==true (1 or any non-zero value), then duplicate keys will not be 
// accepted. In this case, the operation insert(D, k) will enforce the 
// precondition: lookup(D, k)==VAL_UNDEF
Dictionary newDictionary(int unique) {
    Dictionary D;
    D = malloc(sizeof(DictionaryObj));
    if (D != KEY_UNDEF) {
        D->rootnode = D->cursornode = D->nilnode = KEY_UNDEF;
        if (unique == 0) {
            D->unique = 0;
        }
        else
        {
            D->unique = 1;
        }
        D->size = 0;
        D->reverseforward = 0;
    }
    return (D);
}

// freeDictionary()
// Frees heap memory associated with *pD, sets *pD to NULL.
void freeDictionary(Dictionary* pD) {
    if (pD != KEY_UNDEF && *pD != KEY_UNDEF) {
        free(*pD);
        *pD = KEY_UNDEF;
    }
}


void Transplant(Dictionary D, Node u, Node v) {
    if (u->parent == NULL) {
        D->rootnode = v;
    }
    else if (u == u->parent->left) {
        u->parent->left = v;
    }
    else {
        u->parent->right = v;
    }
    if (v != NULL) {
        v->parent = u->parent;
    }
}


Node getNode(Dictionary D, KEY_TYPE k) {
    D->nilnode = retrieveNode(D->rootnode, k);
    return D->nilnode;
}

Node retrieveNode(Node N, KEY_TYPE k) {
    if (N != NULL) {
        if (KEY_CMP(k, N->key) == 0) {
            return N;
        }
        else if (KEY_CMP(k, N->key) < 0) {
            return retrieveNode(N->left, k);
        }
        else {
            return retrieveNode(N->right, k);
        }
    }
    else
    {
        return NULL;
    }
}

VAL_TYPE recurse(Node N, KEY_TYPE k) {
    if (N != NULL) {
        if (KEY_CMP(k, N->key) == 0) {
            return N->data;
        }
        else if (KEY_CMP(k, N->key) < 0) {
            return recurse(N->left, k);
        }
        else {
            return recurse(N->right, k);
        }
    }
    else
    {
        return VAL_UNDEF;
    }
}

Node TreeMinimum(Node x) {
    while (x->left != NULL) {
        x = x->left;
    }
    return x;
}

Node TreeMaximum(Node x) {
    while (x->right != NULL) {
        x = x->right;
    }
    return x;
}

// Access functions -----------------------------------------------------------

// size()
// Returns the number of (key, value) pairs in Dictionary D.
int size(Dictionary D) {
    return D->size;
}

// getUnique()
// Returns true (1) if D requires that all pairs have unique keys. Returns
// false (0) if D accepts distinct pairs with identical keys.
int getUnique(Dictionary D) {
    return D->unique;
}

// lookup()
// If Dictionary D contains a (key, value) pair whose key matches k (i.e. if
// KEY_CMP(key, k)==0), then returns value. If D contains no such pair, then
// returns VAL_UNDEF.
VAL_TYPE lookup(Dictionary D, KEY_TYPE k) {
    VAL_TYPE test = VAL_UNDEF;
    test = recurse(D->rootnode, k);
    return test;
}


// Manipulation procedures ----------------------------------------------------

// insert()
// Insert the pair (k,v) into Dictionary D. 
// If getUnique(D) is false (0), then there are no preconditions.
// If getUnique(D) is true (1), then the precondition lookup(D, k)==VAL_UNDEF
// is enforced. 
void insert(Dictionary D, KEY_TYPE k, VAL_TYPE v) {
    int isUnique = 0;
    if (getUnique(D) == 1) {
        if (lookup(D, k) != VAL_UNDEF) {
            isUnique = 1;
        }
    }
    if (isUnique == 0) {
        //insert algorithmn
        Node y = NULL;
        Node x = D->rootnode;
        while (x != NULL) {
            y = x;
            if (KEY_CMP(k, x->key) < 0) {
                x = x->left;
            }
            else {
                x = x->right;
            }
        }
        Node z = newNode(v, k);
        z->parent = y;
        if (y == NULL) {
            D->rootnode = z; //D was empty
        }
        else if (KEY_CMP(z->key, y->key) < 0) {
            y->left = z;
        }
        else {
            y->right = z;
        }
        freeNode(x);
        D->size++;
    }
}

// delete()
// Remove the pair whose key is k from Dictionary D.
// Pre: lookup(D,k)!=VAL_UNDEF (i.e. D contains a pair whose key is k.)
void delete(Dictionary D, KEY_TYPE k) {
    if (lookup(D, k) != VAL_UNDEF) {
        Node N = getNode(D, k);
        if (D->cursornode == N) {
            D->cursornode = NULL;
        }
        if (N->left == NULL) {
            Transplant(D, N, N->right);
        }
        else if (N->right == NULL) {
            Transplant(D, N, N->left);
        }
        else
        {
            Node y = TreeMinimum(N->right);
            if (y->parent != N) {
                Transplant(D, y, y->right);
                y->right = N->right;
                y->right->parent = y;
            }
            Transplant(D, N, y);
            y->left = N->left;
            y->left->parent = y;
        }
        D->size--;
    }
}



// makeEmpty()
// Reset Dictionary D to the empty state, containing no pairs.
void makeEmpty(Dictionary D) {
    while (D->size > 0) {
        delete(D, D->rootnode->key);
    }
    D->cursornode = NULL;
    D->reverseforward = 0;
}

// beginForward()
// If D is non-empty, starts a forward iteration over D at the first key 
// (as defined by the order operator KEY_CMP()), then returns the first
// value. If D is empty, returns VAL_UNDEF. 
VAL_TYPE beginForward(Dictionary D) {
    D->cursornode = D->rootnode;
    D->reverseforward = 1;

    if (D->rootnode != NULL) {
        while (D->cursornode->left != NULL) {
            D->cursornode = D->cursornode->left;
        }
        return D->cursornode->data;
    }

    D->reverseforward = 0;
    return VAL_UNDEF;
}
//starts at smallest node, can be found us9ing the treeminimum pseudocode
// set cursor
// beginReverse()
// If D is non-empty, starts a reverse iteration over D at the last key 
// (as defined by the order operator KEY_CMP()), then returns the last
// value. If D is empty, returns VAL_UNDEF.
VAL_TYPE beginReverse(Dictionary D) {
    D->cursornode = D->rootnode;
    D->reverseforward = 1;

    if (D->rootnode != NULL) {
        while (D->cursornode->right != NULL) {
            D->cursornode = D->cursornode->right;
        }
        return D->cursornode->data;
    }

    D->reverseforward = 0;
    return VAL_UNDEF;
}
//treemaximum pseudocode
// currentKey()
// If an iteration (forward or reverse) over D has started, returns the 
// the current key. If no iteration is underway, returns KEY_UNDEF.
KEY_TYPE currentKey(Dictionary D) {
    if (D->reverseforward != 0) {
        if (D->cursornode == NULL) {
            return KEY_UNDEF;
        }
        return D->cursornode->key;
    }
        return KEY_UNDEF;
    
}
// currentVal()
// If an iteration (forward or reverse) over D has started, returns the 
// value corresponding to the current key. If no iteration is underway, 
// returns VAL_UNDEF.
VAL_TYPE currentVal(Dictionary D) {
    if (D->reverseforward != 0) {
        if (D->cursornode == NULL) {
            return VAL_UNDEF;
        }
        return D->cursornode->data;
    }
    return VAL_UNDEF;
   
}

// next()
// If an iteration (forward or reverse) over D has started, and has not
// reached the last pair, moves to the next key in D (as defined by the 
// order operator KEY_CMP()), and returns the value corresponding to the 
// new key. If an iteration has started, and has reached the last pair,
// ends the iteration and returns VAL_UNDEF. If no iteration is underway, 
// returns VAL_UNDEF.
VAL_TYPE next(Dictionary D) {
    if (D->cursornode != NULL) {
        D->cursornode = D->cursornode->right;
        if (D->cursornode == NULL) {
            return VAL_UNDEF;
        }
        return D->cursornode->data;
    }
    return VAL_UNDEF;
}


// prev()
// If an iteration (forward or reverse) over D has started, and has not
// reached the first pair, moves to the previous key in D (as defined by the 
// order operator KEY_CMP()), and returns the value corresponding to the 
// new key. If an iteration has started, and has reached the first pair,
// ends the iteration and returns VAL_UNDEF. If no iteration is underway, 
// returns VAL_UNDEF. 
VAL_TYPE prev(Dictionary D) {
    if (D->cursornode != NULL) {
        if (D->cursornode->left != NULL) {
            D->cursornode = D->cursornode->left;
            while (D->cursornode->right != NULL) {
                D->cursornode = D->cursornode->right;
            }
            return D->cursornode->data;
        }
        else {
            D->cursornode = D->cursornode->parent;
            if (D->cursornode == NULL) {
                return VAL_UNDEF;
            }
            return D->cursornode->data;
        }
    }
    return VAL_UNDEF;
}

// Other operations -----------------------------------------------------------
void InOrderTreeWalk(FILE* out, Node N) {
    if (N != NULL) {
        InOrderTreeWalk(out, N->left);
        fprintf(out, "%s\n", N->key);
        InOrderTreeWalk(out, N->right);
    }
}
// printDictionary()
// Prints a text representation of D to the file pointed to by out. Each key-
// value pair is printed on a single line, with the two items separated by a
// single space.  The pairs are printed in the order defined by the operator
// KEY_CMP().
void printDictionary(FILE* out, Dictionary D) {
    InOrderTreeWalk(out, D->rootnode);
}