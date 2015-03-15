default : interprete 
all : interprete

clean :
	rm lex.yy.c y.tab.* interprete

interprete : source.*
	yacc -d source.y
	lex source.l
	gcc y.tab.c lex.yy.c -ll -o $@
