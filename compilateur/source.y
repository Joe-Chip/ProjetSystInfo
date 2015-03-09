%{
#include <stdio.h>
#include "compilateur.h"

extern FILE * yyin;
extern int yylineno;
%}

%union {int nb; char* identificateur;}
%token tMAIN tCONST tINT tPRINT tRETURN
%token tAO tAF tPO tPF tPV tVIRGULE 
%token <nb> tNB
%token <identificateur> tID
%token tADD tSUB tMUL tDIV tEGAL
%token tIF tELSE tWHILE
%token tAND tOR tEQUI tINFEG tSUPEG tDIFF tINF tSUP
%type <nb> Expression Facteur Terme Condition Operande
%start Start
%left tOR
%left tAND
%left tEQUI tDIFF
%left tINFEG tSUPEG tINF tSUP
%nonassoc IFSEUL
%nonassoc tELSE

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
Decl :          tID tEGAL
                        {switch (type_courant) {
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
                         }}
                Expression 
                        {fprintf(output_tmp, "COP %d %d\n",
                                 ts_get_addr($1), $4);
                         compteur_asm ++;
                         ts_delete_tmp();}
              | tID     {switch (type_courant) {
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
              ;
Expression :    Facteur tADD Expression    
                        {fprintf(output_tmp, "ADD %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
              | Facteur tSUB Expression
                        {fprintf(output_tmp, "SOU %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
              | Facteur {$$ = $1;}
              ;
Facteur :       Terme tMUL Facteur
                        {fprintf(output_tmp, "MUL %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
              | Terme tDIV Facteur
                        {fprintf(output_tmp, "DIV %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
              | Terme   {$$ = $1;}
Terme :         tPO Expression tPF
                        {$$ = $2;}
              | tID     {int addr = ts_get_addr($1);
                         int tmp = ts_create_tmp();
                         fprintf(output_tmp, "COP %d %d\n", tmp, addr);
                         compteur_asm ++;
                         $$ = tmp;}
              | tNB     {int tmp = ts_create_tmp();
                         fprintf(output_tmp, "AFC %d %d\n", tmp, $1);
                         compteur_asm ++;
                         $$ = tmp;}
              ;
Instructions :  Instruction Instructions
              | Instruction
              ;
Instruction :   Affectation
              | Print
              | If
              | While
              ;
Affectation :   tID tEGAL Expression tPV
                        {int addr = ts_get_addr($1);
                         if (addr >= 0) {
                            if (ts_is_const($1) == VAR_NON_CONST) {
                                fprintf(output_tmp, "COP %d %d\n", addr, $3);
                                compteur_asm ++;
                            }
                         }
                         ts_delete_tmp();}
              ;
Print :         tPRINT tPO tPF tPV
              ;
If :            tIF Trait_Cond tAO Corps tAF     %prec IFSEUL
              | tIF Trait_Cond tAO Corps tAF tELSE
                        {fprintf(output_tmp, "JMP adresse\n");
                         compteur_asm ++;}
                tAO Corps tAF
              ;
Trait_Cond :    tPO Condition tPF
                        {fprintf(output_tmp, "JMF %d adresse\n", $2);
                         compteur_asm ++;
                         ts_delete_tmp();}
              ;
While :         tWHILE tPO Condition tPF tAO Corps tAF
              ;
Condition :     Operande tAND Condition
              | Operande tOR Condition
              | Operande {$$ = $1;}
              ;
Operande :      Expression tEQUI Expression
                        {fprintf(output_tmp, "EQU %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
              | Expression tDIFF Expression
                        {fprintf(output_tmp, "DIF %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
              | Expression tINFEG Expression
              | Expression tSUPEG Expression
              | Expression tINF Expression
                        {fprintf(output_tmp, "INF %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
              | Expression tSUP Expression
                        {fprintf(output_tmp, "SUP %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
              | Expression
                        {$$ = $1;}
              | tPO Condition tPV
                        {$$ = $2;}
              ;
Return :        tRETURN tNB tPV
              ;

%%

int main (int argc, char * argv[])
{
    int result = 0;

    // Traitement des entrees
    if (argc == 2 || argc == 3) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            printf("Fichier d'entrée non existant\n");
            result = 2;
        } else {
            if (argc == 3) {
                output = fopen(argv[2], "w");
            } else {
                output = fopen("out.asm", "w"); 
            }
            if (output == NULL) {
                printf("Erreur à l'ouverture du fichier de sortie\n");
                result = 3;
            } else {
                output_tmp = fopen("out_tmp.asm", "w+");
                if (output_tmp == NULL) {
                    printf("Erreur à l'ouverture du fichier temporaire\n");
                    result = 4;
                }
            }
        }
    } else {
        printf("\nUsage : lexgo [SOURCE] [SORTIE]\n");
        printf("Fournir au moins le fichier c source\n");
        printf("Si le fichier sortie n'est pas fini,\n");
        printf("le fichier \"out.asm\" sera cree.\n");
        result = 1;
    }

    // Execution de la compilation ssi les entrees sont correctes
    if (result == 0) {
        result = yyparse();
        completer_sauts();
    }

    fclose(yyin);
    fclose(output_tmp);
    fclose(output);

    return result;
}

yyerror (char * s)
{
    fprintf(stderr, "Ligne no %d: %s\n", yylineno, s);
}








