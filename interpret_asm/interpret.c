#include "interpret.h"


// Numero de la ligne courante
int ligne = 0;


/******************************************************************************
******************* Fonctons de la table contentant le code *******************
******************************************************************************/

// Ajoute une ligne de code dans la table
void add_ligne(int cop, int op1, int op2, int op3)
{
    code[ligne][0] = cop;
    code[ligne][1] = op1;
    code[ligne][2] = op2;
    code[ligne][3] = op3;
    ligne ++;
}


// Execution du code
void execute()
{
    int ligne_finale = ligne;

    ligne = 0;

    while (ligne < ligne_finale) {
        switch (code[ligne][0]) {
        case ADD:
            table_variable[code[ligne][1]] = table_variable[code[ligne][2]]
                                           + table_variable[code[ligne][3]];
            break; 


        }

    }
}

