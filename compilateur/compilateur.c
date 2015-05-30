#include "compilateur.h"

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

// Compteur du nombre de lignes ecrites en assembleur
int compteur_asm = 0;

// Indique la position actuelle dans la table des sauts
// On commence à 1, le premier saut du programme va obligatoirement au main
int pos_tab_saut = 1;



/******************************************************************************
**************** Fonctions de gestion de la table des symboles ****************
******************************************************************************/


/*
 * Crée une variable a sommet de la table des symboles
 */
int ts_create(char * nom, int type, int is_init, int is_const)
{
    int adr_var;

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
    table_symboles[adr_var].is_global = vars_globales;

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
    return table_symboles[ts_get_addr(nom)].is_const;
}

/*
 * Retourne VAR_INIT si la variable est constante, VAR_NON_INIT sinon
 */
int ts_is_init(char * nom)
{
    printf("%s : %d\n", nom, table_symboles[ts_get_addr(nom)].is_init);
    return table_symboles[ts_get_addr(nom)].is_init;
} 


/*
 * Retire toutes les variables du niveau courant de la table des symboles
 * Utilise en sortie d'un bloc
 */
void ts_vider_dernier_niveau()
{
    int i;
    int pos_symbole_tmp = pos_symbole;

    for (i = 0; i < pos_symbole; i++) {
        if (table_symboles[i].is_global == 0) {
            free(table_symboles[i].nom);
            table_symboles[i].type = TYPE_VOID;
            table_symboles[i].is_init = VAR_NON_INIT;
            table_symboles[i].is_const = VAR_NON_CONST;
            pos_symbole_tmp --;
        }
    }
    pos_symbole = pos_symbole_tmp;
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
    flag_glo = vars_globales;
    vars_globales = 0;
    adr_var = ts_create(nom, TYPE_INT, VAR_INIT, VAR_NON_CONST);
    vars_globales = flag_glo;
    return adr_var;
}

/*
 * Supprime la derniere variable temporaire
 */
void ts_delete_tmp()
{
    pos_symbole --;
    free(table_symboles[pos_symbole].nom);
    table_symboles[pos_symbole].is_init = VAR_NON_INIT;
    table_symboles[pos_symbole].is_global = 0;
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
    table_symboles[pos_symbole].is_global = 0;
    pos_symbole++;

    return pos_symbole - 1;
}


/*
 * Compte le nombre d'instructions nécessaires pour les variables globales
 */
int ts_compter_inst_variables_globales()
{
    int i;
    int compte = 0;

    for (i = TAILLE_TAB_SYMB - compteur_vars_glo; i < TAILLE_TAB_SYMB; i++) {
        if (table_symboles[i].is_init == 1) {
            // Il faut 2 instructions pour creer et initialiser, 0 pour  
            compte += 2;
        } else {
            // Une seule pour juste creer
            compte ++;
        }
    }

    return compte;
}


/*
 * Affiche la table des symboles. Utilisee pour le debug
 */
void display_table_symb()
{
    int i;

    printf("\n==================TABLE DES SYMBOLES==================\n");
    for (i = 0; i < pos_symbole; i++) {
        printf("Var %d : %s, Type : %d, INIT : %d, CONST : %d, Globale : %d\n",
               i - base_pointer, table_symboles[i].nom, table_symboles[i].type,
               table_symboles[i].is_init, table_symboles[i].is_const,
               table_symboles[i].is_global); 
    }
    for (i = TAILLE_TAB_SYMB - compteur_vars_glo; i < TAILLE_TAB_SYMB; i++) {
        printf("Var %d : %s, Type : %d, INIT : %d, CONST : %d, Globale : %d\n",
               i, table_symboles[i].nom, table_symboles[i].type,
               table_symboles[i].is_init, table_symboles[i].is_const,
               table_symboles[i].is_global);
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
    int jump_traites = 1;
    int lignes_traitees = 0;
    int char_cops, taille_a_copier, adr_fonct;
    char * ligne, * adr_jump, *appel_fonct, *nom_fonct;
    char adr_jmp[] = "adr_jmp";
    char call[] = "CALL";

    nom_fonct = malloc(TAILLE_LIGNE * sizeof(char));

    ligne = malloc(TAILLE_LIGNE * sizeof(char));

    // Retour au debut du fichier temporaire
    rewind(output_tmp);

    ligne = fgets(ligne, TAILLE_LIGNE, output_tmp);
    
    // Recopie dans le ficher de sortie
    while (ligne != NULL) {
        // Inserstion de l'appel au main
        if (lignes_traitees == compteur_inst_vars_glo) {
            // Adresse de la fin du code
            fprintf(output, "COP 1 %d\n", compteur_asm);
            // Sauvegarde du base pointer
            fprintf(output, "COP 2 BP\n");
            // Nouvelle valeur du base pointer
            fprintf(output, "COP BP 4\n");
            // Appel du main
            fprintf(output, "CALL %d\n", table_sauts[0]);
            lignes_traitees += 4;
        }

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
            strncpy(nom_fonct, appel_fonct, strlen(appel_fonct)-1);
            fprintf(output, "%d\n", tf_get_addr(nom_fonct));
        } else {
            fputs(ligne, output);
        }
        ligne = fgets(ligne, TAILLE_LIGNE, output_tmp);
        lignes_traitees ++;
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

