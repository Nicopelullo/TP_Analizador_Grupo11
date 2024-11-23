%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char *msg);
    extern int yylex();
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
    IDENTIFICADOR ASIGNACION expresion PUNTOYCOMA
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
    primaria
    | expresion SUMA primaria 
    | expresion RESTA primaria
    ;

primaria:
    IDENTIFICADOR
    | CONSTANTE
    | PARENTESISIZQUIERDO expresion PARENTESISDERECHO
    ;

%%

/* Función de manejo de errores */
void yyerror(const char *msg) {
    fprintf(stderr, "Error de sintaxis: %s\n", msg);
}

int main() {
    yyparse();
    return 0;
}
