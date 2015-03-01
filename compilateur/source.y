%{
#include <stdio.h>
#include "table_symboles.h"

%}

%union {int nb; char* identificateur;}
%token tMAIN tCONST tINT tPRINT tRETURN
%token tAO tAF tPO tPF tPV tVIRGULE 
%token <nb> tNB
%token <identificateur> tID
%token tADD tSUB tMUL tDIV tEGAL
%type <nb> Facteur Expression
%start Start

%%

Start :         Main
Main :          tINT tMAIN tPO tPF tAO Corps Return tAF
              ;
Corps :         Declarations Instructions
              | Declarations
              | Instructions
              ;
Declarations :  L_Decl Declarations 
              | L_Decl
              ;
L_Decl :        tCONST tINT Seq_Decl tPV 
              | tINT Seq_Decl tPV 
              ;
Seq_Decl :      Decl tVIRGULE Seq_Decl 
              | Decl 
              ;
Decl :          tID     {ts_create($1, , DEFAULT, , niveau_courant);}
              | tID tEGAL Expression
                        {ts_create($1, , VAR_INIT, , niveau_courant);
                         printf("COP %d %d\n", ts_addr($1), $3)}
              ;
Expression :    tPO Expression tPF
                        {$$ = $2;}      
              | Facteur tADD Facteur    
                        {printf("ADD %d %d %d", $1, $1, $3);
                         ts_delete_tmp();
                         $$ = $1;}
              | Facteur tSUB Facteur
                        {printf("SOU %d %d %d", $1, $1, $3);
                         ts_delete_tmp();
                         $$ = $1;}
              | Facteur {$$ = $1;}
              ;
Facteur :       Expression tMUL Expression
                        {printf("MUL %d %d %d", $1, $1, $3);
                         ts_delete_tmp();
                         $$ = $1;}
              | Expression tDIV Expression  {}
                        {printf("DIV %d %d %d", $1, $1, $3);
                         ts_delete_tmp();
                         $$ = $1;}
              | tID     {int addr = ts_addr($1);
                         int tmp = ts_create_tmp();
                         printf("COP %d %d\n", tmp, addr);
                         $$ = tmp;}
              | tNB     {int tmp = ts_create_tmp();
                         printf("AFC %d %d", tmp, $1);
                         $$ = tmp;}
              ;
Instructions :  Instruction Instructions
              | Instruction
              ;
Instruction :   Affectation
              | Print
              ;
Affectation :   tID tEGAL Expression tPV
              ;
Print :         tPRINT tPO tPF tPV
              ;
Return :        tRETURN tNB tPV
              ;

%%

int main ()
{
    return yyparse();
}

yyerror (char * s)
{
    fprintf(stderr, "%s\n", s);
}








