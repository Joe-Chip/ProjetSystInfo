#ifndef TABLES_H
#define TABLES_H


/******************************************************************************
********************** Définition de la table des symboles ********************
******************************************************************************/

// Taille de la table des symboles et de la table des sauts
#define TAILLE_TAB_SYMB 256
#define TAILLE_TAB_SAUTS 256

struct type_symbole {
    char * nom;
    int type;
    int is_init;
    int is_const;
    int is_global;
};

struct type_symbole table_symboles[TAILLE_TAB_SYMB];



/******************************************************************************
*********************** Definition de la table des fonctions ******************
******************************************************************************/

/*
 * Definition des constantes utilisées pour la gestion des fonctions
 */
#define MAX_PARAM_NB 10
#define TAILLE_TAB_FONCT 256


/*
 * Definiton des parametres
 */
struct t_param {
    char * nom;
    int type;
    int is_const;
};

struct type_fonction {
    char * nom;
    int adresse;
    int type_retour;
    int params_ok;
    int nb_params;
    struct t_param tab_params[MAX_PARAM_NB];
};

struct type_fonction table_fonctions[TAILLE_TAB_FONCT];


#endif
