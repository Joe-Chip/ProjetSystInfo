#ifndef TABLE_SYMB_H
#define TABLE_SYMB_H

#include <stdlib.h>
#include <string.h>

/* 
 * Definition des constantes utilisées par la table des symboles
 * Comportement par defaut : int non initialisé non constant
 */
#define TYPE_INT 0
#define VAR_NON_INIT 0
#define VAR_INIT 1
#define VAR_NON_CONST 0
#define VAR_CONST 1

/*
 * Constantes utilisées pour savoir de quel type vont être
 * les variables créées par une ligne de déclarations
 */
#define INT 0
#define INT_CONST 1

/*
 * Taille de la table des symboles
 */
#define TAILLE_TAB_SYMB 256

/* Définition de la table des symboles */
struct type_symbole {
    char * nom;
    int type;
    int is_init;
    int is_const;
    int niveau;
};

struct type_symbole table_symboles[TAILLE_TAB_SYMB];
extern int pos_symbole;

// Stocke le type des variables à créer (par default : int non constant)
extern int type_courant;

// Stocke le niveau d'appel de la fonction en cours
extern int niveau_courant;

void ts_create(char * nom, int type, int is_init, int is_const, int niveau);

void ts_init(char * nom);

int ts_addr(char * nom);

int ts_create_tmp();

void ts_delete_tmp();

#endif
