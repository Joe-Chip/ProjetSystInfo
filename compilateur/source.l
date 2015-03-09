%{
#include "y.tab.h"
#include <stdio.h>
%}

%option yylineno

%%

const       {return tCONST;}
int         {return tINT;}
main	    {return tMAIN;}
if          {return tIF;}
else        {return tELSE;}
while       {return tWHILE;}
return      {return tRETURN;}
printf      {return tPRINT;}
\{	        {return tAO;}
\}	        {return tAF;}
\(	        {return tPO;}
\)	        {return tPF;}
[a-zA-Z][a-zA-Z0-9_]*   {
                            yylval.identificateur = strdup(yytext);
                            return tID;
                        }
[0-9]+	    {
                yylval.nb = atoi(yytext);
                return tNB;
            }
"&&"        {return tAND;}
"||"        {return tOR;}
"=="        {return tEQUI;}
"<="        {return tINFEG;}
">="        {return tSUPEG;}
"!="        {return tDIFF;}
"<"         {return tINF;}
">"         {return tSUP;}
";"	        {return tPV;}
","	        {return tVIRGULE;}
"+"         {return tADD;}
"-"         {return tSUB;}
"*"         {return tMUL;}
"/"         {return tDIV;}
"="         {return tEGAL;}
\n          {}
.	        {}
