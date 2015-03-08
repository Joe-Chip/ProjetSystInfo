#include "compilateur.h"

// Initialisation du pointeursur le fichier de sortie
FILE * output = NULL;

// Indique la positiion actuelle dans la table des symboles
int pos_symbole = 0;

// Stocke le type des variables à créer (par default : int non constant)
int type_courant = INT;

// Stocke le niveau d'appel de la fonction en cours
int niveau_courant = 0;

// Compteur du nombre de lignes ecrites en assembleur
int compteur_asm = 0;

// Indique la position actuelle dans la table des sauts
int pos_tab_saut = 0;

/*
 * Crée une variable a sommet de la table des symboles
 */
void ts_create(char * nom, int type, int is_init,
               int is_const, int niveau)
{
    table_symboles[pos_symbole].nom = strdup(nom);
    table_symboles[pos_symbole].type = type;
    table_symboles[pos_symbole].is_init = is_init;
    table_symboles[pos_symbole].is_const = is_const;
    table_symboles[pos_symbole].niveau = niveau;
    pos_symbole++;
}

/*
 * La variable dont le nom est passé en argument se voit initialisée :
 * le champ is_init reçoit la valeur VAR_INIT
 */
void ts_init(char * nom)
{
    table_symboles[ts_get_addr(nom)].is_init = VAR_INIT;
}

/*
 * Retourne l'adresse dans la table de la variable dont le nom est passé
 * en argument. Retourne -1 su la variable n'est pas dans la table
 */
int ts_get_addr(char * nom)
{
    int i = pos_symbole - 1;
    int addr = -1;
    while (i >= 0 && addr == -1 && table_symboles[i].niveau == niveau_courant) {
        if (strcmp(table_symboles[i].nom, nom) == 0) {
            addr = i;
        }
        i--;
    }
    return addr;
}


/*
 * Retourne VAR_CONST si la variable est constante, VAR_NON_CONST sinon
 */
int ts_is_const(char * nom)
{
    return table_symboles[ts_get_addr(nom)].is_const;
}

/*
 * Crée ue variable temporaire en haut de la table des symboles
 */
int ts_create_tmp()
{
    table_symboles[pos_symbole].nom = malloc(2);
    strcpy(table_symboles[pos_symbole].nom, " ");
    table_symboles[pos_symbole].type = TYPE_INT;
    table_symboles[pos_symbole].is_init = VAR_INIT;
    table_symboles[pos_symbole].is_const = VAR_NON_CONST;
    table_symboles[pos_symbole].niveau = niveau_courant;
    pos_symbole++;
    return pos_symbole - 1;
}

/*
 * Supprime la derniere variable temporaire
 */
void ts_delete_tmp()
{
    pos_symbole --;
    free(table_symboles[pos_symbole].nom);
    table_symboles[pos_symbole].is_init = VAR_NON_INIT;
}

/*
 * Affiche la table des symboles. Utilisee pour le debug
 */
void display_table()
{
    int i;

    printf("\n==================TABLE DES SYMBOLES==================\n");
    for (i = 0; i < pos_symbole; i++) {
        printf("Var %d : %s, Type : %d, INIT : %d, CONST : %d, Niveau : %d\n",
               i, table_symboles[i].nom, table_symboles[i].type,
               table_symboles[i].is_init, table_symboles[i].is_const,
               table_symboles[i].niveau); 
    }
    printf("======================================================\n\n");
}



