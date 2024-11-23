%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "utils.c"
    extern int yylineno;  // Variable para el número de línea
    extern char *yytext;  // Variable para el texto del token
    void yyerror(const char *msg);  // Función para manejar errores

    // Declaración de las funciones de utilidad
    extern int yylex();  // Declaración de la función de análisis léxico
%}



/* Definición de tipos semánticos */
%union {
    int num;        // Para números enteros
    char *str;      // Para identificadores o cadenas
}

/* Declaración de tokens */
%token INICIO FIN LEER ESCRIBIR PARENTESISIZQUIERDO PARENTESISDERECHO PUNTOYCOMA SUMA RESTA COMA ASIGNACION

/* Especificar los tipos para las variables no terminales */
%token <num> CONSTANTE
%token <str> IDENTIFICADOR

%type <num> expresion primaria

%%
/* Reglas gramaticales con rutinas semánticas */

programa:
    INICIO listaDeSentencias FIN
    ;

listaDeSentencias:
    sentencia
    | listaDeSentencias sentencia
    ;

sentencia:
    IDENTIFICADOR ASIGNACION expresion PUNTOYCOMA { 
        asignarValor($1, $3); 
    }
    | LEER PARENTESISIZQUIERDO listaDeIdentificadores PARENTESISDERECHO PUNTOYCOMA
    | ESCRIBIR PARENTESISIZQUIERDO listaDeExpresiones PARENTESISDERECHO PUNTOYCOMA
    ;

listaDeIdentificadores:
    IDENTIFICADOR
    | listaDeIdentificadores COMA IDENTIFICADOR
    ;

listaDeExpresiones:
    expresion
    | listaDeExpresiones COMA expresion
    ;

expresion:
    primaria                    { 
        printf("Valor de primaria: %d\n", $1);
        $$ = $1;
    }
    | expresion SUMA primaria   { 
        printf("Suma: %d + %d = %d\n", $1, $3, $1 + $3);
        $$ = $1 + $3;
    }
    | expresion RESTA primaria  { 
        printf("Resta: %d - %d = %d\n", $1, $3, $1 - $3);
        $$ = $1 - $3;
    }
    ;

primaria:
      CONSTANTE                   { $$ = $1; }
    | IDENTIFICADOR               { $$ = obtenerValor($1); }
    | PARENTESISIZQUIERDO expresion PARENTESISDERECHO { $$ = $2; }
    ;

%%

/* Función de manejo de errores */
void yyerror(const char *msg) {
    fprintf(stderr, "Error de sintaxis en la línea %d: %s\n", yylineno, msg);
    if (yytext) {
        fprintf(stderr, "Token inesperado: '%s' (en la posición %ld)\n", yytext, (long)yytext);
    }
}



int main() {
    printf("Iniciando el análisis sintáctico...\n");
    if (yyparse() == 0) {
        printf("Análisis sintáctico completado con éxito.\n");
    } else {
        printf("Hubo errores en el análisis sintáctico.\n");
    }
    return 0;
}

