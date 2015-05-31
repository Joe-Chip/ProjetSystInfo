#include "fonctions.h"

// Position dans la table de fonctions
int pos_fonction = 0;

// Indice de la fonction traitée, utilise lors d'un appel
int fonct_courante = 0;

// Indice de la fonction traitée, utilise en cas d'appel d'une autre
// fonction lors du traitement des parametres
int old_fonct_courante = 0;

// Indice du parametre en traitment
int params_traites;

// Flag indiquant si le return de la fonction est bien la derniere instruction
int flag_return = 0;

/******************************************************************************
**************** Fonctions de gestion de la table de fonctions ****************
******************************************************************************/

/*
 * Fonction pour ajouter une fonction dans la table.
 * Appelee a la rencontre avec le prototype
 */
int tf_add_fonct(char * nom, int type, int addr)
{
    table_fonctions[pos_fonction].nom = strdup(nom);
    table_fonctions[pos_fonction].type_retour = type;
    table_fonctions[pos_fonction].adresse = addr;
    table_fonctions[pos_fonction].params_ok = PARAMS_NON_INIT;
    table_fonctions[pos_fonction].nb_params = 0;
    pos_fonction++;

    return pos_fonction - 1;
}


/*
 * Fonction d'initialisation de la structure des parametres de la fonction
 * Appelee pour chaque parametre
 */
void tf_init_param(char * nom, int type, int is_const)
{
    int nb_param = table_fonctions[pos_fonction-1].nb_params;
    table_fonctions[pos_fonction-1].tab_params[nb_param].nom = strdup(nom);
    table_fonctions[pos_fonction-1].tab_params[nb_param].type = type;
    table_fonctions[pos_fonction-1].tab_params[nb_param].is_const = is_const;
    table_fonctions[pos_fonction-1].nb_params ++;
}


/*
 * Fonction pour initialiser l'adresse de la fonction, si sa declaration est
 * conforme a son prototype.
 * Appelee a la rencontre avec la declaration
 * Renvoie la postion de la fonction dans la table, -1 si elle est absente
 * ou non conforme
 */
int tf_init_addr(char * nom, int type, int addr)
{
    int position = -1;

    if ((position = tf_get_position(nom)) != -1) {
        if (table_fonctions[position].type_retour == type) {
            // Si on a le bon nom et le bon type, tout va bien
            table_fonctions[position].adresse = addr;
        } else {
            // Si le type n'est pas bon, on a une erreur
            position = -2;
        }
    }
    return position;
}


/*
 * Recupere la position de la fonction dont le nom est passe en argument
 */
int tf_get_position(char * nom)
{
    int position = -1;
    int i = 0;
    
    // Parcours de la table de fonctions
    while (i < pos_fonction) {
        // Parcours de la boucle jusqu'a une fonction avec le bon nom
        if (strcmp(table_fonctions[i].nom, nom) == 0) {
            // On a trouve notre fonction, on peut sortir de la boucle
            position = i;
            i = pos_fonction;
        }
        i++;
    }
    return position;
}


/*
 * Recupere l'adsresse de la fonction dans le code ASM
 */
int tf_get_addr(char * nom)
{
    return table_fonctions[tf_get_position(nom)].adresse;
}


/*
 * Fonction appelee a la fin de l'initialisation des parametres, pour indiquer
 * qu'ils ont bien etes initialises
 */
void tf_set_params_init(char * nom) 
{
    table_fonctions[tf_get_position(nom)].params_ok = PARAMS_OK;
}


/*
 * Fonction pour verifier que les parametres ont bien etes initialises
 */
int tf_check_params_init(int position)
{
    return table_fonctions[position].params_ok;
}


/*
 * Verifie que le parametre lu dans la declaration est bien conforme a
 * celui du prototype
 * Retourne PARAM_OK si conforme, PARAM_NON_CONFORME sinon
 */
int tf_check_param(char * nom, int param_type, struct t_param param)
{
    int verif = PARAM_OK;
    int type;
    int is_const;

    switch(param_type) {
    case TYPE_INT:
        type = TYPE_INT;
        is_const = VAR_NON_CONST;
        break;
    case TYPE_CONST_INT:
        type = TYPE_INT;
        is_const = VAR_CONST;
        break;
    }

    if ((strcmp(nom, param.nom) != 0) || (type != param.type)
        || (is_const != param.is_const)) {
        verif = PARAM_NON_CONFORME;
    }
    
    return verif;
}


/*
 * Retourne le nombr de parametres de la fonction
 */
int tf_get_nb_params(int fonction) {
    return table_fonctions[fonction].nb_params;
}

/*
 * Recupere le prochain parametre a copier dans la table des symboles
 */
struct t_param tf_get_next_param(int fonction)
{
    return table_fonctions[fonction].tab_params[params_traites++];
}


/*
 * Affiche la table des fonctions. Utilisee pour le debug
 */
void display_table_fonct()
{
    int i, j;

    printf("\n==================TABLE DES FONCTIONS=================\n");
    for (i = 0; i < pos_fonction; i++) {
        printf("Fonction %d, %s : Addr : %d, Type : %d, Nb params : %d\n",
               i, table_fonctions[i].nom, table_fonctions[i].adresse,
               table_fonctions[i].type_retour, table_fonctions[i].nb_params);
        for (j = 0; j < table_fonctions[i].nb_params; j++) {
            printf("Param %d, %s : Type : %d, CONST : %d\n", j,
                   table_fonctions[i].tab_params[j].nom,
                   table_fonctions[i].tab_params[j].type,
                   table_fonctions[i].tab_params[j].is_const);
        }
    printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    }
    printf("======================================================\n\n");

}

