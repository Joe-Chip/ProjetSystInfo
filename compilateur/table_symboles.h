#define DEFAULT 0
#define TYPE_INT 1
#define VAR_INIT 1
#define FLAG_CONST 1
#define TAILLE_TAB_SYMB 256

/* Définition de la table des symboles */
struct type_symbole {
    char * nom;
    int type;
    int is_init;
    int is_const;
    int niveau
};

struct type_symbole table_symboles[TAILLE_TAB_SYMB];
int pos_symbole = 0;

// Stocke le niveau d'appel de la fonction en cours
int niveau_courant = 0;

void ts_create(char * nom, int type, int is_init, int is_const, int niveau);

void ts_init(char * nom);

int ts_addr(char * nom);

int ts_create_tmp();

void ts_delete_tmp();
