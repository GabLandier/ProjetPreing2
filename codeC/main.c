#include "bibli.h"

int main() {
  pTree pRoot = NULL;
  int power,id,t,son,c,h=0; // Variables utilisées pour lire les données et gérer l'équilibre
  long int capacity,consumption; // Variables pour stocker la capacité et la consommation 

  // Lecture des données en boucle. La boucle continue tant que 7 éléments sont lus correctement
  while (scanf("%d;%d;%d;%d;%li;%li;%d", &power, &id, &son, &c, &capacity, &consumption, &t) == 7) {
    // Traitement des données en fonction du type de station demandé. 
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
  // Parcours infixe de l'arbre pour afficher les nœuds dans l'ordre croissant
  infix(pRoot);
  // Libération de la mémoire allouée pour l'arbre
  freeAVL(pRoot);
  return 0;
}

