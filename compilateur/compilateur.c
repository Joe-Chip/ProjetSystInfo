#include "compilateur.h"

// Initialisation des pointeurs sur le fichier de sortie
FILE * output_tmp = NULL;
FILE * output = NULL;

// Indique la positiion actuelle dans la table des symboles
int pos_symbole = 0;

// Flag indiquant si le main a été rencontré
int main_ok = 0;

// Chaine main, sert à identifier le main
char tab_main[5] = "main";

// Stocke le type des variables à créer (par default : int non constant)
int type_courant = TYPE_INT;

// Stocke le niveau d'appel de la fonction en cours
int niveau_courant = 0;

// Compteur du nombre de lignes ecrites en assembleur
int compteur_asm = 0;

// Indique la position actuelle dans la table des sauts
int pos_tab_saut = 0;



/******************************************************************************
**************** Fonctions de gestion de la table des symboles ****************
******************************************************************************/


/*
 * Crée une variable a sommet de la table des symboles
 */
void ts_create(char * nom, int type, int is_init, int is_const)
{
    table_symboles[pos_symbole].nom = strdup(nom);
    table_symboles[pos_symbole].type = type;
    table_symboles[pos_symbole].is_init = is_init;
    table_symboles[pos_symbole].is_const = is_const;
    table_symboles[pos_symbole].niveau = niveau_courant;
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
    while (i >= 0 && addr == -1) {
        if (table_symboles[i].niveau == niveau_courant
            || table_symboles[i].niveau == niveau_courant) {
            if (strcmp(table_symboles[i].nom, nom) == 0) {
                addr = i;
            }
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
 * Retire toutes les variables du niveau courant de la table des symboles
 * Utilise en sortie d'un bloc
 */
void ts_vider_dernier_niveau()
{
    int i = pos_symbole - 1;

    while (table_symboles[i].niveau == niveau_courant) {
        free(table_symboles[i].nom);
        table_symboles[i].type = TYPE_VOID;
        table_symboles[i].is_init = VAR_NON_INIT;
        table_symboles[i].is_const = VAR_NON_CONST;
        table_symboles[i].niveau = 0;
        i --;
        pos_symbole --;
    }
}


/*
 * Crée une variable temporaire en haut de la table des symboles
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
 * Cree une variable à partir d'un parametre de fonction
 */
int ts_create_from_param(struct t_param param)
{
    table_symboles[pos_symbole].nom = strdup(param.nom);
    table_symboles[pos_symbole].type = param.type;
    table_symboles[pos_symbole].is_init = VAR_INIT;
    table_symboles[pos_symbole].is_const = param.is_const;
    table_symboles[pos_symbole].niveau = niveau_courant;
    pos_symbole++;

    return pos_symbole - 1;
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
               i, table_symboles[i].nom, table_symboles[i].type,
               table_symboles[i].is_init, table_symboles[i].is_const,
               table_symboles[i].niveau); 
    }
    printf("======================================================\n\n");
}



/******************************************************************************
**************** Fonctions de gestion de la table des saut ********************
******************************************************************************/

// Ajoute un saut dans la table
void add_saut(int destination)
{
    table_sauts[pos_tab_saut] = destination;
    pos_tab_saut ++;
}

// Parcourt le fichier de sortie pour completer les sauts
void completer_sauts ()
{
    int jump_traites = 0;
    int char_cops, taille_a_copier, adr_fonct;
    char * ligne, * adr_jump, *appel_fonct;
    char adr_jmp[] = "adr_jmp";
//    char adr_fct[] = "adr_fct";
    char call[] = "CALL";

    ligne = malloc(TAILLE_LIGNE * sizeof(char));

    // Retour au debut du fichier temporaire
    rewind(output_tmp);

    ligne = fgets(ligne, TAILLE_LIGNE, output_tmp);
    
    // Recopie dans le ficher de sortie
    while (ligne != NULL) {
        adr_jump = strstr(ligne, adr_jmp);
        appel_fonct = strstr(ligne, call);

        // En remplacant les sauts et appels de fonction par l'adresse
        if (adr_jump != NULL) {
            // Copie de la partie à preserver
            taille_a_copier = (int) (adr_jump - ligne);
            for (char_cops = 0; char_cops < taille_a_copier; char_cops ++) {
                fputc(ligne[char_cops], output);
            }
            // Ajout de l'adresse de saut
            fprintf(output, "%d\n", table_sauts[jump_traites++]);
        } else if (appel_fonct != NULL) {
            // Copie de l'appel à CALL
            taille_a_copier = 5;
            for (char_cops = 0; char_cops < taille_a_copier; char_cops ++) {
                fputc(ligne[char_cops], output);
            }
            // Ajout de l'adresse de la fonction
            appel_fonct = strdup(ligne + 5);
            fprintf(output, "%d\n", tf_get_addr(appel_fonct));
        } else {
            fputs(ligne, output);
        }
        ligne = fgets(ligne, TAILLE_LIGNE, output_tmp);
    }
}


// Affichage de la table des sauts, utilis pour le debug
void afficher_table_sauts()
{
    int i;
    
    printf("\n====================TABLE DES SAUTS===================\n");
    for (i = 0; i < pos_tab_saut; i++) {
        printf("Saut no %d : vers %d\n", i, table_sauts[i]);
    }
    printf("======================================================\n\n");
}

