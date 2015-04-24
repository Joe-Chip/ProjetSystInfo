#ifndef INTERPRET_H
#define INTERPRET_H

#include <stdio.h>
#include <stdlib.h>

#define TAILLE_TABLE_VARS 256
#define NB_LIGNES_CODE_MAX 1000

// Definition ds constantes lies aux operateurs
#define ADD 1
#define MUL 2
#define SOU 3
#define DIV 4
#define COP 5
#define AFC 6
#define JMP 7
#define JMF 7
#define INF 8
#define SUP 9
#define EQU 10
#define PRI 11
#define AND 12
#define OR 13
#define CALL 14
#define RET 15

#define NO_OPERANDE 1000000000

// Declaration de la table utilisee pour stocker les variables
int table_variables[TAILLE_TABLE_VARS];


/******************************************************************************
******************* Définition de la table contentant le code *****************
******************************************************************************/

// Numero de la ligne courante
extern int ligne;

/*
 * Table contenant la copie du code
 * Chaque ligne de la table contient 4 cases : le code opération et
 * jusqu'a 3 operandes
 */
int code[NB_LIGNES_CODE_MAX][4];


/******************************************************************************
******************* Fonctons de la table contentant le code *******************
******************************************************************************/

// Ajoute une ligne de code dans la table
void add_ligne(int cop, int op1, int op2, int op3);

// Execution du code
void execute();

#endif
