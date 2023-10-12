/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa7
 * Dictionary.c
 * Implementation file for Dictionary RBT ADT
 * Programming Assignment: PA7
 *********************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include"Dictionary.h"

 //helper functions
enum col{RED, BLACK};
  // private NodeObj type
typedef struct NodeObj {
    VAL_TYPE data;
    KEY_TYPE key;
    struct NodeObj* parent;
    struct NodeObj* left;
    struct NodeObj* right;
    enum col color;
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
    if (N != NULL) {
        N->data = data;
        N->key = key;
        N->left = NULL;
        N->right = NULL;
        N->parent = NULL;
        N->color = BLACK;
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

Node retrieveNode(Dictionary D, Node N, KEY_TYPE k);

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
        Node nullnode = newNode(NULL, NULL);
        D->rootnode = nullnode;
        D->cursornode = nullnode;
        D->nilnode = nullnode;
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
    if (u->parent == D->nilnode) {
        D->rootnode = v;
    }
    else if (u == u->parent->left) {
        u->parent->left = v;
    }
    else {
        u->parent->right = v;
    }
   v->parent = u->parent;
}

Node TreeMinimum(Dictionary D, Node x) {
     while (x->left != D->nilnode) {
     x = x->left;
     }
     return x;
}

Node getNode(Dictionary D, KEY_TYPE k) {
    return retrieveNode(D, D->rootnode, k);
}

Node retrieveNode(Dictionary D, Node N, KEY_TYPE k) {
    if (N != D->nilnode) {
        if (KEY_CMP(k, N->key) == 0) {
            return N;
        }
        else if (KEY_CMP(k, N->key) < 0) {
            return retrieveNode(D, N->left, k);
        }
        else {
            return retrieveNode(D, N->right, k);
        }
    }
    else
    {
        return D->nilnode;
    }
}

VAL_TYPE recurse(Dictionary D, Node N, KEY_TYPE k) {
    if (N != D->nilnode) {
        if (KEY_CMP(k, N->key) == 0) {
            return N->data;
        }
        else if (KEY_CMP(k, N->key) < 0) {
            return recurse(D, N->left, k);
        }
        else {
            return recurse(D, N->right, k);
        }
    }
    else
    {
        return VAL_UNDEF;
    }
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
    test = recurse(D, D->rootnode, k);
    return test;
}


// Manipulation procedures ----------------------------------------------------
void LeftRotate(Dictionary D, Node z) {
    Node y = z->right;

    z->right = y->left;
    if (y->left != D->nilnode) {
        y->left->parent = z;
    }

    y->parent = z->parent;
    if (z->parent == D->nilnode) {
        D->rootnode = y;
    }
    else if (z == z->parent->left) {
        z->parent->left = y;
    }
    else {
        z->parent->right = y;
    }

    y->left = z;
    z->parent = y;

}

void RightRotate(Dictionary D, Node z) {
    Node y = z->left;

    z->left = y->right;
    if (y->right != D->nilnode) {
        y->right->parent = z;
    }

    y->parent = z->parent;
    if (z->parent == D->nilnode) {
        D->rootnode = y;
    }
    else if (z == z->parent->right) {
        z->parent->right = y;
    }
    else {
        z->parent->left = y;
    }

    y->right = z;
    z->parent = y;
}

void RB_InsertFixUp(Dictionary D, Node z) {
    Node y = D->nilnode;
    while (z->parent->color == RED) {
        if (z->parent == z->parent->parent->left) {
            y = z->parent->parent->right;
            if (y->color == RED) { //case 1
                z->parent->color = BLACK;
                y->color = BLACK;
                z->parent->parent->color = RED;
                z = z->parent->parent;
            }
            else {
                if (z == z->parent->right) { //case 2
                    z = z->parent;
                    LeftRotate(D, z);
                }
                z->parent->color = BLACK; //case 3
                z->parent->parent->color = RED;
                RightRotate(D, z->parent->parent);
            }
        }
        else {
            y = z->parent->parent->left;
            if (y->color == RED) {
                z->parent->color = BLACK;
                y->color = BLACK;
                z->parent->parent->color = RED;
                z = z->parent->parent;
            }
            else {
                if (z == z->parent->left) {
                    z = z->parent;
                    RightRotate(D, z);
                }
                z->parent->color = BLACK;
                z->parent->parent->color = RED;
                LeftRotate(D, z->parent->parent);
            }
        }
    
    } 
    D->rootnode->color = BLACK;
}
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
        Node y = D->nilnode;
        Node x = D->rootnode;
        Node z = newNode(v, k);
        while (x != D->nilnode) {
            y = x;
            if (KEY_CMP(z->key, x->key) < 0) {
                x = x->left;
            }
            else {
                x = x->right;
            }
        }
        z->parent = y;
        if (y == D->nilnode) {
            D->rootnode = z; //D was empty
        }
        else if (KEY_CMP(z->key, y->key) < 0) {
            y->left = z;
        }
        else {
            y->right = z;
        }
        z->left = D->nilnode;
        z->right = D->nilnode;
        z->color = RED;
        D->size++;
        RB_InsertFixUp(D, z);

    }
}

