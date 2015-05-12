#ifndef COMPILATEUR_H
#define COMPILATEUR_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fonctions.h"
#include "tables.h"

/* 
 * Definition des constantes utilisées par la table des symboles
 * Comportement par defaut : int non initialisé non constant
 */
#define TYPE_VOID 0
#define TYPE_INT 1
#define TYPE_CONST_VOID 100
#define TYPE_CONST_INT 101
#define ADD_CONST 100
#define VAR_NON_INIT 0
#define VAR_INIT 1
#define VAR_NON_CONST 0
#define VAR_CONST 1


// Taille max d'une ligne d'instruction assembleur
#define TAILLE_LIGNE 80

/*
 * Descripteur du ficher de sortie. Le fichier tmp stocke le premier passage,
 * qui sera recopié en remplaçant toutes les occurences du mot "adresse"
 * par les adresses effectives
 */
extern FILE * output_tmp;
extern FILE * output;

// Position dans la table des symboles
extern int pos_symbole;

// Flag indiquant si le main a été rencontré
extern int main_ok;

// Chaine main, sert à identifier le main
extern char tab_main[5];

// Stocke le type des variables à créer (par default : int non constant)
extern int type_courant;

// Stocke le niveau d'appel de la fonction en cours
extern int niveau_courant;

// Compteur du nombre de lignes ecrites en assembleur
extern int compteur_asm;

// Table des sauts : contient l'adresse de destination de chaque saut
int table_sauts[TAILLE_TAB_SAUTS];
extern int pos_tab_saut;


/******************************************************************************
**************** Fonctions de gestion de la table des symboles ****************
******************************************************************************/

/*
 * Crée une variable au sommet de la table des symboles
 */
void ts_create(char * nom, int type, int is_init, int is_const);

/*
 * La variable dont le nom est passé en argument se voit initialisée :
 * le champ is_init reçoit la valeur VAR_INIT
 */
void ts_init(char * nom);

/*
 * Retourne l'adresse dans la table de la variable dont le nom est passé
 * en argument. Retourne -1 su la variable n'est pas dans la table
 */
int ts_get_addr(char * nom);

/*
 * Retourne VAR_CONST si la variable est constante, VAR_NON_CONST sinon
 */
int ts_is_const(char * nom);

/*
 * Retire toutes les variables du niveau courant de la table des symboles
 * Utilise en sortie d'un bloc
 */
void ts_vider_dernier_niveau();

/*
 * Crée une variable temporaire en haut de la table des symboles
 */
int ts_create_tmp();

/*
 * Supprime la derniere variable temporaire
 */
void ts_delete_tmp();

/*
 * Cree une variable à partir d'un parametre de fonction
 */
int ts_create_from_param(struct t_param param);

/*
 * Affiche la table des symboles. Utilisee pour le debug
 */
void display_table_symb();


/******************************************************************************
**************** Fonctions de gestion de la table des sauts *******************
******************************************************************************/

// Ajoute un saut dans la table
void add_saut(int destination);

// Parcourt le fichier de sortie pour completer les sauts
void completer_sauts ();

// Affichage de la table des sauts, utilis pour le debug
void afficher_table_sauts();
#endif
