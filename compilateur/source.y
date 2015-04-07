%{
#include <stdio.h>
#include "compilateur.h"

extern FILE * yyin;
extern int yylineno;
%}

%union {int nb; char* identificateur;}
%token tMAIN tCONST tINT tVOID tPRINT tRETURN
%token tAO tAF tPO tPF tPV tVIRGULE 
%token <nb> tNB
%token <identificateur> tID
%token tADD tSUB tMUL tDIV tEGAL
%token tIF tELSE tWHILE
%token tAND tOR tEQUI tINFEG tSUPEG tDIFF tINF tSUP
%type <nb> Expression Facteur Terme Condition Operande Trait_Cond Get_ASM_Compt
%type <nb> Appel_Fonct
%start Start
%left tOR
%left tAND
%left tEQUI tDIFF
%left tINFEG tSUPEG tINF tSUP
%nonassoc IFSEUL
%nonassoc tELSE

%%

Start :         Prototypes Main Decl_Foncts
              | Main
              ;
Main :          tINT tMAIN tPO tPF {display_table(); niveau_courant ++;}
                Corps
                        {display_table(); ts_vider_dernier_niveau();
                         display_table(); niveau_courant --;}
              ;
Corps :         tAO Body tAF
              | Instruction
              ;
Body :          Declarations Instructions
              | Declarations
              | Instructions
              ;
Type :          tINT {type_courant = INT;}
              | tCONST tINT {type_courant = INT_CONST;}
              ;
Declarations :  L_Decl Declarations 
              | L_Decl
              ;
L_Decl :        Type Seq_Decl tPV 
              ;
Seq_Decl :      Decl tVIRGULE Seq_Decl 
              | Decl 
              ;
Decl :          tID tEGAL
                        {switch (type_courant) {
                         case INT:
                            ts_create($1, TYPE_INT,
                                      VAR_INIT, VAR_NON_CONST);
                            break;
                         case INT_CONST:
                            ts_create($1, TYPE_INT,
                                      VAR_INIT, VAR_CONST);
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
                                      VAR_NON_INIT, VAR_NON_CONST);
                            break;
                         case INT_CONST:
                            ts_create($1, TYPE_INT,
                                      VAR_NON_INIT, VAR_CONST);
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
              | tSUB Expression
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
              | Appel_Fonct
                        {$$ = $1;}
              ;
Instructions :  Instruction {display_table();} Instructions
              | Instruction {display_table();}
              ;
Instruction :   Affectation
              | Print
              | If
              | While
              | Return
              | Appel_Fonct
              | error
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
If :            tIF tPO Trait_Cond tPF Corps        %prec IFSEUL
                        {add_saut(compteur_asm + 1);}
              | tIF tPO Trait_Cond tPF Corps tELSE
                        {add_saut(compteur_asm + 2);
                         fprintf(output_tmp, "JMP adr_jmp\n");
                         compteur_asm ++;}
                Corps
                        {add_saut(compteur_asm + 1);}
              ;
Trait_Cond :    Condition
                        {fprintf(output_tmp, "JMF %d adr_jmp\n", $1);
                         compteur_asm ++;
                         ts_delete_tmp();}
              ;
While :         tWHILE tPO Get_ASM_Compt Trait_Cond tPF Corps
                        {add_saut(compteur_asm + 2);
                         fprintf(output_tmp, "JMP adr_jmp\n");
                         compteur_asm ++;
                         add_saut($3);}
              ;
Get_ASM_Compt :           {$$ = compteur_asm + 1;}
              ; 
Condition :     Operande tAND Condition
                        {fprintf(output_tmp, "AND %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
              | Operande tOR Condition
                        {fprintf(output_tmp, "OR %d %d %d\n", $1, $1, $3);
                         compteur_asm ++;
                         ts_delete_tmp();
                         $$ = $1;}
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
                        {int tmp_inf = ts_create_tmp();
                         fprintf(output_tmp, "INF %d %d %d\n", tmp_inf, $1, $3);
                         fprintf(output_tmp, "EQU %d %d %d\n", $1, $1, $3);
                         fprintf(output_tmp, "OR %d %d %d\n", $1, $1, tmp_inf);
                         compteur_asm += 3;
                         ts_delete_tmp();
                         ts_delete_tmp();
                         $$ = $1;}
              | Expression tSUPEG Expression
                        {int tmp_sup = ts_create_tmp();
                         fprintf(output_tmp, "SUP %d %d %d\n", tmp_sup, $1, $3);
                         fprintf(output_tmp, "EQU %d %d %d\n", $1, $1, $3);
                         fprintf(output_tmp, "OR %d %d %d\n", $1, $1, tmp_sup);
                         compteur_asm += 3;
                         ts_delete_tmp();
                         ts_delete_tmp();
                         $$ = $1;}
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
Prototypes :    Prototype Prototypes
              | Prototype
              ;
Prototype :     tINT tID
                        {tf_add_fonct($2, TYPE_INT);}
                tPO Params_Proto tPF tPV
              | tVOID tID
                        {tf_add_fonct($2, TYPE_VOID);}
                tPO Params_Proto tPF tPV
              ;
Params_Proto :  Param_Proto tVIRGULE Params_Proto
              | Param_Proto
              ;
Param_Proto :   Type tID
                        {switch(type_courant) {
                         case INT:
                            tf_init_param($2, TYPE_INT, VAR_CONST);
                            break;
                         case INT_CONST:
                            tf_init_param($2, TYPE_INT, VAR_NON_CONST);
                            break;
                         }}
              ;
Decl_Foncts :   Decl_Fonct Decl_Foncts
              | Decl_Fonct
              ;
Decl_Fonct :    tINT tID 
                        {tf_init_addr($2, TYPE_INT, compteur_asm);}
                tPO Params_Decl tPF Corps
              | tVOID tID
                        {tf_init_addr($2, TYPE_VOID, compteur_asm);}
                tPO Params_Decl tPF Corps
              ;
Params_Decl :   Param_Decl tVIRGULE Params_Decl
              | Param_Decl
              ;
Param_Decl :    Type tID
                        {tf_check_param($2, $1,
                                        tf_get_next_param(fonct_courante));}
              ;
Appel_Fonct :   tID
                        {niveau_courant ++;
                         fonct_courante = tf_get_position($1);}
                tPO Params_Appel tPF tPV
                        {int addr_result = 0;
                         niveau_courant --;
                         $$ = addr_result;}
              ;
Params_Appel :  Expression tVIRGULE Params_Appel
              | Expression
                        {ts_create_from_param(
                                        tf_get_next_param(fonct_courante));}
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
        printf("Si le fichier sortie n'est pas defini,\n");
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
    remove("out_tmp.asm");
    fclose(output);

    return result;
}

yyerror (char * s)
{
    fprintf(stderr, "Ligne no %d: %s\n", yylineno, s);
}








