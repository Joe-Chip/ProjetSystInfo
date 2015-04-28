%{
#include <stdio.h>
#include "interpret.h"

%}


%union {int nb;}
%token tADD tSOU tMUL tDIV
%token tAFC tCOP
%token tJMP tJMF
%token tAND tOR
%token tEQU tDIF tSUP tINF
%token tCALL tRET
%token <nb> tOPERAND
%token tNEWLINE
%start Start


%%

Start           : Instructions
                ;
Instructions    : Instruction Instructions
                | Instruction
                ;
Instruction     : Addition
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
                | Call
                | Return
                ;
Addition        : tADD tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(ADD, $2, $3, $4);}
                ;
Soustraction    : tSOU tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(SOU, $2, $3, $4);}
                ;
Multiplication  : tMUL tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(MUL, $2, $3, $4);}
                ;
Division        : tDIV tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(DIV, $2, $3, $4);}
                ;
Affectation     : tAFC tOPERAND tOPERAND tNEWLINE
                    {add_ligne(AFC, $2, $3, NO_OPERANDE);}
                ;
Copie           : tCOP tOPERAND tOPERAND tNEWLINE
                    {add_ligne(COP, $2, $3, NO_OPERANDE);}
                ;
Saut            : tJMP tOPERAND tNEWLINE
                    {add_ligne(JMP, $2, NO_OPERANDE, NO_OPERANDE);}
                ;
Saut_Si_Faux    : tJMF tOPERAND tOPERAND tNEWLINE
                    {add_ligne(JMF, $2, $3, NO_OPERANDE);}
                ;
Et              : tAND tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(AND, $2, $3, $4);}
                ;
Ou              : tOR tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(OR, $2, $3, $4);}
                ;
Egal            : tEQU tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(EQU, $2, $3, $4);}
                ;
Different       : tDIF tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(DIF, $2, $3, $4);}
                ;
Inferieur       : tINF tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(INF, $2, $3, $4);}
                ;
Superieur       : tSUP tOPERAND tOPERAND tOPERAND tNEWLINE
                    {add_ligne(SUP, $2, $3, $4);}
                ;
Call            : tCALL tOPERAND
                    {add_ligne(CALL, $2, NO_OPERANDE, NO_OPERANDE);}
                ;
Return          : tRET
                    {add_ligne(RET, NO_OPERANDE, NO_OPERANDE, NO_OPERANDE);}
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
