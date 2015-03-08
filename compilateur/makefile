default : lexgo
all : lexgo

clean :
	rm lex.yy.c y.tab.* lexgo *.asm

lexgo : source.* compilateur.c
	yacc -d source.y
	lex source.l
	gcc y.tab.c lex.yy.c compilateur.c -ll -o $@
