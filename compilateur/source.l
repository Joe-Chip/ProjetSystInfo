%{
#include "y.tab.h"
int i = 0;
%}

%%

const       {return tCONST;}
int         {return tINT;}
main	    {return tMAIN;}
return      {return tRETURN;}
\{	        {return tAO;}
\}	        {return tAF;}
\(	        {return tPO;}
\)	        {return tPF;}
[a-zA-Z][a-zA-Z0-9_]* {return tID;}
[0-9]+	    {return tNB;}
";"	        {return tPV;}
","	        {return tVIRGULE;}
"+"         {return tADD;}
"-"         {return tSUB;}
"*"         {return tMUL;}
"/"         {return tDIV;}
"="         {return tEGAL;}
"\n"        {i++;}
.	        {}
