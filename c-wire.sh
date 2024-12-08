#!/bin/bash

EXECUTABLE="prg"

SOURCE="Makefile"

DIRECTORY1="temp"

DIRECTORY2="graphs"

if [[ ! -f "codeC/$EXECUTABLE" ]] ; then
    echo "L'exécutable '$EXECUTABLE' est introuvable. Tentative de compilation..."
    if [ -f "codeC/$SOURCE" ] ; then
    	cd codeC
        make
        if [[ $? -eq 0 ]] ; then
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

if [[ ! -r "$DIRECTORY1" ]] ; then
	mkdir temp
else
	rm -rf ./temp
	mkdir temp
fi

if [[ ! -r "$DIRECTORY2" ]] ; then
	mkdir graphs
else
	rm -rf ./graphs
	mkdir graphs
fi

if [[ "$#" == "3" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" ]] ; then
		echo "Voila l'aide"
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/hvb_comp.csv
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/hva_comp.csv
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/lv_comp.csv
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/lv_indiv.csv
				;;
			"lv all")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/lv_all.csv
				if [[ $(wc -l < temp/fichier_temp.csv) -gt 20 ]] ; then
					cat temp/fichier_temp.csv | sort -t ':' -k 2,2nr | head -n10 > tests/lv_all_minmax.csv
					cat temp/fichier_temp.csv | sort -t ':' -k 2,2nr | tail -n10 >> tests/lv_all_minmax.csv
				else
					cat temp/fichier_temp.csv | sort -t ':' -k 2,2nr > tests/lv_all_minmax.csv
				fi
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
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/hvb_comp_$4.csv
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/hva_comp_$4.csv
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/lv_comp_$4.csv
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/lv_indiv_$4.csv
				;;
			"lv all")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/lv_all.csv
				if [[ $(wc -l < temp/fichier_temp.csv) -gt 20 ]] ; then
					cat temp/fichier_temp.csv | sort -t ':' -k 2,2nr | head -n10 > tests/lv_all_minmax.csv
					cat temp/fichier_temp.csv | sort -t ':' -k 2,2nr | tail -n10 >> tests/lv_all_minmax.csv
				else
					cat temp/fichier_temp.csv | sort -t ':' -k 2,2nr > tests/lv_all_minmax.csv
				fi
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
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/hvb_comp_$4.csv
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/hva_comp_$4.csv
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/lv_comp_$4.csv
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/lv_indiv_$4.csv
				;;
			"lv all")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > temp/fichier_temp.csv
				cat temp/fichier_temp.csv | sort -t ':' -k 2,2n > tests/lv_all.csv
				if [[ $(wc -l < temp/fichier_temp.csv) -gt 20 ]] ; then
					cat temp/fichier_temp.csv | sort -t ':' -k 2,2nr | head -n10 > tests/lv_all_minmax.csv
					cat temp/fichier_temp.csv | sort -t ':' -k 2,2nr | tail -n10 >> tests/lv_all_minmax.csv
				else
					cat temp/fichier_temp.csv | sort -t ':' -k 2,2nr > tests/lv_all_minmax.csv
				fi
				;;
			*)
				echo "Mauvaise combinaison"
				;;
		esac
	fi

else
	echo "Pas assez ou trop d'éléments"

fi





