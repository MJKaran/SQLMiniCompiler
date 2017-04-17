%{
	#include"y.tab.h"
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	extern void yyerror(char *);
%}
%%
"CREATE TABLE"|"create table" {strcpy(yylval.var, yytext); return CREATE;}
REFERENCES {strcpy(yylval.var, yytext); return REFS;}
int|varchar|double|Date|True|False|Yes|No|byte {strcpy(yylval.var, yytext); return DTYPE;}
(SELECT|select) {strcpy(yylval.var, yytext); return SELECT;}
(distinct) {return DISTINCT;}
(FROM|from) {return FROM;}
(WHERE|where) {strcpy(yylval.var, yytext); return WHERE;}
(desc) {return DESC;}
(asc) {return ASC;}
"group by" {strcpy(yylval.var, yytext); return GROUP;}
(having) {strcpy(yylval.var, yytext); return HAVING;}
"order by" {strcpy(yylval.var, yytext); return ORDER;}
(or) {return OR;}
(and) {return AND;} 
(union) {return UNION;}
(intersect) {return INTERSECT;}
[0-9]+ {strcpy(yylval.var, yytext); return NUMBER;}
[A-Z]+ {strcpy(yylval.var, yytext); return TABLENAME;} 
[a-zA-Z][a-zA-Z0-9]* {strcpy(yylval.var, yytext); return ID;}
[\*]	{return yytext[0];}
,|\;|\(|\) {strcpy(yylval.var, yytext); return yytext[0];}
\< {strcpy(yylval.var, yytext); return LT;}
\> {strcpy(yylval.var, yytext); return GT;}
\<= {strcpy(yylval.var, yytext); return LE;}
\>= {strcpy(yylval.var, yytext); return GE;}
= {strcpy(yylval.var, yytext); return EQ;}
!= {strcpy(yylval.var, yytext); return NE;}
[\n\t ]	;
"/*"[^*]*"*/"|"/*"[^/]*"*/" ;
\/\/.* ;
.	yyerror("Invalid Character");

%%