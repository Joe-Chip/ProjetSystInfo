%{
#include <stdio.h>
%}

%token tMAIN tINT tAO tAF tPO tPF tPV tID /*tVIRGULE tNB*/ 
%start Start

%%

Start       :     tINT tMAIN tPO tPF Corps
            ;
Corps       :     tAO Declaration Corps tAF
            ;
Declaration :     tINT tID tPV
            ;

%%

main () {
    return yyparse();
}

yyerror (char * s) {
    fprintf(stderr, "%s\n", s);
}
