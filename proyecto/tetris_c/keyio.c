/* Entrada y salida por teclado */

#include <stdbool.h>
#include "keyio.h"
#include <termios.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

static struct termios tcattr_orig, tcattr_new;
static int peek = -1;
static bool initilized = false;
static bool keyio_atexit = false;

/**
 * Inicializa el teclado para poder usar keyio_peek_key y keyio_poll_key.
 */
void
keyio_init (void) {
  if (initilized) {
    keyio_reset();
  }
  tcgetattr(0, &tcattr_orig);
  tcattr_new = tcattr_orig;
  tcattr_new.c_lflag &= ~ICANON;
  tcattr_new.c_lflag &= ~ECHO;
  tcattr_new.c_lflag &= ~ISIG;
  tcattr_new.c_cc[VMIN] = 0;
  tcattr_new.c_cc[VTIME] = 0;
  tcsetattr(0, TCSANOW, &tcattr_new);
  initilized = true;
  if (!keyio_atexit) {
    keyio_atexit = true;
    atexit(keyio_reset);
  }
}

/**
 * Restablece la configuración del teclado.
 */
void
keyio_reset (void) {
  tcsetattr (0,TCSANOW, &tcattr_orig);
}

/**
 * Devuelve la última tecla pulsada por el usuario que no ha sido
 * leída, o 0 si no se ha pulsado ninguna.
 */
int
keyio_peek_key (void) {
  if (peek != -1) {
    return peek;
  }

  if (!initilized) {
    keyio_init();
  }
  
  char ch;
  int nread = read (0, &ch, 1);
  
  if (nread == 1) {
    peek = ch;
    return peek;
  }
  
  return 0;
}

/**
 * Devuelve la última tecla pulsada por el usuario que no ha sido
 * leída, se bloquea si no se había pulsado ninguna. Devuelve -1 si no
 * se ha podido leer la tecla.
 */
int
keyio_read_key (void) {
  if (peek != -1) {
    char ch = peek;
    peek = -1;
    return ch;
  }
  
  if (!initilized) {
    keyio_init();
  }

  fflush(stdout);
  fflush(stderr);

  tcattr_new.c_cc[VMIN] = 1;
  tcsetattr(0, TCSANOW, &tcattr_new);

  char ch;
  int nread = read (0, &ch, 1);
  
  tcattr_new.c_cc[VMIN] = 0;
  tcsetattr (0, TCSANOW, &tcattr_new);
  
  if (nread > 0) {
    return ch;
  } else {
    return -1;
  }
}

/**
 * Devuelve la última tecla pulsada por el usuario que no ha sido
 * leída y la consume, no se bloquea si no se había pulsado ninguna.
 */
int
keyio_poll_key (void) {
  if (peek != -1) {
    char ch = peek;
    peek = -1;
    return ch;
  }
  
  if (!initilized) {
    keyio_init();
  }

  char ch;
  int nread = read (0, &ch, 1);
  
  if (nread == 1) {
    return ch;
  }
  
  return 0;
}
