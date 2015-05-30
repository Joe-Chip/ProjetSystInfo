%{
#include <stdio.h>
#include "compilateur.h"

extern FILE * yyin;
extern int yylineno;
int yydebug=1;
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
%type <nb> Appel_Fonct Type Create_Symb
%start Start
%left tOR
%left tAND
%left tEQUI tDIFF
%left tINFEG tSUPEG tINF tSUP
%nonassoc IFSEUL
%nonassoc tELSE

%%

Start           :   {// Si cette valeur n'a pas change a la fin -> pas de main
                     table_sauts[0] = 0;}
                  Vars_Globales
                ;
Vars_Globales   : L_Decl Vars_Globales
                | Prototypes
                ;
Prototypes      : Prototype tPV Prototypes
                | Globales
                ;
Globales        : Inst_Globales
                    {display_table_fonct();
                     // Verification que le main a bien ete rencontre
                     if (table_sauts[0] == 0) {
                        yyerror("Pas de main");
                     }}
                ;
Inst_Globales   : Inst_Globale Inst_Globales
                | Inst_Globale
                ;
Inst_Globale    : Decl_Fonct
                | Main
                ;
Main            : Type_Const tMAIN tPO tPF
                    {// Les variables ne sont plus globales
                     vars_globales = 0;
                     base_pointer = pos_symbole;
                     // Vérification du type du main
                     if (type_courant != TYPE_INT) {
                        yyerror("Type main incorrect");
                     }
                     // Initialisation du saut vers le main
                     table_sauts[0] = compteur_asm + 1;
                     // Comptage du nombre d'instructions avant le saut
                     compteur_vars_glo = ts_compter_variables_globales();}
                  Corps
                    {ts_vider_dernier_niveau();
                     base_pointer = 0;}
                ;
Corps           : tAO Body tAF
                | Instruction
                ;
Body            : Declarations Instructions
                | Declarations
                | Instructions
                ;
Type_Const      : Type {type_courant = $1;}
                | tCONST Type {type_courant = $2 + ADD_CONST;}
                ;
Type            : tINT {$$ = TYPE_INT;}
                | tVOID {$$ = TYPE_VOID;}
                ;
Declarations    : L_Decl Declarations 
                | L_Decl
                ;
L_Decl          : Type_Const Seq_Decl tPV {display_table_symb();} 
                ;
Seq_Decl        : Decl tVIRGULE Seq_Decl 
                | Decl 
                ;
Decl            : tID tEGAL
                    {switch (type_courant) {
                     case TYPE_INT:
                        ts_create($1, TYPE_INT,
                                  VAR_INIT, VAR_NON_CONST);
                            break;
                     case TYPE_CONST_INT:
                        ts_create($1, TYPE_INT,
                                  VAR_INIT, VAR_CONST);
                        break;
                     }}
                  Expression 
                    {fprintf(output_tmp, "COP %d %d\n",
                             ts_get_addr($1), $4);
                     compteur_asm ++;
                     ts_delete_tmp();}
                | tID
                    {switch (type_courant) {
                     case TYPE_INT:
                        ts_create($1, TYPE_INT,
                                  VAR_NON_INIT, VAR_NON_CONST);
                        break;
                     case TYPE_CONST_INT:
                        ts_create($1, TYPE_INT,
                                  VAR_NON_INIT, VAR_CONST);
                        break;
                     }}
                ;
Expression      : Facteur tADD Expression    
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
Facteur         : Terme tMUL Facteur
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
Terme           : tPO Expression tPF
                    {$$ = $2;}
                | tSUB Expression
                    {$$ = $2;}
                | tID
                    {int addr = ts_get_addr($1);
                     int tmp = ts_create_tmp();
                     fprintf(output_tmp, "COP %d %d\n", tmp, addr);
                     compteur_asm ++;
                     $$ = tmp;}
                | tNB
                    {int tmp = ts_create_tmp();
                     fprintf(output_tmp, "AFC %d %d\n", tmp, $1);
                     compteur_asm ++;
                     $$ = tmp;}
                | Appel_Fonct
                    {$$ = $1;}
                ;
Instructions    : Instruction Instructions
                | Instruction
                ;
Instruction     : Affectation
                | Print
                | If
                | While
                | Return
                | Appel_Fonct
                    {// Nettoyage apres appel de fonction
                     ts_delete_tmp();
                     ts_delete_tmp();
                     ts_delete_tmp();}
                | error
                ;
Affectation     : tID tEGAL Expression tPV
                    {int addr = ts_get_addr($1);
                     if (addr == -1) {
                        yyerror("La variable n'existe pas" );
                     } else {
                        if (ts_is_const($1) == VAR_NON_CONST) {
                            fprintf(output_tmp, "COP %d %d\n", addr, $3);
                            compteur_asm ++;
                        }
                     }
                     ts_delete_tmp();
                     // Flag retour
                     flag_return = 0;}
                ;
Print           : tPRINT tPO Expression tPF tPV
                    {fprintf(output_tmp, "PRI %d\n", $3);
                     compteur_asm ++;
                     // Flag retour
                     flag_return = 0;}
                ;
If              : tIF tPO Trait_Cond tPF Corps        %prec IFSEUL
                    {add_saut(compteur_asm + 1);
                     // Flag retour
                     flag_return = 0;}
                | tIF tPO Trait_Cond tPF Corps tELSE
                    {add_saut(compteur_asm + 2);
                     fprintf(output_tmp, "JMP adr_jmp\n");
                     compteur_asm ++;}
                  Corps
                    {add_saut(compteur_asm + 1);
                     // Flag retour
                     flag_return = 0;}
                ;
Trait_Cond      : Condition
                    {fprintf(output_tmp, "JMF %d adr_jmp\n", $1);
                     compteur_asm ++;
                     ts_delete_tmp();}
                ;
While           : tWHILE tPO Get_ASM_Compt Trait_Cond tPF Corps
                    {add_saut(compteur_asm + 2);
                     fprintf(output_tmp, "JMP adr_jmp\n");
                     compteur_asm ++;
                     add_saut($3);
                     // Flag retour
                     flag_return = 0;}
                ;
Get_ASM_Compt   :   {$$ = compteur_asm + 1;}
                ; 
Condition       : Operande tAND Condition
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
Operande        : Expression tEQUI Expression
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
                | tPO Condition tPF
                    {$$ = $2;}
                ;
Return          : tRETURN Expression tPV
                    {fprintf(output_tmp, "COP %d %d\n", -2, $2);
                     fprintf(output_tmp, "RET\n");
                     compteur_asm += 2;
                     ts_delete_tmp();
                     // Flag retour
                     flag_return = 1;}
                ;
Prototype       : Type_Const tID
                    {if (tf_get_position($2) == -1) {
                        // Si cette foncction n'est pas dans la table -> ajout
                        fonct_courante = tf_add_fonct($2, type_courant,
                                                      compteur_asm + 1);
                     } else {
                        // Si elle est présente -> mise à jour de l'adresse
                        tf_init_addr($2, type_courant, compteur_asm + 1);
                     }
                     params_traites = 0;
                     // Les variables ne sont plus globales
                     vars_globales = 0;}
                  Params_Proto_Pt
                    {tf_set_params_init($2);}
                ;
Params_Proto_Pt : tPO Params_Proto tPF
                | tPO tPF
                ;
Params_Proto    : Param_Proto tVIRGULE Params_Proto
                | Param_Proto
                ;
Param_Proto     : Type_Const tID
                    {if (tf_check_params_init(fonct_courante)
                         == PARAMS_NON_INIT) {
                        // On est un prototype ou la déclaration directe
                        switch(type_courant) {
                        case TYPE_INT:
                            tf_init_param($2, TYPE_INT, VAR_NON_CONST);
                            break;
                        case TYPE_CONST_INT:
                            tf_init_param($2, TYPE_INT, VAR_CONST);
                            break;
                        }
                     } else {
                        // On a deja vu un proto, verification de la coherence
                        if (tf_check_param($2, type_courant,
                                           tf_get_next_param(fonct_courante))
                            == PARAM_NON_CONFORME) {
                            yyerror("Erreur parametre");
                        }
                     }}
                ;
Decl_Fonct      : Prototype 
                    {int i, adr_param;
                     params_traites = 0;
                     for (i = 0; i < tf_get_nb_params(fonct_courante); i++) {
                        adr_param = ts_create_from_param(
                                        tf_get_next_param(fonct_courante));
                     }
                     base_pointer = pos_symbole;}
                  Corps
                    {if (!flag_return) {
                        // Si la derniere instruction n'est pas un return
                        fprintf(output_tmp, "RET\n");
                     }
                     ts_vider_dernier_niveau();
                     base_pointer = 0;}
                ;
Appel_Fonct     : tID
                    {fonct_courante = tf_get_position($1);}
                  Params_Appel_Pt tPV
                    {// Variable temporaire pour le résultat
                     int addr_result = ts_create_tmp();
                     // Variable temporaire pour l'adresse de retour
                     int addr_retour = ts_create_tmp();
                     fprintf(output_tmp, "COP %d %d\n",
                             addr_retour, compteur_asm + 4);
                     // Sauvegarde du base pointer
                     ts_create(nom_bp, TYPE_INT, VAR_INIT, VAR_CONST);
                     fprintf(output_tmp, "COP BP %d\n", base_pointer);
                     // Appel de la fonction
                     fprintf(output_tmp, "CALL %s\n", $1);
                     compteur_asm += 3;
                     $$ = addr_result;
                     // Flag retour
                     flag_return = 0;}
                ;
Params_Appel_Pt : tPO Params_Appel tPF
                | tPO tPF
                ;
Params_Appel    : Param_Appel tVIRGULE Params_Appel
                | Param_Appel
                ;
Param_Appel     : Create_Symb Expression
                    {fprintf(output_tmp, "COP %d %d\n", $1, $2);
                     compteur_asm ++;
                     ts_delete_tmp();}
                ;
Create_Symb     :   {$$ = ts_create_from_param(
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








