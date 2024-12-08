CFLAGS = -Wno-implicit-function-declaration

Tout : prg

prg: main.o avl.o
	@echo "Creation de l'application finale"
	@gcc $(CFLAGS) main.o avl.o -o prg
	
main.o: main.c bibli.h
	@echo "Compilation du mode main"
	@gcc $(CFLAGS) -c main.c
	
avl.o: avl.c bibli.h
	@echo "Compilation du mode avl"
	@gcc $(CFLAGS) -c avl.c
	
vide:
	@echo "Supression des fichier supplementaires"
	@rm -f *.o
	@rm prg
