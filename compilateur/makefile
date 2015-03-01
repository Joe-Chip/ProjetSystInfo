default : lexgo
all : lexgo

clean :
	rm lex.yy.c y.tab.* lexgo 

lexgo : source.* table_symboles.c
	yacc -d source.y
	lex source.l
	gcc y.tab.c lex.yy.c table_symboles.c -ll -o $@
