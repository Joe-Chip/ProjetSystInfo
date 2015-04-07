#ifndef FONCTIONS_H
#define FONCTIONS_H


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compilateur.h"

/*
 * Definition des constantes utilisées pour la gestion des fonctions
 */
#define MAX_PARAM_NB 10
#define TAILLE_TAB_FONCT 256

// Constante uilisees pour la verification de la declaration des parametres
#define PARAM_NON_CONFORME 0
#define PARAM_NON_OK 1

// Traitement des variables statiques
#define RESET_NB_PARAMS_TRAITES 1

/*
 * Definiton des parametres
 */
struct t_param {
    char * nom;
    int type;
    int is_const;
};

/*
 * Definition de la structure associée aux fonctions
 */
struct type_fonction {
    char * nom;
    int adresse;
    int type_retour;
    int nb_params;
    struct t_param tab_params[MAX_PARAM_NB];
};

struct type_fonction table_fonctions[TAILLE_TAB_FONCT];
extern int pos_fonction;

// Indice de la fonction traitée, utilise lors d'un appel
extern int fonct_courante;


/******************************************************************************
**************** Fonctions de gestion de la table de fonctions ****************
******************************************************************************/

/*
 * Fonction pour ajouter une fonction dans la table.
 * Appelee a la rencontre avec le prototype
 */
void tf_add_fonct(char * nom, int type);

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
 */
int tf_get_position(char * nom);

/*
 * Verifie que le parametre lu dans la declaration est bien conforme a
 * celui du prototype
 * Retourne PARAM_OK si conforme, PARAM_NON_CONFORME sinon
 */
int tf_check_param(char * nom, int type, struct t_param param);


/*
 * Recupere le prochain parametre a copier dans la table des symboles
 */
struct t_param tf_get_next_param(int fonction, int reset);



#endif
