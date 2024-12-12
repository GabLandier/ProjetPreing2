# Projet PréIng2

## Sommaire

1) [Description](#Description)
2) [Focntionnalités](#Fonctionnalités)
3) [Utilisation](#Utilisation)

## Description

Ce projet contient un programme qui réalise la synthèse de données d’un système de distribution d’électricité contenu sous la forme d'un fichier .csv selon 
les paramètres souhaité et crée en sortie un tableau contenant les résultats.


## Fonctionnalités

	•	trie les données des différentes stations (centrales, stations HV-A, stations HV-B, postes LV) selon les paramètres souhaité
	•	détermine si elles sont en situation de surproduction ou de sous-production d’énergie
	•	évalue quelle proportion de leur énergie est consommée par les entreprises et les particuliers

## Utilisation

1) Décompresser le dossier
2) Dans le terminal, éxectuer :

```bash
./c-wire.sh nom_du_fichier option
```

option:


	• hvb comp

	• hva comp

	• lv all

	• lv comp

	• lv indiv
 
Optonnel:

Le numéro de la centrale peut être ajouté à la suite de l'option.

L'option "-h" peut vous aider à avoir plus d'aide.


3) Le fichier .csv contenant le résultat de l'éxecution est créée.


## Auteurs

LANDIER Gabin

CALVANO Romain

BERRANDOU Nassim
