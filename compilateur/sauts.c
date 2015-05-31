#include "sauts.h"

// Compteur du nombre de lignes ecrites en assembleur
int compteur_asm = 0;

// Indique la position actuelle dans la table des sauts
// On commence à 1, le premier saut du programme va obligatoirement au main
int pos_tab_saut = 1;


/******************************************************************************
**************** Fonctions de gestion de la table des saut ********************
******************************************************************************/

// Ajoute un saut dans la table
void add_saut(int position, int destination)
{
    table_sauts[position] = destination;
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
            // Adresse de retour du programme
            fprintf(output, "AFC RT %d\n", compteur_asm - 1);
            // Sauvegarde du base pointer
            fprintf(output, "PUSH BP\n");
            // Nouveau base pointer : la seule variable est le résulat
            fprintf(output, "ADD BP BP %d\n", 1);
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

