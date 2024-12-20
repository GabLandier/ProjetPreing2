# Configuration du terminal et fichier de sortie
set terminal pngcairo enhanced font "arial,10" fontscale 1.0 size 1600, 900
set output 'graphs/graph.png'

# Couleur de fond et grille
set style fill solid 1.00 noborder
set object 1 rectangle from screen 0,0 to screen 1,1 behind fillcolor rgb "white"
set border lc rgb "black"
set grid lc rgb "gray"

# Titre et étiquettes
set title "Postes LV les plus et moins chargés" font ",14"
set xlabel "ID des stations"
set ylabel "Consommation / Capacité"
set xtics rotate by -45 font ",8"

# Séparateur de colonnes
set datafile separator ":"

# Paramètres des barres
set style data histograms
set style histogram clustered gap 1
set boxwidth 0.8 relative
set style fill solid 0.5 border -1

# Tracer les barres avec des couleurs conditionnelles
plot \
    'tmp/lv_all_minmaxtmp.csv' using ( ($2 - $3) > 0 ? $2 - $3 : 0 ):xtic(1) title "Capacité - Consommation" lc rgb "#60E0A0" fillstyle solid 1.0, \
    '' using ( ($3 - $2) > 0 ? $3 - $2 : 0 ):xtic(1) title "Consommation - Capacité" lc rgb "#E06090" fillstyle solid 1.0