void RB_DeleteFixUp(Dictionary D, Node x) {
    Node w;
    while ((x != D->rootnode) && (x->color == BLACK)) {
        if (x == x->parent->left) {
            w = x->parent->right;
            if (w->color == RED) {
                w->color = BLACK;
                x->parent->color = RED;
                LeftRotate(D, x->parent);
                w = x->parent->right;
            }
            if ((w->left->color == BLACK) && (w->right->color == BLACK)) {
                w->color = RED;
                x = x->parent;
            }
            else {
                if (w->right->color == BLACK) {
                    w->left->color = BLACK;
                    w->color = RED;
                    RightRotate(D, w);
                    w = x->parent->right;
                }
                w->color = x->parent->color;
                x->parent->color = BLACK;
                w->right->color = BLACK;
                LeftRotate(D, x->parent);
                x = D->rootnode;
            }
        }
        else {
            w = x->parent->left;
            if (w->color == RED) {
                w->color = BLACK;
                x->parent->color = RED;
                RightRotate(D, x->parent);
                w = x->parent->left;
            }

            if ((w->right->color == BLACK) && (w->left->color == BLACK)) {
                w->color = RED;
                x = x->parent;
            }
            else {
                if (w->left->color == BLACK) {
                    w->right->color = BLACK;
                    w->color = RED;
                    LeftRotate(D, w);
                    w = x->parent->left;
                }
                w->color = x->parent->color;
                x->parent->color = BLACK;
                w->left->color = BLACK;
                RightRotate(D, x->parent);
                x = D->rootnode;
            }
        }
    }
    x->color = BLACK;
}
// delete()
// Remove the pair whose key is k from Dictionary D.
// Pre: lookup(D,k)!=VAL_UNDEF (i.e. D contains a pair whose key is k.)
void delete(Dictionary D, KEY_TYPE k) {
    if (lookup(D, k) != VAL_UNDEF) {
        Node z = getNode(D, k);
        if (D->cursornode == z) {
            D->cursornode = D->nilnode;
        }
        Node y = z;
        Node x;
        int y_orig = y->color;
        if (z->left == D->nilnode) {
            x = z->right;
            Transplant(D, z, z->right);
        }
        else if (z->right == D->nilnode) {
            x = z->left;
            Transplant(D, z, z->left);
        }
        else {
            y = TreeMinimum(D, z->right);
            y_orig = y->color;
            x = y->right;
            if (y->parent == z) {
                x->parent = y;
            }
            else {
                Transplant(D, y, y->right);
                y->right = z->right;
                y->right->parent = y;
            }
            Transplant(D, z, y);
            y->left = z->left;
            y->left->parent = y;
            y->color = z->color;
        }
        if (y_orig == BLACK) {
            RB_DeleteFixUp(D, x);
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
    D->cursornode = D->nilnode;
    D->reverseforward = 0;
}

// beginForward()
// If D is non-empty, starts a forward iteration over D at the first key 
// (as defined by the order operator KEY_CMP()), then returns the first
// value. If D is empty, returns VAL_UNDEF. 
VAL_TYPE beginForward(Dictionary D) {
    D->cursornode = D->rootnode;
    D->reverseforward = 1;

    if (D->rootnode != D->nilnode) {
        while (D->cursornode->left != D->nilnode) {
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

    if (D->rootnode != D->nilnode) {
        while (D->cursornode->right != D->nilnode) {
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
        if (D->cursornode == D->nilnode) {
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
        if (D->cursornode == D->nilnode) {
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
    if (D->cursornode->right != D->nilnode) {
        Node x = D->cursornode->right;
        while (x->left != D->nilnode) {
            x = x->left;
        }
        D->cursornode = x;
        return D->cursornode->data;
    }
    Node y = D->cursornode->parent;
    while (y != D->nilnode && D->cursornode == y->right) {
        D->cursornode = y;
        y = y->parent;
    }
    D->cursornode = y;
    return D->cursornode->data;
}


// prev()
// If an iteration (forward or reverse) over D has started, and has not
// reached the first pair, moves to the previous key in D (as defined by the 
// order operator KEY_CMP()), and returns the value corresponding to the 
// new key. If an iteration has started, and has reached the first pair,
// ends the iteration and returns VAL_UNDEF. If no iteration is underway, 
// returns VAL_UNDEF. 
VAL_TYPE prev(Dictionary D) {
    if (D->cursornode->left != D->nilnode) {
        Node x = D->cursornode->left;
        while (x->right != D->nilnode) {
            x = x->right;
        }
        D->cursornode = x;
        return D->cursornode->data;
    }
    Node y = D->cursornode->parent;
    while (y != D->nilnode && D->cursornode == y->left) {
        D->cursornode = y;
        y = y->parent;
    }
    D->cursornode = y;
    return D->cursornode->data;
}

// Other operations -----------------------------------------------------------
void InOrderTreeWalk(Dictionary D, FILE* out, Node N) {
    if (N != D->nilnode) {
        InOrderTreeWalk(D, out, N->left);
        fprintf(out, "%s\n", N->key);
        InOrderTreeWalk(D, out, N->right);
    }
}

void PreOrderTreeWalk(Dictionary D, FILE* out, Node N) {
    if (N != D->nilnode) {
        fprintf(out, "%s\n", N->key);
        PreOrderTreeWalk(D, out, N->left);
        PreOrderTreeWalk(D, out, N->right);
    }
}

void PostOrderTreeWalk(Dictionary D, FILE* out, Node N) {
    if (N != D->nilnode) {
        PostOrderTreeWalk(D, out, N->left);
        PostOrderTreeWalk(D, out, N->right);
        fprintf(out, "%s\n", N->key);
    }
}
// printDictionary()
// Prints a text representation of D to the file pointed to by out. Each key-
// value pair is printed on a single line, with the two items separated by a
// single space.  The pairs are printed in the order defined by the operator
// KEY_CMP().
void printDictionary(FILE* out, Dictionary D,const char* ord) {
    if (strcmp(ord, "in") == 0) {
        InOrderTreeWalk(D, out, D->rootnode);
    }
    else if (strcmp(ord, "pre") == 0) {
        PreOrderTreeWalk(D, out, D->rootnode);
    }
    else if (strcmp(ord, "post") == 0) {
        PostOrderTreeWalk(D, out, D->rootnode);
    }
}