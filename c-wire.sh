#!/bin/bash

# Définition des variables
EXECUTABLE="prg" # Nom de l'exécutable à vérifier/compresser

SOURCE="Makefile" # Nom du fichier Makefile pour la compilation

DIRECTORY1="tmp" # Répertoire temporaire

DIRECTORY2="output" # Répertoire pour les fichiers de sortie

DIRECTORY3="graphs" # Répertoire pour les graphiques

DIRECTORY4="codeC" # Répertoire contenant le code source

DIRECTORY5="input" # Répertoire contenant les fichiers d'entrée

DIRECTORY6="plot" # Répertoire contenant les scripts de génération des graphiques


# Vérification de l'existence des répertoires nécessaires
if [[ ! -r "$DIRECTORY4" ]] ; then
	echo "Le fichier codeC est introuvable"
	exit 1
fi

if [[ ! -r "$DIRECTORY5" ]] ; then
	echo "Le fichier input est introuvable"
	exit 1
fi

if [[ ! -r "$DIRECTORY6" ]] ; then
	echo "Le fichier plot est introuvable"
	exit 1
fi

# Vérification de l'existence de l'exécutable dans le répertoire codeC
if [[ ! -f "codeC/$EXECUTABLE" ]] ; then
    echo "L'exécutable '$EXECUTABLE' est introuvable. Tentative de compilation..."
    # Si le fichier Makefile existe, tenter de compiler
    if [ -f "codeC/$SOURCE" ] ; then
    	cd codeC
        make # Compilation du programme
        cd ..
        # Si la compilation réussit, afficher un message de succès
        if [[ $? -eq 0 ]] ; then
            echo "Compilation réussie. L'exécutable '$EXECUTABLE' a été généré."
        else
            echo "Erreur : la compilation a échoué."
            echo "Temps d'execution : 0.0" 
            exit 1
        fi
    else
        echo "Erreur : le fichier source '$SOURCE' est introuvable."
        echo ""
        # Affichage de l'aide pour l'utilisation du script
	echo "Aide : ./c-wire.sh <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
	echo "                                  hvb               comp"
	echo "                                  hva               indiv"
	echo "                                  lv                all"
	echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all "  
	echo ""
        exit 1
    fi
fi

# Création ou réinitialisation du répertoire temporaire 'tmp'
if [[ ! -r "$DIRECTORY1" ]] ; then
	mkdir tmp
else
	rm -rf ./tmp # Supprimer le répertoire existant 'tmp' avant de le recréer
	mkdir tmp
fi

# Création du répertoire 'output' s'il n'existe pas
if [[ ! -r "$DIRECTORY2" ]] ; then
	mkdir output
fi

# Affichage de l'aide si le paramètre '-h' est passé
if [[ "$1" == "-h" ]] ; then
	echo ""
	echo "Aide : ./c-wire.sh <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
	echo "                                  hvb               comp"
	echo "                                  hva               indiv"
	echo "                                  lv                all"
	echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all " 
	echo ""
	exit 1
fi

# Vérification que le fichier d'entrée existe
if [[ ! -f "input/$1" ]] ; then
	echo "Le fichier que vous voulez analyser n'existe pas."
	echo ""
				echo "Aide : ./c-wire.sh <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
				echo "                                  hvb               comp"
				echo "                                  hva               indiv"
				echo "                                  lv                all"
				echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all "  
				echo ""
	exit 1
fi


# Création ou réinitialisation du répertoire "graphs"
if [[ ! -r "$DIRECTORY3" ]] ; then
	mkdir graphs
else
	rm -rf ./graphs # Supprimer le répertoire existant "graphs" avant de le recréer
	mkdir graphs
fi

# Enregistrement de l'heure de début pour mesurer le temps d'exécution
A=$(date +%s)

