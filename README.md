# Lexical-syntax-analyzer-for-Python-Lang
_Understaning Compilers_

This is full executable program in witch Using the tools Flex/Bison on Linux environment.

Steps to compile and run the code: 
1. bison -d y.y
2. flex l.l
3. gcc y.tab.c lex.yy.c -lfl -o run
4. ./run input.py

When you run the program with a pyhton file as input, you get the message "syntax corect", else you get error either lexical or syntax with line number of the error that has the python file.  

Examples

      
