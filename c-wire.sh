#!/bin/bash

EXECUTABLE="prg"

SOURCE="Makefile"

if [ ! -f "./$EXECUTABLE" ]; then
    echo "L'exécutable '$EXECUTABLE' est introuvable. Tentative de compilation..."
    if [ -f "./$SOURCE" ]; then
        make
        if [ $? -eq 0 ]; then
            echo "Compilation réussie. L'exécutable '$EXECUTABLE' a été généré."
        else
            echo "Erreur : la compilation a échoué."
            exit 1
        fi
    else
        echo "Erreur : le fichier source '$SOURCE' est introuvable."
        exit 1
    fi
fi

if [[ "$#" == "3" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" ]] ; then
		echo "Voila l'aide"
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | ./prg
				;;
			"hva comp")
				cat "$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | ./prg
				;;
			"lv comp")
				cat "$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | ./prg
				;;
			"lv indiv")
				cat "$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | ./prg
				;;
			"lv all")
				cat "$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | sort -t ';' -k 5,5nr > lv_all_minmax.csv
				cat lv_all_minmax.csv | ./prg
				rm lv_all_minmax.csv
				;;
			*)
				echo "Mauvaise combinaison"
				;;
		esac
	fi

elif [[ "$#" == "4" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" || "$4" == "-h" ]] ; then
		echo "Voila l'aide"
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | ./prg
				;;
			"hva comp")
				cat "$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | ./prg
				;;
			"lv comp")
				cat "$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | ./prg
				;;
			"lv indiv")
				cat "$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | ./prg
				;;
			"lv all")
				cat "$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | sort -t ';' -k 5,5nr > lv_all_minmax.csv
				cat lv_all_minmax.csv | ./prg
				rm lv_all_minmax.csv
			;;
			*)
				echo "Mauvaise combinaison"
				;;
		esac
	fi
	
elif [[ "$#" == "5" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" || "$4" == "-h" || "$5" == "-h" ]] ; then
		echo "Voila l'aide"
	elif [[ "$5" != "-h" ]] ; then
		echo "Mauvaise combinaison"
		echo "Voila l'aide"
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | ./prg
				;;
			"hva comp")
				cat "$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | ./prg
				;;
			"lv comp")
				cat "$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | ./prg
				;;
			"lv indiv")
				cat "$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | ./prg
				;;
			"lv all")
				cat "$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | sort -t ';' -k 5,5nr > lv_all_minmax.csv
				cat lv_all_minmax.csv | ./prg
				rm lv_all_minmax.csv
				;;
			*)
				echo "Mauvaise combinaison"
				;;
		esac
	fi

else
	echo "Pas assez ou trop d'éléments"

fi
