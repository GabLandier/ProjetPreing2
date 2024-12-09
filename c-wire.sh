#!/bin/bash

EXECUTABLE="prg"

SOURCE="Makefile"

DIRECTORY1="tmp"

DIRECTORY2="tests"

if [[ ! -f "codeC/$EXECUTABLE" ]] ; then
    echo "L'exécutable '$EXECUTABLE' est introuvable. Tentative de compilation..."
    if [ -f "codeC/$SOURCE" ] ; then
    	cd codeC
        make
        cd ..
        if [[ $? -eq 0 ]] ; then
            echo "Compilation réussie. L'exécutable '$EXECUTABLE' a été généré."
        else
            echo "Erreur : la compilation a échoué."
            echo "Temps d'execution : 0.0" 
            exit 1
        fi
    else
        echo "Erreur : le fichier source '$SOURCE' est introuvable."
        echo "Temps d'execution : 0.0"
        exit 1
    fi
fi

if [[ ! -r "$DIRECTORY1" ]] ; then
	mkdir tmp
else
	rm -rf ./tmp
	mkdir tmp
fi

if [[ ! -r "$DIRECTORY2" ]] ; then
	mkdir tests
fi

if [[ ! -f "input/$1" ]] ; then
	echo "Le fichier que vous voulez analyser n'existe pas."
	echo "Temps d'execution : 0.0"
	exit 2
fi

A=$(date +%s.%N)

if [[ "$#" == "3" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" ]] ; then
		echo "Voila l'aide"
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-B : Capacité : Consommation (entreprise)" > tests/hvb_comp.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hvb_comp.csv
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-A : Capacité : Consommation (entreprise)" > tests/hva_comp.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hva_comp.csv
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (entreprise)" > tests/lv_comp.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_comp.csv
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (particuliers)" > tests/lv_indiv.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_indiv.csv
				;;
			"lv all")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				cat tmp/fichier_temp.csv | awk -F ':' '{printf("%s:%d\n", $0, $2-$3);}' > tmp/fichier_temp2.csv
				echo "Station LV : Capacité : Consommation" > tests/lv_all.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_all.csv
				echo "Station LV : Capacité : Consommation" > tests/lv_all_minmax.csv
				if [[ $(wc -l < tmp/fichier_temp.csv) -gt 20 ]] ; then
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | head -n10 >> tests/lv_all_minmax.csv
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | tail -n10 >> tests/lv_all_minmax.csv
				else
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 >> tests/lv_all_minmax.csv
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
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-B : Capacité : Consommation (entreprise)" > tests/hvb_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hvb_comp_$4.csv
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-A : Capacité : Consommation (entreprise)" > tests/hva_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hva_comp_$4.csv
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (entreprise)" > tests/lv_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_comp_$4.csv
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (particuliers)" > tests/lv_indiv_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_indiv_$4.csv
				;;
			"lv all")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				cat tmp/fichier_temp.csv | awk -F ':' '{printf("%s:%d\n", $0, $2-$3);}' > tmp/fichier_temp2.csv
				echo "Station LV : Capacité : Consommation" > tests/lv_all_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_all_$4.csv
				echo "Station LV : Capacité : Consommation" > tests/lv_all_minmax_$4.csv
				if [[ $(wc -l < tmp/fichier_temp.csv) -gt 20 ]] ; then
					cat tmp/fichier_tmp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | head -n10 >> tests/lv_all_minmax_$4.csv
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | tail -n10 >> tests/lv_all_minmax_$4.csv
				else
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 >> tests/lv_all_minmax_$4.csv
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
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-B : Capacité : Consommation (entreprise)" > tests/hvb_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hvb_comp_$4.csv
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-A : Capacité : Consommation (entreprise)" > tests/hva_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hva_comp_$4.csv
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (entreprise)" > tests/lv_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_comp_$4.csv
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (particuliers)" > tests/lv_indiv_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_indiv_$4.csv
				;;
			"lv all")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;4\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				cat tmp/fichier_temp.csv | awk -F ':' '{printf("%s:%d\n", $0, $2-$3);}' > tmp/fichier_temp2.csv
				echo "Station LV : Capacité : Consommation" > tests/lv_all_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_all_$4.csv
				echo "Station LV : Capacité : Consommation" > tests/lv_all_minmax_$4.csv
				if [[ $(wc -l < tmp/fichier_temp.csv) -gt 20 ]] ; then
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | head -n10 >> tests/lv_all_minmax_$4.csv
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 | tail -n10 >> tests/lv_all_minmax_$4.csv
				else
					cat tmp/fichier_temp2.csv | sort -t ':' -k 4,4n | cut -d ':' -f 1,2,3 >> tests/lv_all_minmax_$4.csv
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

B=$(date +%s.%N)

echo "Temps d'execution : " 
echo "$B - $A" | bc
