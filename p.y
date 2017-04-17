%{
    #include<string.h>
    #include<stdio.h>
    #include<stdlib.h>
    int yydebug=1;
	int yylex();
	void display_ic();
	void make_ic_entry(char t[], char c[], char r[]);
	extern void yyerror(char *);
    extern FILE *yyin;
   int search(char []);
	void make_symtab_entry(char [],char []);
	void display_symtab();
    struct icg
    {
        char optr[5];
        char oper1[10];
        char oper2[10];
        char result[10];
    }quad[30];
    struct iCodeGen
    {
        char tabName[50];
        char cols[100];
        char refers[50];
    }icg[50];
    int icgIdx=0;
    char tab[50];
	
    struct Symboltable
    {
        char symname[50];
        char value[50];
    }Sym[100];

    int idx=0, tIndex=0, StNo, Index, tInd, symcnt=0;
%}
%start S
%union{char var[50];}
%token <var> CREATE DTYPE TABLENAME ID NUMBER SELECT WHERE ORDER GROUP HAVING LE GE EQ NE LT GT
%token FROM DISTINCT ASC DESC OR AND UNION INTERSECT REFS
%type <var> E F refTab A
%left AND OR
%left LT GT LE GE EQ NE
%%
S   : C1 ';' {printf("Accepted Create\n");} S
    | S1 ';' {printf("Accepted Select\n");} S
	|
    ;

C1  : CREATE TABLENAME {strcpy(tab, $2);printf("%s\n",tab);} '(' COLDET ')'
    ;

COLDET  : F {strcpy(icg[icgIdx].tabName,tab);strcpy(icg[icgIdx].cols, $1);icgIdx++;} A COLDET
		| ',' COLDET
		|
		;
A : DTYPE {strcpy(icg[icgIdx].tabName,tab);strcpy(icg[icgIdx].cols, $1);icgIdx++;}
	| DTYPE REFS refTab
    ;

refTab : TABLENAME {strcpy(icg[icgIdx].refers, $1);icgIdx++;}

S1 : SI INTERSECT SI
	| SI UNION SI
	|SI
	;

SI :  SELECT {if(search($1)==-1) make_symtab_entry($1,"Selection Action");} attList FROM tabList S2
	| SELECT {if(search($1)==-1) make_symtab_entry($1,"Selection Action");} DISTINCT attList FROM tabList S2
	;

S2  : WHERE {if(search($1)==-1) make_symtab_entry($1,"Keyword");} C S3
	| S3
	|
    ;

S3 : GROUP {if(search($1)==-1) make_symtab_entry($1,"Keyword");} attList S4
    ;

S4 : HAVING {if(search($1)==-1) make_symtab_entry($1,"Keyword");} C S5
    | S5
    ;

S5 : ORDER {if(search($1)==-1) make_symtab_entry($1,"Keyword");} attList S6
    |
    ;

S6 : DESC
    | ASC
    |
    ;

attList : ID{if(search($1)==-1) make_symtab_entry($1,"Identifier");} ',' attList{
    if(search($1)==-1) make_symtab_entry($1,"Identifier");}
    | '*'
    | ID {if(search($1)==-1) make_symtab_entry($1,"Identifier");}
    ;

tabList : TABLENAME {if(search($1)==-1) make_symtab_entry($1,"Table Name");} ',' tabList{
    if(search($1)==-1) make_symtab_entry($1,"Table Name");}
    | TABLENAME {if(search($1)==-1) make_symtab_entry($1,"Table Name");}
    ;
C : C OR C
    | C AND C
    |E
    ;

E : F LT {if(search($2)==-1) make_symtab_entry($2,"Less Than");} F 
    | F GT {if(search($2)==-1) make_symtab_entry($2,"Greater Than");} F 
    | F LE {if(search($2)==-1) make_symtab_entry($2,"Less/Equal");} F 
    | F GE {if(search($2)==-1) make_symtab_entry($2,"Great/Equal");} F 
    | F EQ {if(search($2)==-1) make_symtab_entry($2,"Equal");} F 
    | F NE {if(search($2)==-1) make_symtab_entry($2,"Not Equal");} F 
    ;
F   : ID {if(search($1)==-1) make_symtab_entry($1,"Identifier");}
    | NUMBER {if(search($1)==-1) make_symtab_entry($1,"Numeric");}
    ;
%%
int main(int argc, char *argv[])
{
    //yyparse();
    int i=0;
    printf("Hello\n");
    yyin=fopen("ip.sql","r");
    yyparse(); 
    display_symtab();
	display_ic();
    printf("After parse\n\n");
    return 0;
}
int search(char sym[10])
{
    int i,flag=0;
    for(i=0;i<20;i++)
    {
        if(strcmp(Sym[i].symname,sym)==0)
        {
            flag = 1;
            break;
        }
    }
    if(flag == 0)
        return -1;
    else
        return i;
}
void display_symtab()
{
    int i;
    printf("\nThe Symbol Table\n");
    printf("\n\n---------------------------------\n");
    printf("%-25s %-25s\n", "Value", "Name");
    printf("---------------------------------\n");
    for(i=0; i<symcnt; i++)
        printf("%-25s %-25s\n",Sym[i].value,Sym[i].symname);
    printf("---------------------------------\n\n");
}
void display_ic()
{
    int i;
    printf("The Intermediate Code Is:\n");
    printf("\n\n---------------------------------\n");
    printf("%-25s %-25s %-25s\n", "TableName", "ColumnName","References");
    printf("---------------------------------\n");
    for(i=0; i<icgIdx; i++)
        printf("%-25s %-25s %-25s\n",icg[i].tabName,icg[i].cols,icg[i].refers);
    printf("---------------------------------\n\n");
}
void make_ic_entry(char t[], char c[], char r[])
{
    //printf("Came here%s %s\n",n,val);
    strcpy(icg[icgIdx].tabName,t);
    strcpy(icg[icgIdx].cols,c);
    strcpy(icg[icgIdx].refers,r);
    icgIdx++;
    return;
}
void make_symtab_entry(char n[], char val[])
{
    //printf("Came here%s %s\n",n,val);
    strcpy(Sym[symcnt].symname,n);
    strcpy(Sym[symcnt].value,val);
    symcnt++;
    return;
}
void yyerror(char *str)
{
   printf("\nError : %s\n\n",str);//str always says 'parse error'!
}
int yywrap()
{
    return 1;
}  
