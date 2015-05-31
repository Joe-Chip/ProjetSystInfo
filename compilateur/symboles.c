#include "symboles.h"

// Initialisation des pointeurs sur le fichier de sortie
FILE * output_tmp = NULL;
FILE * output = NULL;

// Indique la première case vide dans la table des symboles
int pos_symbole = 0;

// Compte le nombre de variabes globales
int compteur_vars_glo = 0;

// Compte le nombre d'instructions pour les variabes globales
int compteur_inst_vars_glo;

// Stocke le pointeur indiquant le début des variables locales
int base_pointer = 0;

// Nom du base pointer utilisé par la table des symboles
char nom_res[26] = "ceci_est_la_valeur_retour";

// Nom du base pointer utilisé par la table des symboles
char nom_adr_ret[26] = "ceci_est_l'adresse_retour";

// Nom du base pointer utilisé par la table des symboles
char nom_bp[25] = "ceci_est_le_base_pointer";

// Stocke le type des variables à créer (par defaut : int non constant)
int type_courant = TYPE_INT;

// Flag indquant les variables gobales (passe à 0 une fois qu'elles sont finies)
int vars_globales = 1;

// Compteur du niveau du bloc de code actuel
int niveau_courant = 0;


/******************************************************************************
**************** Fonctions de gestion de la table des symboles ****************
******************************************************************************/


/*
 * Crée une variable a sommet de la table des symboles
 */
int ts_create(char * nom, int type, int is_init, int is_const)
{
    int adr_var;

    // Si la table des symboles est pleine, on renvoie une erreur
    if (pos_symbole + compteur_vars_glo == TAILLE_TAB_SYMB) {
        adr_var = TABLE_SYMBOLE_PLEINE + base_pointer;
    } else {

        if (vars_globales) {
            compteur_vars_glo ++;
            adr_var = TAILLE_TAB_SYMB - compteur_vars_glo;
        } else {
            adr_var = pos_symbole;
            pos_symbole++;
        }

        table_symboles[adr_var].nom = strdup(nom);
        table_symboles[adr_var].type = type;
        table_symboles[adr_var].is_init = is_init;
        table_symboles[adr_var].is_const = is_const;
        table_symboles[adr_var].niveau = niveau_courant;
    }

    return adr_var - base_pointer;
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
 * en argument. Retourne -1 si la variable n'est pas dans la table
 */
int ts_get_addr(char * nom)
{
    int i;
    int addr = -1 - base_pointer;

    // Parcours des variales locales
    for (i = 0; i < pos_symbole; i++) {
        if (strcmp(table_symboles[i].nom, nom) == 0) {
            addr = i - base_pointer;
        }
    }
    // Si la variabe n'est pas locale
    if (addr == -1 - base_pointer) {
        // Parcours des variables globales
        for (i = TAILLE_TAB_SYMB - compteur_vars_glo; i < TAILLE_TAB_SYMB; i++) {
            if (strcmp(table_symboles[i].nom, nom) == 0) {
                addr = i;
            }
        }
    }
    return addr;
}


/*
 * Retourne VAR_CONST si la variable est constante, VAR_NON_CONST sinon
 */
int ts_is_const(char * nom)
{
    int addr = ts_get_addr(nom);
    // Si la variable est locale, on récupère sa véritable adresse
    if (addr < TAILLE_TAB_SYMB - compteur_vars_glo) {
        addr = addr + base_pointer;
    }
    return table_symboles[addr].is_const;
}

/*
 * Retourne VAR_INIT si la variable est initialisee, VAR_NON_INIT sinon
 */
int ts_is_init(char * nom)
{
    int addr = ts_get_addr(nom);
    // Si la variable est locale, on récupère sa véritable adresse
    if (addr < TAILLE_TAB_SYMB - compteur_vars_glo) {
        addr = addr + base_pointer;
    }
    return table_symboles[addr].is_init;
} 


/*
 * Retire toutes les variables du niveau courant de la table des symboles
 * Utilise en sortie d'un corps de fonction
 */
void ts_vider_dernier_niveau()
{
    int i;

    for (i = pos_symbole - 1; i >= base_pointer; i--) {
        if (table_symboles[i].niveau == niveau_courant) {
            ts_delete_var();
        }
    }
    display_table_symb();
}


/*
 * Crée une variable temporaire en haut de la table des symboles
 */
int ts_create_tmp()
{
    int adr_var, flag_glo;
    char * nom;
    nom = malloc(2);
    strcpy(nom, " ");

    // Les variables temporaires ne sont jamais globales
    flag_glo = vars_globales;
    vars_globales = 0;
    adr_var = ts_create(nom, TYPE_INT, VAR_INIT, VAR_NON_CONST);
    vars_globales = flag_glo;
    return adr_var;
}

/*
 * Supprime la derniere variable
 */
void ts_delete_var()
{
    pos_symbole --;
    free(table_symboles[pos_symbole].nom);
    table_symboles[pos_symbole].type = TYPE_VOID;
    table_symboles[pos_symbole].is_init = VAR_NON_INIT;
    table_symboles[pos_symbole].is_const = VAR_NON_CONST;
    table_symboles[pos_symbole].niveau = 0;
}


/*
 * Cree une variable à partir d'un parametre de fonction
 */
int ts_create_from_param(struct t_param param)
{
    return ts_create(param.nom, param.type, VAR_INIT, param.is_const);
}


/*
 * Affiche la table des symboles. Utilisee pour le debug
 */
void display_table_symb()
{
    int i;

    printf("\n==================TABLE DES SYMBOLES==================\n");
    for (i = 0; i < pos_symbole; i++) {
        printf("Var %d : %s, Type : %d, INIT : %d, CONST : %d, Niveau : %d\n",
               i - base_pointer, table_symboles[i].nom, table_symboles[i].type,
               table_symboles[i].is_init, table_symboles[i].is_const,
               table_symboles[i].niveau); 
    }
    printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    for (i = TAILLE_TAB_SYMB - compteur_vars_glo; i < TAILLE_TAB_SYMB; i++) {
        printf("Var %d : %s, Type : %d, INIT : %d, CONST : %d, Niveau : %d\n",
               i, table_symboles[i].nom, table_symboles[i].type,
               table_symboles[i].is_init, table_symboles[i].is_const,
               table_symboles[i].niveau);
    }
    printf("======================================================\n\n");
}

