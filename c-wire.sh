if [[ "$#" == "3" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" ]] ; then
		echo "Voila l'aide"
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "$1" | cut -d ';' -f 2,3,5,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"hva comp")
				cat "$1" | cut -d ';' -f 3,4,5,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv comp")
				cat "$1" | cut -d ';' -f 4,5,6,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv indiv")
				cat "$1" | cut -d ';' -f 4,5,6,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv all")
				cat "$1" | cut -d ';' -f 4,5,6,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			*)
				echo "Mauvaise combinaison"
				;;
		esac
	fi

else
	echo "Pas assez ou trop d'éléments"

fi