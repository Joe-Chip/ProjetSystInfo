#ifndef SAUTS_H
#define SAUTS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symboles.h"


// Table des sauts : contient l'adresse de destination de chaque saut
int table_sauts[TAILLE_TAB_SAUTS];

// Indique la position actuelle dans la table des sauts
// On commence à 1, le premier saut du programme va obligatoirement au main
extern int pos_tab_saut;


/******************************************************************************
**************** Fonctions de gestion de la table des sauts *******************
******************************************************************************/

// Ajoute un saut dans la table
void add_saut(int position, int destination);

// Parcourt le fichier de sortie pour completer les sauts
void completer_sauts();

// Affichage de la table des sauts, utilis pour le debug
void afficher_table_sauts();
#endif
