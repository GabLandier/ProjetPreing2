#include "bibli.h"

int main() {
  pTree pRoot = NULL;
  int power,id,t,son,c,h=0;
  long int capacity,consumption; 

  while (scanf("%d;%d;%d;%d;%li;%li;%d", &power, &id, &son, &c, &capacity, &consumption, &t) == 7) {
    if (t==1){
      if (id!=0 && son==0){
        pTree pNew = createTree(id,capacity,consumption);
        pRoot = insertTree(pRoot, pNew, &h);
      }
    }
    else if (t==2){
      if (id!=0 && c==0){
        pTree pNew = createTree(id,capacity,consumption);
        pRoot = insertTree(pRoot, pNew, &h);
      }
    }
    else if (t==3){
      if (id!=0 && son==0){
        pTree pNew = createTree(id,capacity,consumption);
        pRoot = insertTree(pRoot, pNew, &h);
      }
    }
    else if (t==4){
      if (id!=0){
        pTree pNew = createTree(id,capacity,consumption);
        pRoot = insertTree(pRoot, pNew, &h);
      }
    }
  }
  infix(pRoot);
  freeAVL(pRoot);
  return 0;
}

