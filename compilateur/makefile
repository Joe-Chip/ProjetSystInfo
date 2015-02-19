default : lexgo
all : lexgo

clean : 
	rm lex.yy.c y.tab.* lexgo 

lexgo :
	yacc -d source.y
	lex source.l
	gcc y.tab.c lex.yy.c -ll -o lexgo
