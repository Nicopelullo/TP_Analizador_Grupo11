%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "utils.c"
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
        printf("Asignando valor a %s\n", $1);  // $1 es el identificador
        printf("Valor asignado: %d\n", $3);   // $3 es el valor de la expresión
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
        printf("Valor de primaria: %d\n", $1);  // Imprime el valor de la expresión primaria
        $$ = $1;
    }
    | expresion SUMA primaria   { 
        printf("Suma: %d + %d = %d\n", $1, $3, $1 + $3);  // Imprime el resultado de la suma
        $$ = $1 + $3;
    }
    | expresion RESTA primaria  { 
        printf("Resta: %d - %d = %d\n", $1, $3, $1 - $3);  // Imprime el resultado de la resta
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
    fprintf(stderr, "Error de sintaxis: %s\n", msg);
}

int main() {
    printf("Iniciando el análisis sintáctico...\n");
    yyparse();  // Comienza el análisis
    printf("Análisis sintáctico terminado.\n");
    return 0;
}
