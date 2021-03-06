#ifndef INTERPRET_H
#define INTERPRET_H

#include <stdio.h>
#include <stdlib.h>

// Les derniers éléments servent de base pointer et registre pour l'adresse retour
#define TAILLE_TABLE_VARS 258
#define BASE_POINTER 256
#define REG_RETOUR 257
// Pas utile d'avoir plus pour ce projet
#define NB_LIGNES_CODE_MAX 1000

// Definition ds constantes lies aux operateurs
#define ADD 1
#define MUL 2
#define SOU 3
#define DIV 4
#define COP 5
#define AFC 6
#define PRI 7
#define JMP 8
#define JMF 9
#define INF 10
#define SUP 11
#define EQU 12
#define AND 13
#define OR 14
#define CALL 15
#define RET 16
#define PUSH 17
#define POP 18

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

// Affiche le contenu de la table des variables
void aff_vars();

// Execution du code
void execute();

#endif
