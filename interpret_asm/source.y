%{
#include <stdio.h>
#include "interpret.h"

extern FILE * yyin;
extern int yylineno;
%}


%union {int nb;}
%token tADD tSOU tMUL tDIV
%token tAFC tCOP
%token tJMP tJMF
%token tAND tOR
%token tEQU tSUP tINF
%token tCALL tRET
%token tNEG tBP
%token <nb> tOPERAND 
%token tNEWLINE
%type <nb> Operande
%start Start


%%

Start           : Instructions
                ;
Instructions    : Instruction {yylineno++;} Instructions
                | Instruction {yylineno++;}
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
                | Inferieur
                | Superieur
                | Call
                | Return
                ;
Operande        : tOPERAND
                    {$$ = $1;}
                | {printf("OP neg\n");} tNEG tOPERAND
                    {$$ = -$3;}
                | tBP
                    {$$ = BASE_POINTER;}
                ;
Addition        : tADD Operande Operande Operande tNEWLINE
                    {add_ligne(ADD, $2, $3, $4);}
                ;
Soustraction    : tSOU Operande Operande Operande tNEWLINE
                    {add_ligne(SOU, $2, $3, $4);}
                ;
Multiplication  : tMUL Operande Operande Operande tNEWLINE
                    {add_ligne(MUL, $2, $3, $4);}
                ;
Division        : tDIV Operande Operande Operande tNEWLINE
                    {add_ligne(DIV, $2, $3, $4);}
                ;
Affectation     : tAFC Operande Operande tNEWLINE
                    {add_ligne(AFC, $2, $3, NO_OPERANDE);}
                ;
Copie           : tCOP Operande Operande tNEWLINE
                    {add_ligne(COP, $2, $3, NO_OPERANDE);}
                ;
Saut            : tJMP Operande tNEWLINE
                    {add_ligne(JMP, $2, NO_OPERANDE, NO_OPERANDE);}
                ;
Saut_Si_Faux    : tJMF Operande Operande tNEWLINE
                    {add_ligne(JMF, $2, $3, NO_OPERANDE);}
                ;
Et              : tAND Operande Operande Operande tNEWLINE
                    {add_ligne(AND, $2, $3, $4);}
                ;
Ou              : tOR Operande Operande Operande tNEWLINE
                    {add_ligne(OR, $2, $3, $4);}
                ;
Egal            : tEQU Operande Operande Operande tNEWLINE
                    {add_ligne(EQU, $2, $3, $4);}
                ;
Inferieur       : tINF Operande Operande Operande tNEWLINE
                    {add_ligne(INF, $2, $3, $4);}
                ;
Superieur       : tSUP Operande Operande Operande tNEWLINE
                    {add_ligne(SUP, $2, $3, $4);}
                ;
Call            : tCALL Operande tNEWLINE
                    {add_ligne(CALL, $2, NO_OPERANDE, NO_OPERANDE);}
                ;
Return          : tRET tNEWLINE
                    {add_ligne(RET, NO_OPERANDE, NO_OPERANDE, NO_OPERANDE);}
                ;

%%

int main (int argc, char * argv[])
{
    int result;

    if (argc == 2) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            printf("Fichier d'entrée non existant\n");
            result = 2;
        }
    }

    result = yyparse();

    if (result == 0) {
        execute();
    }

    return result;
}


yyerror(char * s)
{
    fprintf(stderr, "Ligne %d : %s\n", yylineno, s);
}
