#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *nombre;
    int valor;
} Simbolo;

Simbolo tabla[100];  // Tabla de símbolos simple.
int numSimbolos = 0;

// Buscar o agregar un símbolo.
int buscarOAgregarSimbolo(const char *nombre) {
    for (int i = 0; i < numSimbolos; i++) {
        if (strcmp(tabla[i].nombre, nombre) == 0) {
            return i;
        }
    }
    // Si no existe, lo agregamos.
    tabla[numSimbolos].nombre = strdup(nombre);
    tabla[numSimbolos].valor = 0;  // Valor inicial.
    return numSimbolos++;
}

// Obtener el valor de un identificador.
int obtenerValor(const char *nombre) {
    int idx = buscarOAgregarSimbolo(nombre);
    return tabla[idx].valor;
}

// Asignar un valor a un identificador.
void asignarValor(const char *nombre, int valor) {
    int idx = buscarOAgregarSimbolo(nombre);
    tabla[idx].valor = valor;
}
