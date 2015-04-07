%{
#include "y.tab.h"
#include <stdio.h>
%}


%%

ADD         {return tADD;}
SOU         {return tSOU;}
MUL         {return tMUL;}
DIV         {return tDIV;}
AFC         {return tAFC;}
COP         {return tCOP;}
JMP         {return tJMP;}
JMF         {return tJMF;}
OR          {return tOR;}
AND         {return tAND;}
INF         {return tINF;}
SUP         {return tSUP;}
EQU         {return tEQU;}
DIF         {return tDIF;}
[0-9]+      {
                yylval.nb = atoi(yytext);
                return tOPERAND;
            }
\n          {return tNEWLINE;}
.           {}
