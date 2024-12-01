CFLAGS = -Wno-implicit-function-declaration

Tout : prg

prg: hv.o comp.o indiv.o all.o
	@echo "Creation de l'application finale"
	@gcc $(CFLAGS) hv.o indiv.o all.o -o prg
	
hv.o: hv.c bibli.h
	@echo "Compilation du mode hv"
	@gcc $(CFLAGS) -c hv.c
	
comp.o: comp.c bibli.h
	@echo "Compilation du mode comp"
	@gcc $(CFLAGS) -c comp.c

indiv.o: indiv.c bibli.h
	@echo "Compilation du mode indiv"
	@gcc $(CFLAGS) -c indiv.c
	
all.o: all.c bibli.h
	@echo "Compilation du mode all"
	@gcc $(CFLAGS) -c all.c
	
vide:
	@echo "Supression des fichier supplementaires"
	@rm -f *.o
	@rm prg
