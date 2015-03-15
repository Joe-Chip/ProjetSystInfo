%{
#include <stdio.h>

%}


%union {int nb;}
%token tADD tSOU tMUL tDIV
%token tAFC tCOP
%token tJMP tJMF
%token tAND tOR
%token tEQU tDIF tSUP tINF
%token <nb> tOPERAND
%token tNEWLINE
%start Start


%%

Start :         Instructions
             ;
Instructions :  Instruction Instructions
              | Instruction
              ;
Instruction :   Addition
              | Soustraction
              | Multiplication
              | Division
              | Affectation
              | Copie
              | Saut
              | Saut_Si_Faux
              | Et
              | Ou
              | Egal
              | Different
              | Inferieur
              | Superieur
              ;
Addition :      tADD tOPERAND tOPERAND tOPERAND tNEWLINE
              ;
Soustraction :  tSOU tOPERAND tOPERAND tOPERAND tNEWLINE
              ;
Multiplication: tMUL tOPERAND tOPERAND tOPERAND tNEWLINE
              ;
Division :      tDIV tOPERAND tOPERAND tOPERAND tNEWLINE
              ;
Affectation :   tAFC tOPERAND tOPERAND tNEWLINE
              ;
Copie :         tCOP tOPERAND tOPERAND tNEWLINE
              ;
Saut :          tJMP tOPERAND tNEWLINE
              ;
Saut_Si_Faux :  tJMF tOPERAND tOPERAND tNEWLINE
              ;
Et :            tAND tOPERAND tOPERAND tOPERAND tNEWLINE
              ;
Ou :            tOR tOPERAND tOPERAND tOPERAND tNEWLINE
              ;
Egal :          tEQU tOPERAND tOPERAND tOPERAND tNEWLINE
              ;
Different :     tDIF tOPERAND tOPERAND tOPERAND tNEWLINE
              ;
Inferieur :     tINF tOPERAND tOPERAND tOPERAND tNEWLINE
              ;
Superieur :     tSUP tOPERAND tOPERAND tOPERAND tNEWLINE
              ;

%%

int main ()
{
    return yyparse();
}


yyerror(char * s)
{
    fprintf(stderr, "%s\n", s);
}
