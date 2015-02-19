%{
#include "y.tab.h"
int i = 0;
%}

%%

int	{return tINT;}
main	{return tMAIN;}
\{	{return tAO;}
\}	{return tAF;}
\(	{return tPO;}
\)	{return tPF;}
[a-zA-Z][a-zA-Z0-9_]*	{return tID;}
[0-9]+	{return tNB;}
;	{return tPV;}
,	{return tVIRGULE;}
\n	{i++;}
.	{}
