#!/bin/bash

EXECUTABLE="prg"

SOURCE="Makefile"

DIRECTORY1="tmp"

DIRECTORY2="tests"

DIRECTORY3="graphs"

DIRECTORY4="codeC"

DIRECTORY5="input"

DIRECTORY6="plot"

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

if [[ "$1" == "-h" ]] ; then
	echo ""
	echo "Aide : ./c-wire <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
	echo "                                  hvb               comp"
	echo "                                  hva               indiv"
	echo "                                  lv                all"
	echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all " 
	echo ""
	exit 1
fi

if [[ ! -f "input/$1" ]] ; then
	echo "Le fichier que vous voulez analyser n'existe pas."
	exit 1
fi

if [[ ! -r "$DIRECTORY3" ]] ; then
	mkdir graphs
else
	rm -rf ./graphs
	mkdir graphs
fi



A=$(date +%s)

if [[ "$#" == "3" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" ]] ; then
		echo ""
		echo "Aide : ./c-wire <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
		echo "                                  hvb               comp"
		echo "                                  hva               indiv"
		echo "                                  lv                all"
		echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all " 
		echo ""
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-B : Capacité : Consommation (entreprise)" > tests/hvb_comp.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hvb_comp.csv
				gnuplot plot/graph.plot
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-A : Capacité : Consommation (entreprise)" > tests/hva_comp.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hva_comp.csv
				gnuplot plot/graph.plot
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (entreprise)" > tests/lv_comp.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_comp.csv
				gnuplot plot/graph.plot
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (particuliers)" > tests/lv_indiv.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_indiv.csv
				gnuplot plot/graph.plot
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
				gnuplot plot/graph.plot
				;;
			*)
				echo "Mauvaise combinaison"
				echo ""
				echo "Aide : ./c-wire <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
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
		echo "Aide : ./c-wire <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
		echo "                                  hvb               comp"
		echo "                                  hva               indiv"
		echo "                                  lv                all"
		echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all "  
		echo ""
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-B : Capacité : Consommation (entreprise)" > tests/hvb_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hvb_comp_$4.csv
				gnuplot plot/graph.plot
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-A : Capacité : Consommation (entreprise)" > tests/hva_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hva_comp_$4.csv
				gnuplot plot/graph.plot
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (entreprise)" > tests/lv_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_comp_$4.csv
				gnuplot plot/graph.plot
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (particuliers)" > tests/lv_indiv_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_indiv_$4.csv
				gnuplot plot/graph.plot
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
				gnuplot plot/graph.plot
				;;
			*)
				echo "Mauvaise combinaison"
				echo ""
				echo "Aide : ./c-wire <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
				echo "                                  hvb               comp"
				echo "                                  hva               indiv"
				echo "                                  lv                all"
				echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all "  
				echo ""
				;;
		esac
	fi
	
elif [[ "$#" == "5" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" || "$4" == "-h" || "$5" == "-h" ]] ; then
		echo ""
		echo "Aide : ./c-wire <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
		echo "                                  hvb               comp"
		echo "                                  hva               indiv"
		echo "                                  lv                all"
		echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all "  
		echo ""
	elif [[ "$5" != "-h" ]] ; then
		echo "Mauvaise combinaison"
		echo ""
		echo "Aide : ./c-wire <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
		echo "                                  hvb               comp"
		echo "                                  hva               indiv"
		echo "                                  lv                all"
		echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all "  
		echo ""
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "input/$1" | cut -d ';' -f 1,2,3,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-B : Capacité : Consommation (entreprise)" > tests/hvb_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hvb_comp_$4.csv
				gnuplot plot/graph.plot
				;;
			"hva comp")
				cat "input/$1" | cut -d ';' -f 1,3,4,5,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;1\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station HV-A : Capacité : Consommation (entreprise)" > tests/hva_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/hva_comp_$4.csv
				gnuplot plot/graph.plot
				;;
			"lv comp")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;2\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (entreprise)" > tests/lv_comp_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_comp_$4.csv
				gnuplot plot/graph.plot
				;;
			"lv indiv")
				cat "input/$1" | cut -d ';' -f 1,4,5,6,7,8 | tail -n +2 | tr '-' '0' | awk '{printf("%s;3\n", $0);}' | awk -F';' -v col4="$4" '$1==col4' | codeC/prg > tmp/fichier_temp.csv
				echo "Station LV : Capacité : Consommation (particuliers)" > tests/lv_indiv_$4.csv
				cat tmp/fichier_temp.csv | sort -t ':' -k 2,2n >> tests/lv_indiv_$4.csv
				gnuplot plot/graph.plot
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
				gnuplot plot/graph.plot
				;;
			*)
				echo "Mauvaise combinaison"
				echo ""
				echo "Aide : ./c-wire <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
				echo "                                  hvb               comp"
				echo "                                  hva               indiv"
				echo "                                  lv                all"
				echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all " 
				echo ""
				;;
		esac
	fi

else
	echo "Pas assez ou trop d'éléments"
	echo ""
	echo "Aide : ./c-wire <nom du fichier> <type de station> <type de consommateur> <numéro de centrale (optionnel)>"
	echo "                                  hvb               comp"
	echo "                                  hva               indiv"
	echo "                                  lv                all"
	echo "       Combinaisons impossibles : hvb indiv / hvb all / hva indiv / hva all " 
	echo ""

fi

B=$(date +%s)

echo "Temps d'execution : " 
echo "$B - $A" | bc
