#ifndef linkedq_h
#define linkedq_h

typedef struct node {
    int x;
    struct node *behind;
} node;

void enter(node **front, int x);

int leave(node **front);

void free_node(node **front);
#endif /* linkedq_h */
