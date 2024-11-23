%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "parser.tab.h"
%}

LETRA          [a-zA-Z]
DIGITO         [0-9]
identificador  {LETRA}({LETRA}|{DIGITO})*
constante      ({DIGITO})+

%%
"inicio"                return INICIO;
"fin"                   return FIN;
"leer"                  return LEER;
"escribir"              return ESCRIBIR;

{constante}           { yylval.num = atoi(yytext); return CONSTANTE; }
{identificador}       { yylval.str = strdup(yytext); return IDENTIFICADOR; }
"("                     return PARENTESISIZQUIERDO;
")"                     return PARENTESISDERECHO;
";"                     return PUNTOYCOMA;
"+"                     return SUMA;
"-"                     return RESTA;
","                     return COMA;
":="                    return ASIGNACION;

[ \t\n]+              ;  // Ignorar espacios y saltos de línea
.                     { printf("Carácter no reconocido: %s\n", yytext); }

%%
