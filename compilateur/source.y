%{
#include <stdio.h>

%}

%union {int nb; char* identificateur;}
%token tMAIN tCONST tINT tPRINT tRETURN
%token tAO tAF tPO tPF tPV tVIRGULE 
%token <nb> tNB
%token <identificateur> tID
%token tADD tSUB tMUL tDIV tEGAL
%start Start

%%

Start :         Main
Main :          tINT tMAIN tPO tPF tAO Corps Return tAF
              ;
Corps :         Declarations Instructions
              | Declarations
              ;
Declarations :  L_Decl Declarations 
              | L_Decl
              ;
L_Decl :        tCONST tINT Seq_Decl tPV {printf("LD\n");}
              | tINT Seq_Decl tPV {printf("LD\n");}
              ;
Seq_Decl :      Decl tVIRGULE Seq_Decl {printf("MutliD\n");}
              | Decl {printf("UniD\n");}
              ;
Decl :          tID {printf("No Ini\n");}
              | tID tEGAL Expression {printf("Ini\n");}
              ;
Expression :    Facteur tADD Facteur
              | Facteur tSUB Facteur
              | Facteur
              ;
Facteur :       Expression tMUL Expression
              | Expression tDIV Expression
              | tID
              | tNB
              ;
Instructions :  Instruction Instructions {printf("Blocs\n");}
              | Instruction {printf("B\n");}
              ;
Instruction :   Affectation
              | Print
              ;
Affectation :   tID tEGAL Expression tPV
              ;
Print :         tPRINT tPO tPF tPV
              ;
Return :        tRETURN tNB tPV {printf("Return\n");}
              ;

%%

int main () {
    return yyparse();
}

yyerror (char * s) {
    fprintf(stderr, "%s\n", s);
}
