if [[ "$#" == "3" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" ]] ; then
		echo "Voila l'aide"
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "$1" | cut -d ';' -f 2,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"hva comp")
				cat "$1" | cut -d ';' -f 3,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv comp")
				cat "$1" | cut -d ';' -f 4,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv indiv")
				cat "$1" | cut -d ';' -f 4,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv all")
				cat "$1" | cut -d ';' -f 4,7,8 | tail -n +2 | tr '-' '0' | ./main
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
				cat "$1" | cut -d ';' -f 2,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"hva comp")
				cat "$1" | cut -d ';' -f 3,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv comp")
				cat "$1" | cut -d ';' -f 4,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv indiv")
				cat "$1" | cut -d ';' -f 4,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv all")
				cat "$1" | cut -d ';' -f 4,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			*)
				echo "Mauvaise combinaison"
				;;
		esac
	fi

elif [[ "$#" == "5" ]] ; then
	if [[ "$1" == "-h" || "$2" == "-h" || "$3" == "-h" || "$4" == "-h" || "$5" == "-h" ]] ; then
		echo "Voila l'aide"
	else 
		case "$2 $3" in 
	
			"hvb comp")
				cat "$1" | cut -d ';' -f 2,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"hva comp")
				cat "$1" | cut -d ';' -f 3,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv comp")
				cat "$1" | cut -d ';' -f 4,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv indiv")
				cat "$1" | cut -d ';' -f 4,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			"lv all")
				cat "$1" | cut -d ';' -f 4,7,8 | tail -n +2 | tr '-' '0' | ./main
				;;
			*)
				echo "Mauvaise combinaison"
				;;
		esac
	fi

else
	echo "Pas assez ou trop d'éléments"

fi
