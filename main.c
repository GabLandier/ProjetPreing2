#include <stdio.h>

typedef struct _tree{
  int id;
  struct _tree* pLeft;
  struct _tree* pRight;
  int balance;
}Tree;

typedef Tree* pTree;

pTree createTree(int id){
  pTree pNew=malloc(sizeof(Tree));
  if (pNew==NULL){
    exit(1);
  }
  pNew->pLeft=NULL;
}

int main(){
    return 0;
}
