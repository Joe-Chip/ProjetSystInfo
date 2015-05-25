#ifndef FONCTIONS_H
#define FONCTIONS_H


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compilateur.h"
#include "tables.h"


// Constante uilisees pour la verification de la declaration des parametres
#define PARAM_NON_CONFORME 0
#define PARAM_OK 1
#define PARAMS_NON_INIT 2
#define PARAMS_OK 3

// Position dans la table de fonctions
extern int pos_fonction;

// Indice de la fonction traitée, utilise lors d'un appel
extern int fonct_courante;

// Indice du parametre en traitment
extern int params_traites;

/******************************************************************************
**************** Fonctions de gestion de la table de fonctions ****************
******************************************************************************/

/*
 * Fonction pour ajouter une fonction dans la table.
 * Appelee a la rencontre avec le prototype
 * Renvoie la position de la fnction dans la table
 */
int tf_add_fonct(char * nom, int type, int addr);

/*
 * Fonction d'initialisation des parametres
 */
void tf_init_param(char * nom, int type, int is_const);

/*
 * Fonction pour initialiser l'adresse de la fonction, si elle est conforme
 * a son prototype.
 * Appelee a la rencontre avec la declaration
 * Renvoie la postion de la fonction dans la table, -1 si elle est absente
 * ou non conforme
 */
int tf_init_addr(char * nom, int type, int addr);

/*
 * Recupere la position de la fonction dont le nom est passe en argument
 * Renvoie -1 si la fonction n'est pas présente dans la table
 */
int tf_get_position(char * nom);

/*
 * Recupere l'adsresse de la fonction dans le code ASM
 */
int tf_get_addr(char * nom);

/*
 * Fonction appelee a la fin de l'initialisation des parametres, pour indiquer
 * qu'ils ont bien etes initialises
 */
void tf_set_params_init(char * nom);

/*
 * Fonction pour verifier que les parametres ont bien etes initialises
 */
int tf_check_params_init(int position);

/*
 * Verifie que le parametre lu dans la declaration est bien conforme a
 * celui du prototype
 * Retourne PARAM_OK si conforme, PARAM_NON_CONFORME sinon
 */
int tf_check_param(char * nom, int type, struct t_param param);


/*
 * Recupere le prochain parametre a copier dans la table des symboles
 */
struct t_param tf_get_next_param(int fonction);


/*
 * Affiche la table des fonctions. Utilisee pour le debug
 */
void display_table_fonct();

#endif
