%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"

%}

%option yylineno
/* float exponent */
EXP	([Ee][-+]?[0-9]+)
%x cmnts


%%

"#".*					/* ignore comments */

"import"				{ return IMPORT; } 
"from"					{ return FROM; }
"as"					{ return AS; }
"class"				{ return CLASS; }
"def"					{ return DEF; }
"__init__"				{ return INIT; }
"self"					{ return SELF; }
"for"					{ return FOR; }
"in"					{ return IN; }
"if"					{ return IF; } 
"elif"					{ return ELIF; }
"else"					{ return ELSE; }
"true"					{ yylval.intval = 1; return BOOL; }
"false"				{ yylval.intval = 0; return BOOL; }
"none"					{ return NONE; }				
"pass"					{ return PASS; }
"break"				{ return BREAK; }
"async"				{ return ASYNC; }
"print"				{ return PRINT; }
"return"				{ return RETURN; }
"continue"				{ return CONTINUE; }
"and"					{ return AND; }
"or"					{ return LOR; }
"lambda"				{ return LAMBDA; }

[A-Za-z][A-Za-z0-9_]*			{ yylval.strval = strdup(yytext); return IDENTIFIER; }
\"[^'\n]*\" |
\'[^'\n]*\'				{ yylval.strval = strdup(yytext); return STRING; } 
-?[0-9]+				{ yylval.intval = atoi(yytext); return INTNUM; }
-?[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}?			{ yylval.floatval = atof(yytext); return FLOAT; }

"="|"+"|"-"|","|"("|")"|"["|"]"|":"|"*"	{ return yytext[0]; }

"{"					{ return LBRA; }
"}"					{ return RBRA; }
">"					{ return GT; }
"<"					{ return LT; }
"!="					{ return NOT; }
">="					{ return GE; }
"<="					{ return LE; }
"=="					{ return EQUAL; } 

[ \t\f\v\n]				{ ; }	
.					{ return *yytext; }



%%
