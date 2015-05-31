# Definition des variables
CFLAGS = 
OFILES = symboles.o fonctions.o sauts.o

default : lexgo

all : lexgo

clean :
	rm lex.yy.c y.* *.o lexgo *.asm

lexgo : source.* $(OFILES)
	yacc -vd source.y
	lex source.l
	gcc $(CFLAGS) y.tab.c lex.yy.c $(OFILES) -ll -o $@

%.o : %.c %.h 
	gcc -c $< -o $@