# Traitement en fonction du nombre d'arguments
if [[ "$#" == "3" ]] ; then
	# Si l'un des arguments est '-h', afficher l'aide
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" ]] ; then
		echo ""
		echo "Aide : ./c-wire.sh <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
		echo "                                  hvb               comp"
		echo "                                  hva               indiv"
		echo "                                  lv                all"
		echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all " 
		echo ""
	else 
		# Traitement en fonction des combinaisons de paramètres
		case "$2 $3" in 
			# Cas pour une station HV-B avec consommation d'entreprise
			"hvb comp")
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-B : Capacité : Consommation (entreprise)" > output/hvb_comp.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/hvb_comp.csv
				;;
			# Cas pour une station HV-A avec consommation d'entreprise
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-A : Capacité : Consommation (entreprise)" > output/hva_comp.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/hva_comp.csv
				;;
			# Cas pour une station LV avec consommation d'entreprise
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (entreprise)" > output/lv_comp.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/lv_comp.csv
				;;
			# Cas pour une station LV avec consommation de particuliers
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (particuliers)" > output/lv_indiv.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/lv_indiv.csv
				;;
			# Cas pour une station LV avec tous types de consommations
			"lv all")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				cat tmp/fichier_temp.csv | awk -F ':' '{printf("%s:%d\n", $0, $2-$3);}' > tmp/fichier_temp2.csv
				echo "Station LV : Capacité : Consommation" > output/lv_all.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/lv_all.csv
				echo "Station LV : Capacité : Consommation" > output/lv_all_minmax.csv
				# Si plus de 20 lignes, prendre les 10 premiers et derniers éléments
				if [[ $(wc -l < tmp/fichier_temp.csv) -gt 20 ]] ; then
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | head -n10 >> output/lv_all_minmax.csv
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | tail -n10 >> output/lv_all_minmax.csv
				else
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 >> output/lv_all_minmax.csv
				fi
				
				cat output/lv_all_minmax.csv | tail -n +2 > tmp/lv_all_minmaxtmp.csv
				
				# Générer un graphique avec gnuplot
				gnuplot plot/graph.plot
				;;
			*)
				echo "Mauvaise combinaison"
				echo ""
				echo "Aide : ./c-wire.sh <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
				echo "                                  hvb               comp"
				echo "                                  hva               indiv"
				echo "                                  lv                all"
				echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all " 
				echo ""
				;;
		esac
	fi

elif [[ "$#" == "4" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" || "$4" == "-h" ]] ; then
		echo ""
		echo "Aide : ./c-wire.sh <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
		echo "                                  hvb               comp"
		echo "                                  hva               indiv"
		echo "                                  lv                all"
		echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all "  
		echo ""
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-B : Capacité : Consommation (entreprise)" > output/hvb_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/hvb_comp_$4.csv
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-A : Capacité : Consommation (entreprise)" > output/hva_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/hva_comp_$4.csv
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (entreprise)" > output/lv_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/lv_comp_$4.csv
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (particuliers)" > output/lv_indiv_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/lv_indiv_$4.csv
				;;
			"lv all")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				cat tmp/fichier_temp.csv | awk -F ':' '{printf("%s:%d\n", $0, $2-$3);}' > tmp/fichier_temp2.csv
				echo "Station LV : Capacité : Consommation" > output/lv_all_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> output/lv_all_$4.csv
				echo "Station LV : Capacité : Consommation" > output/lv_all_minmax_$4.csv
				if [[ $(wc -l < tmp/fichier_temp.csv) -gt 20 ]] ; then
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | head -n10 >> output/lv_all_minmax_$4.csv
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | tail -n10 >> output/lv_all_minmax_$4.csv
				else
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 >> output/lv_all_minmax_$4.csv
				fi
				
				cat output/lv_all_minmax_$4.csv | tail -n +2 > tmp/lv_all_minmaxtmp.csv
				gnuplot plot/graph.plot
				;;
			*)
				echo "Mauvaise combinaison"
				echo ""
				echo "Aide : ./c-wire.sh <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
				echo "                                  hvb               comp"
				echo "                                  hva               indiv"
				echo "                                  lv                all"
				echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all "  
				echo ""
				;;
		esac
	fi
	
elif [[ "$#" == "5" && ("$1" == "-h" || "$2" == "-h" || "$3" == "-h" || "$4" == "-h" || "$5" == "-h") ]] ; then
		echo ""
		echo "Aide : ./c-wire.sh <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
		echo "                                  hvb               comp"
		echo "                                  hva               indiv"
		echo "                                  lv                all"
		echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all "  
		echo "" 
		
else
	echo "Pas assez ou trop d'éléments"
	echo ""
	echo "Aide : ./c-wire.sh <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
	echo "                                  hvb               comp"
	echo "                                  hva               indiv"
	echo "                                  lv                all"
	echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all " 
	echo ""

fi

# Enregistrement de l'heure de fin pour calculer le temps d'exécution
B=$(date +%s)

# Calcul et affichage du temps d'exécution
echo "Temps d'execution : " 
echo "$B - $A" | bc
