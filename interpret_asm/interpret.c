#include "interpret.h"


// Numero de la ligne courante
int ligne = 0;


/******************************************************************************
******************* Fonctons de la table contentant le code *******************
******************************************************************************/

// Ajoute une ligne de code dans la table
void add_ligne(int cop, int op1, int op2, int op3)
{
    code[ligne][0] = cop;
    code[ligne][1] = op1;
    code[ligne][2] = op2;
    code[ligne][3] = op3;
    ligne ++;
}


// Affiche le contenu de la table des variables
void aff_vars()
{
    int i;

    printf("===================== Table variables ====================");
    for (i = 0; i < TAILLE_TABLE_VARS; i++) {
        printf("%d ", table_variables[i]);
        if (i % 10 == 0) {
            printf("\n");
        }
    }
    printf("==========================================================");
}


// Execution du code
void execute()
{
    int ligne_finale = ligne;

    ligne = 0;

    while (ligne < ligne_finale) {
        switch (code[ligne][0]) {
        case ADD:
            table_variables[code[ligne][1]] = table_variables[code[ligne][2]]
                                            + table_variables[code[ligne][3]];
            break; 
        case SOU:
            table_variables[code[ligne][1]] = table_variables[code[ligne][2]]
                                            - table_variables[code[ligne][3]];
            break;
        case MUL:
            table_variables[code[ligne][1]] = table_variables[code[ligne][2]]
                                            * table_variables[code[ligne][3]];
            break; 
        case DIV:
            table_variables[code[ligne][1]] = table_variables[code[ligne][2]]
                                            / table_variables[code[ligne][3]];
            break; 
        case COP:
            table_variables[code[ligne][1]] = table_variables[code[ligne][2]];
            break;
        case AFC:
            table_variables[code[ligne][1]] = code[ligne][2];
            break;
        case JMP:
            ligne = code[ligne][1];
            break; 
        case JMF:
            if (code[ligne][1]) {
                ligne = code[ligne][2];
            }
            break;
        case INF:
            if (table_variables[code[ligne][2]]
                < table_variables[code[ligne][3]]) {
                table_variables[code[ligne][1]] = 1;
            } else {
                table_variables[code[ligne][1]] = 0;
            }
            break; 
        case SUP:
            if (table_variables[code[ligne][2]]
                > table_variables[code[ligne][3]]) {
                table_variables[code[ligne][1]] = 1;
            } else {
                table_variables[code[ligne][1]] = 0;
            }
            break;
        case EQU:
            if (table_variables[code[ligne][2]]
                == table_variables[code[ligne][3]]) {
                table_variables[code[ligne][1]] = 1;
            } else {
                table_variables[code[ligne][1]] = 0;
            }
            break; 
        case PRI:
            printf("%d\n", code[ligne][1]);
            break;
        case AND:
            if (table_variables[code[ligne][2]]
                && table_variables[code[ligne][3]]) {
                table_variables[code[ligne][1]] = 1;
            } else {
                table_variables[code[ligne][1]] = 0;
            }
            break;
        case OR:
            if (table_variables[code[ligne][2]]
                || table_variables[code[ligne][3]]) {
                table_variables[code[ligne][1]] = 1;
            } else {
                table_variables[code[ligne][1]] = 0;
            }
            break;
        }
    }
}

