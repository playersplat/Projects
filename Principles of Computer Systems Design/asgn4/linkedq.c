#include <stdio.h>
#include <stdlib.h>
#include "linkedq.h"

void enter(node **front, int x) {
    node *noded = malloc(sizeof(node));
    if (!noded) {
        return;
    }
    noded->x = x;
    noded->behind = *front;
    *front = noded;
    printf("in: %d\n", x);
}

int leave(node **front) {
    node *curr = NULL;
    node *prev = NULL;
    int y = -1;

    if (*front == NULL) {
        return y;
    }
    curr = *front;
    while (curr->behind != NULL) {
        prev = curr;
        curr = curr->behind;
    }
    y = curr->x;
    if (prev) {
        prev->behind = NULL;
    } else {
        *front = NULL;
    }
    printf("out: %d\n", y);
    //free(prev);
    free(curr);
    return y;
}

void free_node(node **front) {
    node *curr = NULL;
    node *prev = NULL;

    curr = *front;
    while (curr != NULL) {
        prev = curr->behind;
        free(curr);
        curr = prev;
    }
}
