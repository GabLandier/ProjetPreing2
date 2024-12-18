#include "bibli.h"


// Fonction pour retourner le maximum entre deux entiers
int max(int a,int b){
  if (a>b){
    return a;
  }
  else{
    return b;
  }
}

// Fonction pour retourner le minimum entre deux entiers
int min(int a,int b){
  if (a<b){
    return a;
  }
  else{
    return b;
  }
}

/* Fonction pour créer un nouveau nœud dans l'arbre AVL.
Prend en entrée un identifiant, une capacité et une consommation.
 Retourne un pointeur vers le nouveau nœud*/
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

// Fonction pour effectuer une rotation gauche sur un nœud donné.
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

// Fonction pour effectuer une rotation droite sur un nœud donné
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
  pRoot->balance=b_r-min(b_p,0)+1;
  pPivot->balance=max(b_r+2,max(b_r+b_p+2,b_p+1));
  pRoot=pPivot;
  return pRoot;
}

// Fonction pour effectuer une double rotation gauche (droite + gauche)
pTree doubleLeftRotation(pTree pRoot){
  if (pRoot==NULL){
    exit(5);
  }
  pRoot->pRight = rightRotation(pRoot->pRight);
  return leftRotation(pRoot);
}

// Fonction pour effectuer une double rotation droite (gauche + droite)
pTree doubleRightRotation(pTree pRoot){
  if (pRoot==NULL){
    exit(6);
  }
  pRoot->pLeft = leftRotation(pRoot->pLeft);
  return rightRotation(pRoot);
}

// Fonction pour équilibrer un arbre AVL en fonction du facteur d'équilibre
pTree balancingTree(pTree pRoot){
  if (pRoot->balance >= 2){
    if (pRoot->pRight->balance >= 0){
      return leftRotation(pRoot);
    }
    else{
      return doubleLeftRotation(pRoot);
    }
  }
  else if (pRoot->balance <= -2){
    if (pRoot->pLeft->balance <= 0){
      return rightRotation(pRoot);
    }
    else{
      return doubleRightRotation(pRoot);
    }
  }
  return pRoot; 
}

/* Fonction pour insérer un nœud dans un arbre AVL
Met à jour le facteur d'équilibre et rééquilibre si nécessaire */
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
    free(pNew);
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

// Parcours infixe de l'arbre pour afficher les nœuds dans l'ordre croissant
void infix(pTree pRoot){
  if (pRoot==NULL){
    return;
  }
  infix(pRoot->pLeft);
  printf("%d:%li:%li\n",pRoot->id, pRoot->capacity, pRoot->consumption);
  infix(pRoot->pRight);
}

// Libération de la mémoire allouée pour l'arbre AVL.
void freeAVL(pTree pRoot){
  if (pRoot==NULL){
    return;
  }
  freeAVL(pRoot->pLeft);
  freeAVL(pRoot->pRight);
  free(pRoot);
}

