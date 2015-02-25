%{
#include "y.tab.h"
#include <stdio.h>
int i = 0;
%}

%%

const       {return tCONST;}
int         {return tINT;}
main	    {return tMAIN;}
return      {return tRETURN;}
printf      {return tPRINT;}
\{	        {return tAO;}
\}	        {return tAF;}
\(	        {return tPO;}
\)	        {return tPF;}
[a-zA-Z][a-zA-Z0-9_]*   {
                            yylval.identificateur = yytext;
                            return tID;
                        }
[0-9]+	    {
                yylval.nb = atoi(yytext);
                return tNB;
            }
";"	        {return tPV;}
","	        {return tVIRGULE;}
"+"         {return tADD;}
"-"         {return tSUB;}
"*"         {return tMUL;}
"/"         {return tDIV;}
"="         {return tEGAL;}
"\n"        {i++;}
.	        {}
