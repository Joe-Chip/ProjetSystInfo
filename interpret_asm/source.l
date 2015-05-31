%{
#include "y.tab.h"
#include <stdio.h>
%}

%option yylineno

%%

ADD         {return tADD;}
SOU         {return tSOU;}
MUL         {return tMUL;}
DIV         {return tDIV;}
AFC         {return tAFC;}
COP         {return tCOP;}
PRI         {return tPRI;}
JMP         {return tJMP;}
JMF         {return tJMF;}
OR          {return tOR;}
AND         {return tAND;}
INF         {return tINF;}
SUP         {return tSUP;}
EQU         {return tEQU;}
CALL        {return tCALL;}
RET         {return tRET;}
PUSH        {return tPUSH;}
POP         {return tPOP;}
BP          {return tBP;}
RT          {return tRT;}
[0-9]+      {
                yylval.nb = atoi(yytext);
                return tOPERAND;
            }
"-"         {return tNEG;}
\n          {return tNEWLINE;}
.           {}

