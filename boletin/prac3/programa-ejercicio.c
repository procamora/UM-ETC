#include <stdbool.h>
#include "mips-runtime.h" // Define print_string, print_integer, read_character, read_integer y random_int_range, entre otras funciones.

#define NUM_DATOS_MAX 255

typedef struct {
  int tam;
  int datos[NUM_DATOS_MAX];
} VectorInt;

/* Vector de enteros que serán comparados */
VectorInt enteros = { 
  16, 
  { 2, 5, 3344, 655, -74, 53, 23, 14, -1005, 34, 25, 26, 7, 8, 2, 83 }
};

/* Cadena que contendrá el resultado de las comparaciones  */
char cadena_resultado[NUM_DATOS_MAX + 1];

/* Devuelve un número aleatorio entre 0 y max-1 (inclusive) */
int random_int_max(int max) {
  return random_int_range(0, max);
}
/* Devuelve -1 si a < b, 0 si a == b y 1 si a > b */
int compara_enteros(int a, int b) {
  if (a > b) {
    return 1;
  } else if (a < b) {
    return -1;
  } else {
    return 0;
  }
}

/* Compara los elementos de el vector global «enteros» con respecto al
   escalar recibido y almacena los resultados en la cadena global
   «cadena_resultado».  Deberá almacenar en la posición iésima de la
   cadena un caracter '<', '=' o '>' si el elemento íesimo de
   «enteros» es menor, igual o mayor respectivamente que «escalar». El
   array «cadena_resultado» debe quedar como una cadena válida de la
   misma logitud que «enteros» (debe acabar con '\0') */
void compara_vector_con_escalar(int escalar) {
  int lon = enteros.tam;
  for (int i = 0; i < lon; ++i) {
    int c = compara_enteros(enteros.datos[i], escalar);
    char car = '=';
    if (c == 1) {
       car = '>';
    }
    if (c == -1) {
       car = '<';
    }
    cadena_resultado[i] = car;
  }
  cadena_resultado[lon] = '\0';
}

/* Inicializa el vector «enteros» con valores aleatorios.  Para ello,
   primero pide por teclado dos datos: el número de elementos (N) y el
   máximo valor absoluto de los valores a generar (R). Los valores
   generados estarán entre -R y R inclusive.

   Si el valor de N es menor que 1 o mayor que NUM_DATOS_MAX, debe
   mensaje de error y terminar sin modificar el vector.

   Si el valor de R es menor que 1 o mayor que 1500, debe mostrar un
   mensaje de error y terminar sin modificar el vector.

   Debe utilizar la función random_int_max para generar los números
   aleatorios, la cual recibe un entero X y devuelve un entero entre 0
   y X-1 inclusive.
*/
void inicializa_vector(void) {
  /* TODO */
}

int main(int argc, char* argv[]) {
  clear_screen();
  print_string("\nPráctica 3 de ensamblador de ETC\n");
  while (true) {
    print_string("\nActualmente hay "); print_integer(enteros.tam); print_string(" números en el vector: ");
    for (int i = 0; i < enteros.tam; ++i) {
      print_integer(enteros.datos[i]); print_string(" ");
    }
    print_string("\n");

    print_string("\n 1 - Comparar los elementos del vector con un escalar\n 2 - Rellenar el vector con valores aleatorios\n 3 - Salir\n\nElige una opción: ");
    char opc = read_character();
    print_string("\n");
    if (opc == '1') {
      print_string("Introduce el escalar con el que quieres comparar: ");
      int escalar = read_integer();
      compara_vector_con_escalar(escalar);
      print_string("El resultado de comparar cada elemento con el escalar es: ");
      print_string(cadena_resultado);
      print_string("\n");
    } else if (opc == '2') {
      inicializa_vector();
      print_string("\n");
    } else if (opc == '3') {
      print_string("¡Adiós!\n");
      mips_exit(0);
    } else {
      print_string("Opción incorrecta. Pulse cualquier tecla para seguir.\n");
      read_character();
    }
  }
}
