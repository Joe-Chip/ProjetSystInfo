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
L_Decl :        tCONST tINT {type_courant = INT_CONST;} Seq_Decl tPV 
              | tINT {type_courant = INT;} Seq_Decl tPV 
              ;
Seq_Decl :      Decl tVIRGULE Seq_Decl 
              | Decl 
              ;
Decl :          tID     {printf("Creation\n");
                         switch (type_courant)
                         {
                         case INT:
                            ts_create($1, TYPE_INT,
                                      VAR_NON_INIT, VAR_NON_CONST,
                                      niveau_courant);
                            break;
                         case INT_CONST:
                            ts_create($1, TYPE_INT,
                                      VAR_NON_INIT, VAR_CONST,
                                      niveau_courant);
                            break;
                         }}
              | tID tEGAL Expression
                        {printf("Creation_Ini\n");
                         switch (type_courant)
                         {
                         case INT:
                            ts_create($1, TYPE_INT,
                                      VAR_INIT, VAR_NON_CONST,
                                      niveau_courant);
                            break;
                         case INT_CONST:
                            ts_create($1, TYPE_INT,
                                      VAR_INIT, VAR_CONST,
                                      niveau_courant);
                            break;
                         }
                         printf("COP %d %d\n", ts_addr($1), $3);}
              ;
Expression :    tPO Expression tPF
                        {$$ = $2;}      
              | Facteur tADD Expression    
                        {printf("ADD %d %d %d\n", $1, $1, $3);
                         ts_delete_tmp();
                         $$ = $1;}
              | Facteur tSUB Expression
                        {printf("SOU %d %d %d\n", $1, $1, $3);
                         ts_delete_tmp();
                         $$ = $1;}
              | Facteur {$$ = $1;}
              ;
Facteur :       Expression tMUL Expression
                        {printf("MUL %d %d %d\n", $1, $1, $3);
                         ts_delete_tmp();
                         $$ = $1;}
              | Expression tDIV Expression  {}
                        {printf("DIV %d %d %d\n", $1, $1, $3);
                         ts_delete_tmp();
                         $$ = $1;}
              | tID     {int addr = ts_addr($1);
                         int tmp = ts_create_tmp();
                         printf("COP %d %d\n", tmp, addr);
                         $$ = tmp;}
              | tNB     {int tmp = ts_create_tmp();
                         printf("AFC %d %d\n", tmp, $1);
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








