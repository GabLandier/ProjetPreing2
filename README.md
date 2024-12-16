# Projet PréIng2  

## Sommaire  

1) [Description](#Description)  
2) [Fonctionnalités](#Fonctionnalités)  
3) [Utilisation](#Utilisation)
4) [Récuperation des résultats](#Récuperation_des_résultats)

## Description  

Ce projet contient un programme qui réalise la synthèse de données d’un système de distribution d’électricité contenu sous la forme d'un fichier .csv selon les paramètres souhaités et crée en sortie un tableau contenant les résultats.  

## Fonctionnalités  

- Trie les données des différentes stations (centrales, stations HV-A, stations HV-B, postes LV) selon les paramètres souhaités  
- Détermine si elles sont en situation de surproduction ou de sous-production d’énergie  
- Évalue quelle proportion de leur énergie est consommée par les entreprises et les particuliers  
- Création de graphiques  

## Utilisation  

1) Décompresser le dossier  
2) Déposer le fichier utilisé dans un dossier "input" créé préalablement  
3) Dans le terminal, exécuter :  

```bash  
./c-wire.sh nom_du_fichier option  
```  

### Options :  

- hvb comp  
- hva comp  
- lv all  
- lv comp  
- lv indiv  

### Optionnel :  

Le numéro de la centrale peut être ajouté à la suite de l'option.  

L'option "-h" peut vous aider à obtenir plus d'aide.  

4) Le fichier .csv contenant le résultat de l'exécution est créé.

## Récuperation_des_résultats

## Auteurs  

LANDIER Gabin  
CALVANO Romain  
BERRANDOU Nassim  
```
