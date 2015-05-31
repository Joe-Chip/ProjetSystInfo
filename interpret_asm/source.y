%{
#include <stdio.h>
#include "interpret.h"

extern FILE * yyin;
extern int yylineno;
%}


%union {int nb;}
%token tADD tSOU tMUL tDIV
%token tAFC tCOP
%token tPRI
%token tJMP tJMF
%token tAND tOR
%token tEQU tSUP tINF
%token tCALL tRET
%token tPUSH tPOP
%token tNEG tBP tRT
%token <nb> tOPERAND 
%token tNEWLINE
%type <nb> Operande
%start Start


%%

Start           : Instructions
                ;
Instructions    : Instruction tNEWLINE Instructions
                | Instruction 
                ;
Instruction     : Addition
                | Soustraction
                | Multiplication
                | Division
                | Affectation
                | Copie
                | Print
                | Saut
                | Saut_Si_Faux
                | Et
                | Ou
                | Egal
                | Inferieur
                | Superieur
                | Call
                | Return
                | Push
                | Pop
                ;
Operande        : tOPERAND
                    {$$ = $1;}
                | tNEG tOPERAND
                    {$$ = -$2;}
                | tBP
                    {$$ = BASE_POINTER;}
                | tRT
                    {$$ = REG_RETOUR;}
                ;
Addition        : tADD Operande Operande Operande
                    {add_ligne(ADD, $2, $3, $4);}
                ;
Soustraction    : tSOU Operande Operande Operande
                    {add_ligne(SOU, $2, $3, $4);}
                ;
Multiplication  : tMUL Operande Operande Operande
                    {add_ligne(MUL, $2, $3, $4);}
                ;
Division        : tDIV Operande Operande Operande
                    {add_ligne(DIV, $2, $3, $4);}
                ;
Affectation     : tAFC Operande Operande
                    {add_ligne(AFC, $2, $3, NO_OPERANDE);}
                ;
Copie           : tCOP Operande Operande
                    {add_ligne(COP, $2, $3, NO_OPERANDE);}
                ;
Print           : tPRI Operande
                    {add_ligne(PRI, $2, NO_OPERANDE, NO_OPERANDE);}
                ;
Saut            : tJMP Operande
                    {add_ligne(JMP, $2, NO_OPERANDE, NO_OPERANDE);}
                ;
Saut_Si_Faux    : tJMF Operande Operande
                    {add_ligne(JMF, $2, $3, NO_OPERANDE);}
                ;
Et              : tAND Operande Operande Operande
                    {add_ligne(AND, $2, $3, $4);}
                ;
Ou              : tOR Operande Operande Operande
                    {add_ligne(OR, $2, $3, $4);}
                ;
Egal            : tEQU Operande Operande Operande
                    {add_ligne(EQU, $2, $3, $4);}
                ;
Inferieur       : tINF Operande Operande Operande
                    {add_ligne(INF, $2, $3, $4);}
                ;
Superieur       : tSUP Operande Operande Operande
                    {add_ligne(SUP, $2, $3, $4);}
                ;
Call            : tCALL Operande
                    {add_ligne(CALL, $2, NO_OPERANDE, NO_OPERANDE);}
                ;
Return          : tRET Operande
                    {add_ligne(RET, $2, NO_OPERANDE, NO_OPERANDE);}
                ;
Push            : tPUSH Operande
                    {add_ligne(CALL, $2, NO_OPERANDE, NO_OPERANDE);}
                ;
Pop             : tPOP Operande
                    {add_ligne(CALL, $2, NO_OPERANDE, NO_OPERANDE);}
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
