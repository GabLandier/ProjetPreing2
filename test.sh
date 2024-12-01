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

