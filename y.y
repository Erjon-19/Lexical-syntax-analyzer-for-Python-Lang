%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	
	extern char* yytext;
	extern FILE* yyin, *output;
	extern int yylex();
	void yyerror(char const *msg);
	extern int yylineno;

%}

%right '-' '+'

%union {
	
	int intval;
	double	floatval;	 
	char* strval;
}


%token <strval> IDENTIFIER
%token <strval> STRING
%token <intval> INTNUM
%token <floatval> FLOAT
%token <intval> BOOL


%token IMPORT
%token FROM
%token AS
%token CLASS
%token DEF
%token INIT
%token SELF
%token FOR
%token IN
%token IF
%token ELIF
%token ELSE
%token NONE
%token PASS
%token BREAK
%token ASYNC
%token PRINT
%token CONTINUE
%token OR
%token GT
%token LT
%token GE
%token LE
%token NOT
%token EQUAL
%token RETURN
%token AND
%token LOR
%token LBRA
%token RBRA
%token LAMBDA

%type <floatval> exp term factor
 
%%

start:		  	  /*empty*/
			| prog	
			;
		
prog:		  	  stmt 
			| prog stmt
			;
		
stmt:		  	  simple_stmt
			| compound_stmt 
			;
		 
simple_stmt:	 	  import_stmt
			| assign
			| exp		 { printf("value = %f\n", $1); }  
			| print_stmt
			| self_call	
			| return_stmt
			| dict_stmt
			;

compound_stmt:		  for_stmt
			| if_stmt
			| class_def
			| func_def
			| call 
			| class_obj
			/*| lambda_stmt */ 
			;


print_stmt:		PRINT '(' IDENTIFIER ')' 
			| PRINT '(' list ')' 
			| PRINT '(' list '+' IDENTIFIER ')'
			| PRINT '(' list '+' self_call ')'
			| PRINT '('self_call')'
			| PRINT '(' call ')'
			| PRINT '(' exp ')'	{ printf("value = %f\n", $3); }
			| PRINT '(' assign_exp lo assign_exp ')'
			;

import_stmt:	  	  IMPORT module
			| IMPORT module AS IDENTIFIER
			| import_stmt ',' module
			| FROM relative_module IMPORT module
			| FROM relative_module IMPORT module AS IDENTIFIER
			| FROM module IMPORT module
			| FROM module IMPORT '*'
			;
		
relative_module:	  '.' module
			| '.'relative_module
			| '.'
			;	
			
module:		  IDENTIFIER
			| module'.'IDENTIFIER
			;
				
class_def:		  CLASS class_name ':' class_block
			| CLASS class_name '(' params ')' ':' class_block
			;
			
class_name:		IDENTIFIER;

class_block:		  constructor
			| func_def		
			| PASS ;

constructor: 	  	  DEF INIT '(' params ')' ':' con_block;

con_block: 		  assign 
			| self_call
			;		

func_def: 		  DEF func_name '(' params ')' ':' func_block
			| ASYNC  func_name '(' params ')' ':' func_block
			;
			
func_name:		IDENTIFIER;
		
params:		  /*empty*/
			| parameter
			| params ',' parameter
			;

parameter: 		  assign
			| IDENTIFIER
			| '*' IDENTIFIER
			| SELF
			;

func_block:	 	  assign
			| for_stmt
			| if_stmt
			| print_stmt 
			| call			/*recursive call of function*/
			| self_call
			| return_stmt
			| PASS
			;
			
for_stmt:		FOR args_list IN positional_item ':' block;

if_stmt:		  IF assign_exp ':' block
			| IF assign_exp ':' block  ELSE ':' block
			| IF assign_exp ':' block elif_stmt ELSE ':' block
			;	
		
elif_stmt:		  ELIF assign_exp ':' block
			| elif_stmt ELIF assign_exp ':' block
			;

assign_exp:		  exp op exp
			| IDENTIFIER op exp
			| IDENTIFIER op BOOL
			| IDENTIFIER op STRING
			| BOOL
			;
			
block:			assign
			| print_stmt
			| for_stmt
			| call
			| return_stmt
			| BREAK
			| PASS
			;

return_stmt:  		RETURN IDENTIFIER;

self_call:		  SELF 
			| SELF'.'IDENTIFIER
			| SELF'.'assign
			;
			
class_obj: 		  IDENTIFIER '=' class_name '(' ')'
			| IDENTIFIER '=' class_name '(' args_list ')'
			;
					
call: 			  ref '(' ')' 
			| ref '(' args_list ')' 
			;
ref:			  IDENTIFIER
			| ref '.' IDENTIFIER 
			;

args_list:		  positional_item
			| args_list ',' positional_item
			; 
			
positional_item:	  assign 
			| exp
			| atom
			| IDENTIFIER
			;	
			
dict_stmt:		  IDENTIFIER '=' LBRA pairs RBRA
			;

pairs:			pair
			| pairs ',' pair
			;
			
pair:			  STRING ':' exp
			| STRING ':' BOOL
			| STRING ':' STRING
			;

assign: 		  IDENTIFIER '=' exp	/* { printf("%f\n", $3); } */	
			| IDENTIFIER '=' atom
			| IDENTIFIER '=' s
			;			

			
exp:	 	  exp '+' term		{ $$ = $1 + $3; }
			| exp '-' term	 	{ $$ = $1 - $3; }
			| term
			;
	
term:		  	  term '*' factor 	{ $$ = $1 * $3; }
			| term '/' factor 	{ $$ = $1 / $3; }
			| factor
			;

factor:		  '(' exp ')'		{ $$ = $2; }
			| INTNUM		{ $$ = $1; }
			| FLOAT 		{ $$ = $1; }	
			;
			
list_n:	  	  exp 
			| list_n ',' exp
			;
			
list:		  	  atom 
			| list ',' atom
			;
			
atom:		  	  STRING
			| '[' list ']'
			| '[' list_n ']'
			| BOOL
			| NONE
			;

s:			s '+' s | s '-' s | '(' s ')' | IDENTIFIER;

/*comparison operator*/
op:		OR | GT | LT | GE | LE | NOT | EQUAL;
/*logic_operator*/
lo: AND | LOR;

%%


int main(int argc, char* argv[]) {

	FILE *input;
	if(argc!=2) {
		printf("error args\n");
		exit(1);
	}

	input = fopen(argv[1], "r");
	if ( input == NULL )
	{
	    printf( "Could not open source file\n" );
	    exit(1);
	} 
	yyin = input;

	yyparse();
	printf("syntax correct!\n"); 
	return 0;

}

void yyerror(char const *msg) {

	fprintf(stderr, "Line: %d\n%s: %s", yylineno-1, msg, yytext);
	printf("\n");
	exit(1);
} 
