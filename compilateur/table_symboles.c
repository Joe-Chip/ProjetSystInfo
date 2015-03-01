#include "table_symboles.h"

// Indique la positiion actuelle dans la table des symboles
int pos_symbole = 0;

// Stocke le type des variables à créer (par default : int non constant)
int type_courant = INT;

// Stocke le niveau d'appel de la fonction en cours
int niveau_courant = 0;



void ts_create(char * nom, int type, int is_init,
               int is_const, int niveau)
{
    table_symboles[pos_symbole].nom = malloc(strlen(nom)+1);
    strcpy(table_symboles[pos_symbole].nom, nom);
    table_symboles[pos_symbole].type = type;
    table_symboles[pos_symbole].is_init = is_init;
    table_symboles[pos_symbole].is_const = is_const;
    table_symboles[pos_symbole].niveau = niveau;
    pos_symbole++;
}

void ts_init(char * nom)
{
    table_symboles[ts_addr(nom)].is_init = VAR_INIT;
}

int ts_addr(char * nom)
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

void ts_delete_tmp()
{
    pos_symbole --;
    free(table_symboles[pos_symbole].nom);
    table_symboles[pos_symbole].is_init = VAR_NON_INIT;
}



