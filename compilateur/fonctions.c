#include "fonctions.h"


// Position dans la table de fonctions
int pos_fonction = 0;

// Indice de la fonction traitée, utilise lors d'un appel
int fonct_courante = 0;

/******************************************************************************
**************** Fonctions de gestion de la table de fonctions ****************
******************************************************************************/

/*
 * Fonction pour ajouter une fonction dans la table.
 * Appelee a la rencontre avec le prototype
 */
void tf_add_fonct(char * nom, int type)
{
    table_fonctions[pos_fonction].nom = strdup(nom);
    table_fonctions[pos_fonction].type_retour = type;
    table_fonctions[pos_fonction].nb_params = 0;
    pos_fonction++;
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
    table_fonctions[pos_fonction].nb_params ++;
}


/*
 * Fonction pour initialiser l'adresse de la fonction, si elle est conforme
 * a son prototype.
 * Appelee a la rencontre avec la declaration
 * Renvoie la postion de la fonction dans la table, -1 si elle est absente
 * ou non conforme
 */
int tf_init_addr(char * nom, int type, int addr)
{
    int position = -1;

    if ((position = tf_get_position(nom)) != -1) {
        if (table_fonctions[position].type == type) {
            // Si on a le bon nom et le bon type, tout va bien
            table_fonctions[pos_fonction].adresse = addr;
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
            // On a troue notre fonction, on peut sortir de la boucle
            position = i;
            i = pos_fonction;
        }
        i++;
    }
    return position
}


/*
 * Verifie que le parametre lu dans la declaration est bien conforme a
 * celui du prototype
 * Retourne PARAM_OK si conforme, PARAM_NON_CONFORME sinon
 */
int tf_check_param(char * nom, int type, struct t_param param)
{
    int verif = PARAM_OK;

    if ((strcmp(nom, param.nom) != 0) || (type != param.type)) {
        verif = PARAM_NON_CONFORME;
    }
    
    return verif;
}



/*
 * Recupere le prochain parametre a copier dans la table des symboles
 */
struct t_param tf_get_next_param(int fonction, int reset)
{
    static int params_traites;

    if (reset == RESET_NB_PARAMS_TRAITES)
        params_traites = 0;
    }
    return table_fonctions[fonction].tab_params[params_traites++];
}



