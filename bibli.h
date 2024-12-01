#ifndef BIBLI_H
#define BIBLI_H

#include <stdio.h>
#include <stdli.h>

typedef struct _tree{
  int id;
  struct _tree* pLeft;
  struct _tree* pRight;
  long int capacity;
  long int consumption;
  int balance;
}Tree;

typedef Tree* pTree;

int max(int a, int b);
int min(int a, int b);
int max(int a, int b);
pTree createTree(int id,long int capacity, long int consumption);
pTree leftRotation(pTree pRoot);
pTree rightRotation(pTree pRoot);
pTree doubleLeftRotation(pTree pRoot);
pTree doubleRightRotation(pTree pRoot);
pTree balancingTree(pTree pRoot);
pTree insertTree(pTree pRoot, pTree pNew, int* h);
void infix(pTree pRoot);
