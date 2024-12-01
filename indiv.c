#include <stdio.h>
#include <stdlib.h>

typedef struct _tree{
  int id;
  struct _tree* pLeft;
  struct _tree* pRight;
  long int capacity;
  long int consumption;
  int balance;
}Tree;

int max(int a,int b){
  if (a>b){
    return a;
  }
  else{
    return b;
  }
}

int min(int a,int b){
  if (a<b){
    return a;
  }
  else{
    return b;
  }
}

typedef Tree* pTree;

pTree createTree(int id,long int capacity, long int consumption){
  pTree pNew=malloc(sizeof(Tree));
  if (pNew==NULL){
    exit(1);
  }
  pNew->id=id;
  pNew->pLeft=NULL;
  pNew->pRight=NULL;
  pNew->capacity=capacity;
  pNew->consumption=consumption;
  pNew->balance=0;
  return pNew;
}

pTree leftRotation(pTree pRoot){
  if (pRoot==NULL){
    exit(3);
  }
  int b_r,b_p;
  pTree pPivot=pRoot->pRight;
  pRoot->pRight=pPivot->pLeft;
  pPivot->pLeft=pRoot;
  b_r=pRoot->balance;
  b_p=pPivot->balance;
  pRoot->balance=b_r-max(b_p,0)-1;
  pPivot->balance=min(b_r-2,min(b_r+b_p-2,b_p-1));
  pRoot=pPivot;
  return pRoot;
}

pTree rightRotation(pTree pRoot){
  if (pRoot==NULL){
    exit(4);
  }
  int b_r,b_p;
  pTree pPivot=pRoot->pLeft;
  pRoot->pLeft=pPivot->pRight;
  pPivot->pRight=pRoot;
  b_r=pRoot->balance;
  b_p=pPivot->balance;
  pRoot->balance=b_r-max(b_p,0)+1;
  pPivot->balance=min(b_r+2,min(b_r+b_p+2,b_p+1));
  pRoot=pPivot;
  return pRoot;
}

pTree doubleLeftRotation(pTree pRoot){
  if (pRoot==NULL){
    exit(5);
  }
  pRoot->pRight=rightRotation(pRoot->pRight);
  return leftRotation(pRoot);
}

pTree doubleRightRotation(pTree pRoot){
  if (pRoot==NULL){
    exit(6);
  }
  pRoot->pLeft=leftRotation(pRoot->pLeft);
  return rightRotation(pRoot);
}

pTree balancingTree(pTree pRoot){
  if (pRoot->balance>=2){
    if (pRoot->pRight->balance>=0){
      return leftRotation(pRoot);
    }
    else{
      return doubleLeftRotation(pRoot);
    }
  }
  else if (pRoot->balance <=-2){
    if (pRoot->pLeft->balance<=0){
      return rightRotation(pRoot);
    }
    else{
      return doubleLeftRotation(pRoot);
    }
  }
  return pRoot;
}


pTree insertTree(pTree pRoot, pTree pNew, int* h){
  if (pNew==NULL){
    exit(2);
  }
  else if (pRoot==NULL){
    *h=1;
    return pNew;
  }
  else if (pRoot->id==pNew->id){
    pRoot->capacity+=pNew->capacity;
    pRoot->consumption+=pNew->consumption;
    *h=0;
    return pRoot;
  }
  else if(pNew->id<pRoot->id){
    pRoot->pLeft=insertTree(pRoot->pLeft,pNew,h);
    *h=-*h;
  }
  else if(pNew->id>pRoot->id){
    pRoot->pRight=insertTree(pRoot->pRight,pNew,h);
  }
  else{
    *h=0;
    return pRoot;
  }
  if (*h != 0){
    pRoot->balance=pRoot->balance+ *h;
    pRoot=balancingTree(pRoot);
    if (pRoot->balance==0){
      *h=0;
    }
    else{
      *h=1;
    }
  }
  return pRoot;
}

void infix(pTree pRoot){
  if (pRoot==NULL){
    return;
  }
  infix(pRoot->pLeft);
  printf("%d : %li : %li\n",pRoot->id, pRoot->capacity, pRoot->consumption);
  infix(pRoot->pRight);
}


int main() {
    pTree pRoot = NULL;
    int id,son,c,h=0;
    long int capacity,consumption; 

    while (scanf("%d;%d;%d;%li;%li", &id, &son, &c, &capacity, &consumption) == 5) {
        if (id!=0 && son==0){
          pTree pNew = createTree(id,capacity,consumption);
          pRoot = insertTree(pRoot, pNew, &h);
        }
    }
    infix(pRoot);

    return 0;
}

