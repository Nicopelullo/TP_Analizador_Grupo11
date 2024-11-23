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

int asignarValor(const char *nombre, int valor) {
    int idx = buscarOAgregarSimbolo(nombre);
    if (idx == -1) {
        fprintf(stderr, "Error: No se pudo asignar valor, el identificador '%s' no existe.\n", nombre);
        return -1;
    }
    tabla[idx].valor = valor;
    printf("Valor asignado a '%s': %d\n", nombre, valor);
    return valor;
}

int obtenerValor(const char *nombre) {
    int idx = buscarOAgregarSimbolo(nombre);
    if (idx == -1) {
        fprintf(stderr, "Error: El identificador '%s' no está definido.\n", nombre);
        return -1;
    }
    return tabla[idx].valor;
}

