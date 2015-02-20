%{
#include <stdio.h>

%}

%token tMAIN tCONST tINT tAO tAF tPO tPF tPV tID tVIRGULE 
%token tNB
%token tADD tSUB tMUL tDIV tEGAL
%token tRETURN
%start Start

%%

Start :         Main
Main :          tINT tMAIN tPO tPF tAO Corps Return tAF {printf("Sutallto\n");}
              ;
Corps :         Declarations Blocs {printf("My fat body is ready\n");}
              | Declarations {printf("My body is ready\n");}
              ;
Declarations :  L_Decl Declarations {printf("DDDDs\n");}
              | L_Decl {printf("D\n");}
              ;
L_Decl :        Type Seq_Decl tPV {printf("LD\n");}
              ;
Type :          tINT
              | tCONST tINT
              ;
Seq_Decl :      Decl tVIRGULE Seq_Decl {printf("MutliD\n");}
              | Decl {printf("UniD\n");}
              ;
Decl :          tID {printf("No Ini\n");}
              | tID tEGAL tNB {printf("Ini\n");}
              ;
Blocs :         Bloc Blocs {printf("Blocs\n");}
              | Bloc {printf("B\n");}
              ;
Bloc :          tPV
              ;
Return :        tRETURN tNB tPV {printf("Return\n");}
              ;

%%

int main () {
    return yyparse();
}

yyerror (char * s) {
    fprintf(stderr, "%s\n", s);
}
