# Makefile

run: y.tab.c lex.yy.c
	gcc y.tab.c lex.yy.c -lfl -o run
	
lex.yy.c: l.l
	flex l.l

y.tab.c: y.y
	bison -d y.y


