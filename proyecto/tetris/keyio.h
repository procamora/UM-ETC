/*
  Entrada y salida por teclado.

  - Soporta la lectura de un sólo caracter.

  - Soporta acceso no bloqueante al teclado (polling).

  - Es necesario para emular con fidelidad algunas de las llamadas al
    sistema de MARS.
*/

#ifndef _KEYIO_H_
#define _KEYIO_H_

void		keyio_init		(void);
void		keyio_reset		(void);
int		keyio_read_key		(void);
int		keyio_peek_key		(void);
int		keyio_poll_key		(void);

#endif
