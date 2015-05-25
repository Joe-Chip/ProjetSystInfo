# Definition des variables
CFLAGS = 
OFILES = compilateur.o fonctions.o

default : lexgo
all : lexgo

clean :
	rm lex.yy.c y.tab.* *.o lexgo *.asm

lexgo : source.* $(OFILES)
	yacc -vd source.y
	lex source.l
	gcc $(CFLAGS) y.tab.c lex.yy.c $(OFILES) -ll -o $@

%.o : %.c %.h 
	gcc -c $< -o $@
