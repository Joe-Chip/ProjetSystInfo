# Definition des variables
CFLAGS = 
OFILES = interpret.o

default : interprete 
all : interprete

clean :
	rm lex.yy.c y.tab.* interprete

interprete : source.* $(OFILES)
	yacc -d source.y
	lex source.l
	gcc y.tab.c lex.yy.c $(OFILES) -ll -o $@

%.o : %.c %.h 
	gcc -c $< -o $@
