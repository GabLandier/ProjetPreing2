# Configuration du terminal et fichier de sortie
set terminal pngcairo enhanced font "arial,10" fontscale 1.0 size 1920, 1080
set output 'stations_difference.png'

# Couleur de fond et grille
set style fill solid 1.00 noborder
set object 1 rectangle from screen 0,0 to screen 1,1 behind fillcolor rgb "white"  # Fond blanc
set border lc rgb "black"
set grid lc rgb "gray"

# Titre et étiquettes
set title "Consommation par rapport à la capcité" font ",14"
set xlabel "ID des stations"
set ylabel "Capacité - Consommation"
set xrange [ * : * ]
set yrange [ * : * ]

# Ligne de référence y=0
set style line 10 lw 1 lc rgb "black"  # Style pour y=0

# Séparateur de colonnes
set datafile separator ":"

# Tracer la courbe capacité - consommation
plot \
    0 with lines ls 10 title "y=0", \
    'tests/lv_all.csv' using ($2 - $3 > 0 ? $2 - $3 : 1/0) with filledcurves y1=0 lc rgb "#60E0A0" title "Capacité > Consommation", \
    '' using 0:($2 - $3 < 0 ? $2 - $3 : 1/0) with filledcurves y1=0 lc rgb "#E06090" title "Capacité < Consommation)", \
    '' using 0:($2 - $3) with lines lw 2 lc rgb "black" title "Capacity - Consumption"

