# Version incompleta del tetris
# Sincronizada con tetris.s:r2563


#i Rotar la pieza 90 grados
#j Mover la pieza hacia la izquierda
#l Mover la pieza hacia la derecha
#k Mover la pieza hacia abajo
#x Salir al menu

	.data

	.align	2
pantalla:
	.word	0
	.word	0
	.space	1024

	.align	2
campo:
	.word	0
	.word	0
	.space	1024

	.align	2
pieza_actual:
	.word	0
	.word	0
	.space	1024

	.align 2
pieza_actual_x:
	.word 0

pieza_actual_y:
	.word 0

	.align	2
imagen_auxiliar:
	.word	0
	.word	0
	.space	1024

	.align	2
pieza_jota:
	.word	2
	.word	3
	.ascii		"\0*\0***\0\0"

	.align	2
pieza_ele:
	.word	2
	.word	3
	.ascii		"*\0*\0**\0\0"

	.align	2
pieza_barra:
	.word	1
	.word	4
	.ascii		"****\0\0\0\0"

	.align	2
pieza_zeta:
	.word	3
	.word	2
	.ascii		"**\0\0**\0\0"

	.align	2
pieza_ese:
	.word	3
	.word	2
	.ascii		"\0****\0\0\0"

	.align	2
pieza_cuadro:
	.word	2
	.word	2
	.ascii		"****\0\0\0\0"

	.align	2
pieza_te:
	.word	3
	.word	2
	.ascii		"\0*\0***\0\0"

	.align	2
piezas:
	.word	pieza_jota
	.word	pieza_ele
	.word	pieza_zeta
	.word	pieza_ese
	.word	pieza_barra
	.word	pieza_cuadro
	.word	pieza_te

acabar_partida:
	.byte	0

imprimir_mensaje:
	.byte	0

	.align	2
procesar_entrada.opciones:
	.byte	'x'
	.space	3
	.word	tecla_salir
	.byte	'j'
	.space	3
	.word	tecla_izquierda
	.byte	'l'
	.space	3
	.word	tecla_derecha
	.byte	'k'
	.space	3
	.word	tecla_abajo
	.byte	'i'
	.space	3
	.word	tecla_rotar

str000:
	.asciiz		"Tetris\n\n 1 - Jugar\n 2 - Salir\n\nElige una opcion:\n"
str001:
	.asciiz		"\nAdios!\n"
str002:
	.asciiz		"\nOpcion incorrecta. Pulse cualquier tecla para seguir.\n"
str_fin:
	.asciiz		"++++++++++++++++++++\n+------------------+\n+| FIN DE PARTIDA |+\n+| Pulse una tecla|+\n+------------------+\n++++++++++++++++++++"

pieza_fin:
	.word	19
	.word	4
	.ascii		"+-----------------++\0FIN DE PARTIDA\0\0++\0Pulse una tecla\0++-----------------+"

buffer:	.space 256	#buffer para integer_to_string

puntuacion:
	.asciiz		"Puntuacion: "

num_punt:
	.word	0

tiempo:
	.word	1001

test:	.asciiz		"\n\n"

	.text


imagen_pixel_addr:			# ($a0, $a1, $a2) = (imagen, x, y)
					# pixel_addr = &data + y*ancho + x
	lw	$t1, 0($a0)		# $a0 = dirección de la imagen
					# $t1 = ancho
	mul	$t1, $t1, $a2		# $a2 * ancho
	addu	$t1, $t1, $a1		# $a2 * ancho + $a1
	addiu	$a0, $a0, 8		# $a0 = dirección del array data
	addu	$v0, $a0, $t1		# $v0 = $a0 + $a2 * ancho + $a1
	jr	$ra



imagen_get_pixel:			# ($a0, $a1, $a2) = (img, x, y)
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)		# guardamos $ra porque haremos un jal
	jal	imagen_pixel_addr	# (img, x, y) ya en ($a0, $a1, $a2)
	lbu	$v0, 0($v0)		# lee el pixel a devolver
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



imagen_set_pixel:
	addiu	$sp, $sp, -8
	sw	$s0, 4($sp)		# color
	sw	$ra, 0($sp)

	move	$s0, $a3		# Pixel color

	jal	imagen_pixel_addr
	sb	$s0, 0($v0)		# *pixel = color;

	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 8
	jr	$ra



imagen_clean:
	addiu	$sp, $sp, -28
	sw	$s5, 24($sp)		#
	sw	$s4, 20($sp)		#
	sw	$s3, 16($sp)		#
	sw	$s2, 12($sp)		#
	sw	$s1, 8($sp)		# Pixel fondo
	sw	$s0, 4($sp)		# Imagen *img
	sw	$ra, 0($sp)

	move	$s0, $a0		# Imagen *img
	lw	$s5, 0($s0)		# img->ancho
	lw	$s4, 4($s0)		# img->alto
	move	$s1, $a1		# Pixel fondo
	li	$s2, 0			# int y = 0

B3_0:	bge	$s2, $s4, B3_5		# for (int y = 0; y < img->alto; ++y) {
	li	$s3, 0			# int x = 0
B3_1:	bge	$s3, $s5, B3_2		# for (int x = 0; x < img->ancho; ++x) {

	move	$a0, $s0
	move	$a1, $s3
	move	$a2, $s2
	move	$a3, $s1
	jal	imagen_set_pixel
	addi	$s3, $s3, 1
	j	B3_1

B3_2:	addi	$s2, $s2, 1
	j	B3_0

B3_5:	lw	$s5, 24($sp)
	lw	$s4, 20($sp)
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 28
	jr	$ra



imagen_init:				# ($a0, $a1, $a2, $a3) = (img, ancho, alto, fondo)
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	sw	$a1, 0($a0)		# img->ancho = ancho;
	sw	$a2, 4($a0)		# img->alto = alto;

	# $a0 -> Imagen *img
	move	$a1, $a3
	jal	imagen_clean

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



imagen_copy:				# ($a0, $a1) = (dst, src)
	addi	$sp, $sp, -28
	sw	$s5, 24($sp)
	sw	$s4, 20($sp)
	sw	$s3, 16($sp)		# int y = 0
	sw	$s2, 12($sp)		# int x = 0
	sw	$s1, 8($sp)		# Imagen *src
	sw	$s0, 4($sp)		# Imagen *dst
	sw	$ra, 0($sp)

	move	$s0, $a0		# Imagen *dst
	move	$s1, $a1		# Imagen *src

	lw	$s4, 0($s1)		# src->ancho;
	sw	$s4, 0($s0)		# dst->ancho = src->ancho;
	lw	$s5, 4($s1)		# src->alto;
	sw	$s5, 4($s0)		# dst->alto = src->alto;

	li	$s3, 0			# int y = 0

	# for (int y = 0; y < src->alto; ++y) {
B5_0:	bge	$s3, $s5, B5_3
	li	$s2, 0			# int x = 0
	#for (int x = 0; x < src->ancho; ++x) {
B5_1:	bge	$s2, $s4, B5_2
	move	$a0, $s1		#Imagen *img
	move	$a1, $s2			#int x
	move	$a2, $s3			#int y
	jal	imagen_get_pixel

	move	$a0, $s0
	move	$a1, $s2
	move	$a2, $s3
	move	$a3, $v0	#PRECAUCION, REVISAR SI GUARDAR EN S
	jal	imagen_set_pixel

	addi	$s2, $s2, 1
	j	B5_1

B5_2:	addi	$s3, $s3, 1
	j	B5_0

B5_3:	lw	$s5, 24($sp)
	lw	$s4, 20($sp)
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 28
	jr	$ra



imagen_print:				# $a0 = img
	addiu	$sp, $sp, -24
	sw	$ra, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	move	$s0, $a0
	lw	$s3, 4($s0)		# img->alto
	lw	$s4, 0($s0)		# img->ancho
        #  for (int y = 0; y < img->alto; ++y)
	li	$s1, 0			# y = 0
B6_2:	bgeu	$s1, $s3, B6_5		# acaba si y ≥ img->alto
	#    for (int x = 0; x < img->ancho; ++x)
	li	$s2, 0			# x = 0
B6_3:	bgeu	$s2, $s4, B6_4		# acaba si x ≥ img->ancho
	move	$a0, $s0		# Pixel p = imagen_get_pixel(img, x, y)
	move	$a1, $s2
	move	$a2, $s1
	jal	imagen_get_pixel
	move	$a0, $v0		# print_character(p)
	jal	print_character
	addiu	$s2, $s2, 1		# ++x
	j	B6_3
	#    } // for x
B6_4:	li	$a0, 10			# print_character('\n')
	jal	print_character
	addiu	$s1, $s1, 1		# ++y
	j	B6_2
	#  } // for y
B6_5:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$ra, 20($sp)
	addiu	$sp, $sp, 24
	jr	$ra



imagen_dibuja_imagen:			# ($a0, $a1, $a2, $a3) = (*dst, *src, dst_x, dst_y)
	addi	$sp, $sp, -36
	sw	$s7, 32($sp)		# src->alto;
	sw	$s6, 28($sp)		# src->ancho;
	sw	$s5, 24($sp)		# int y
	sw	$s4, 20($sp)		# int x
	sw	$s3, 16($sp)		# int dst_y
	sw	$s2, 12($sp)		# int dst_x
	sw	$s1, 8($sp)		# Imagen *src
	sw	$s0, 4($sp)		# Imagen *dst
	sw	$ra, 0($sp)

	move	$s0, $a0		# Imagen *dst
	move	$s1, $a1		# Imagen *src
	move	$s2, $a2		# int dst_x
	move	$s3, $a3		# int dst_y
	li	$s5, 0			# int y
	lw	$s6, 0($s1)		# src->ancho;
	lw	$s7, 4($s1)		# src->alto;

B7_0:	bge	$s5, $s7, B7_5
	li	$s4, 0			# int x
B7_1:	bge	$s4, $s6, B7_2

	move	$a0, $s1
	move	$a1, $s4
	move	$a2, $s5
	jal	imagen_get_pixel
	beqz	$v0, B7_3

	move	$a0, $s0
	add	$a1, $s2, $s4		#dst_x + x
	add	$a2, $s3, $s5		#dst_y + y
	move	$a3, $v0
	jal	imagen_set_pixel	#imagen_set_pixel(dst, dst_x + x, dst_y + y, p);

B7_3:	addi	$s4, $s4, 1
	j	B7_1

B7_2:	addi	$s5, $s5, 1
	j	B7_0

B7_5:
	lw	$s7, 32($sp)
	lw	$s6, 28($sp)
	lw	$s5, 24($sp)
	lw	$s4, 20($sp)
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 36
	jr	$ra



imagen_dibuja_imagen_rotada:
	addi	$sp, $sp, -36
	sw	$s7, 32($sp)		# src->alto;
	sw	$s6, 28($sp)		# src->ancho;
	sw	$s5, 24($sp)		# int y
	sw	$s4, 20($sp)		# int x
	sw	$s3, 16($sp)		# int dst_y
	sw	$s2, 12($sp)		# int dst_x
	sw	$s1, 8($sp)		# Imagen *src
	sw	$s0, 4($sp)		# Imagen *dst
	sw	$ra, 0($sp)

	move	$s0, $a0		# Imagen *dst
	move	$s1, $a1		# Imagen *src
	move	$s2, $a2		# int dst_x
	move	$s3, $a3		# int dst_y
	li	$s5, 0			# int y
	lw	$s6, 0($s1)		# src->ancho;
	lw	$s7, 4($s1)		# src->alto;

B8_0:	bge	$s5, $s7, B8_5
	li	$s4, 0			# int x
B8_1:	bge	$s4, $s6, B8_2

	move	$a0, $s1
	move	$a1, $s4
	move	$a2, $s5
	jal	imagen_get_pixel
	beqz	$v0, B8_3

	move	$a0, $s0		# dst
	add	$a1, $s2, $s7		# dst_x + src->alto - 1 - y
	addi	$a1, $a1, -1
	sub	$a1, $a1, $s5
	add	$a2, $s3, $s4		# dst_y + x
	move	$a3, $v0		# p
	jal	imagen_set_pixel	#imagen_set_pixel(dst, dst_x + x, dst_y + y, p);

B8_3:	addi	$s4, $s4, 1
	j	B8_1

B8_2:	addi	$s5, $s5, 1
	j	B8_0

B8_5:
	lw	$s7, 32($sp)
	lw	$s6, 28($sp)
	lw	$s5, 24($sp)
	lw	$s4, 20($sp)
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 36
	jr	$ra


pieza_aleatoria:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$a0, 0
	li	$a1, 7
	jal	random_int_range	# $v0 = random_int_range(0, 7)
	sll	$t1, $v0, 2
	la	$v0, piezas
	addu	$t1, $v0, $t1		# $t1 = piezas + $v0*4
	lw	$v0, 0($t1)		# $v0 = piezas[$v0]
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra


actualizar_pantalla:
	addiu	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	la	$s0, pantalla
	la	$s2, campo
	move	$a0, $s0
	li	$a1, ' '
	jal	imagen_clean		# imagen_clean(pantalla, ' ')
	#######################################################################################################################
	jal	calcula_marcador



	#######################################################################################################################
        # for (int y = 0; y < campo->alto; ++y) {
	lw	$t1, 4($s2)		# campo->alto
	beqz	$t1, B10_3		# sale del bucle si campo->alto == 0
	li	$s1, 0			# y = 0
B10_2:	addiu	$s1, $s1, 1		# ++y
	move	$a0, $s0
	li	$a1, 0
	move	$a2, $s1
	li	$a3, '|'
	jal	imagen_set_pixel	# imagen_set_pixel(pantalla, 0, y, '|')
	lw	$t1, 0($s2)		# campo->ancho
	move	$a0, $s0
	addiu	$a1, $t1, 1		# campo->ancho + 1
	move	$a2, $s1
	li	$a3, '|'
	jal	imagen_set_pixel	# imagen_set_pixel(pantalla, campo->ancho + 1, y, '|')
	lw	$t1, 4($s2)		# campo->alto
	bltu	$s1, $t1, B10_2		# sigue si y < campo->alto
        # } // for y
	# for (int x = 0; x < campo->ancho + 2; ++x) {
B10_3:	li	$s1, 0			# x = 0
B10_5:	lw	$t1, 4($s2)		# campo->alto
	move	$a0, $s0
	move	$a1, $s1
	addiu	$a2, $t1, 1		# campo->alto + 1
	li	$a3, '-'
	jal	imagen_set_pixel	# imagen_set_pixel(pantalla, x, campo->alto + 1, '-')
	addiu	$s1, $s1, 1		# ++x
	lw	$t1, 0($s2)		# campo->ancho
	addiu	$t1, $t1, 2		# campo->ancho + 2
	bltu	$s1, $t1, B10_5		# sigue si x < campo->ancho + 2
        # } // for x
B10_6:	la	$s0, pantalla
	move	$a0, $s0
	move	$a1, $s2
	li	$a2, 1
	li	$a3, 1
	jal	imagen_dibuja_imagen	# imagen_dibuja_imagen(pantalla, campo, 1, 1)
	lw	$t1, pieza_actual_y
	lw	$v0, pieza_actual_x
	move	$a0, $s0
	la	$a1, pieza_actual
	addiu	$a2, $v0, 1		# pieza_actual_x + 1
	addiu	$a3, $t1, 1		# pieza_actual_y + 1
	jal	imagen_dibuja_imagen	# imagen_dibuja_imagen(pantalla, pieza_actual, pieza_actual_x + 1, pieza_actual_y + 1)
	jal	clear_screen		# clear_screen()
	move	$a0, $s0
	jal	imagen_print		# imagen_print(pantalla)
	lb	$t0, imprimir_mensaje
	beqz	$t0, B10_7
	jal	fin_partida
B10_7:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$ra, 12($sp)
	addiu	$sp, $sp, 16
	jr	$ra



nueva_pieza_actual:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	jal	pieza_aleatoria		# Imagen *elegida = pieza_aleatoria();
	la	$a0, pieza_actual
	move	$a1, $v0
	la	$a1, pieza_barra	#BORRAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
	jal	imagen_copy
	la	$t0, pieza_actual_x	# pieza_actual_x = 8;
	li	$t1, 8
	sw	$t1, 0($t0)

	la	$t0, pieza_actual_y	# pieza_actual_y = 0;
	li 	$t1, 0
	sw	$t1, 0($t0)

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



probar_pieza:				# ($a0, $a1, $a2) = (pieza, x, y)
	addiu	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$s7, 24($sp)
	sw	$s6, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	move	$s0, $a2		# y
	move	$s1, $a1		# x
	move	$s2, $a0		# pieza
	li	$v0, 0
	bltz	$s1, B12_13		# if (x < 0) return false
	lw	$t1, 0($s2)		# pieza->ancho
	addu	$t1, $s1, $t1		# x + pieza->ancho
	la	$s4, campo
	lw	$v1, 0($s4)		# campo->ancho
	bltu	$v1, $t1, B12_13	# if (x + pieza->ancho > campo->ancho) return false
	bltz	$s0, B12_13		# if (y < 0) return false
	lw	$t1, 4($s2)		# pieza->alto
	addu	$t1, $s0, $t1		# y + pieza->alto
	lw	$v1, 4($s4)		# campo->alto
	bltu	$v1, $t1, B12_13	# if (campo->alto < y + pieza->alto) return false
	# for (int i = 0; i < pieza->ancho; ++i) {
	lw	$t1, 0($s2)		# pieza->ancho
	beqz	$t1, B12_12
	li	$s3, 0			# i = 0
	#   for (int j = 0; j < pieza->alto; ++j) {
	lw	$s7, 4($s2)		# pieza->alto
B12_6:	beqz	$s7, B12_11
	li	$s6, 0			# j = 0
B12_8:	move	$a0, $s2
	move	$a1, $s3
	move	$a2, $s6
	jal	imagen_get_pixel	# imagen_get_pixel(pieza, i, j)
	beqz	$v0, B12_10		# if (imagen_get_pixel(pieza, i, j) == PIXEL_VACIO) sigue
	move	$a0, $s4
	addu	$a1, $s1, $s3		# x + i
	addu	$a2, $s0, $s6		# y + j
	jal	imagen_get_pixel
	move	$t1, $v0		# imagen_get_pixel(campo, x + i, y + j)
	li	$v0, 0

	bnez	$t1, B12_13		# if (imagen_get_pixel(campo, x + i, y + j) != PIXEL_VACIO) return false
B12_10:	addiu	$s6, $s6, 1		# ++j
	bltu	$s6, $s7, B12_8		# sigue si j < pieza->alto
        #   } // for j
B12_11:	lw	$t1, 0($s2)		# pieza->ancho
	addiu	$s3, $s3, 1		# ++i
	bltu	$s3, $t1, B12_6 	# sigue si i < pieza->ancho
        # } // for i
B12_12:	li	$v0, 1			# return true
B12_13:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s6, 20($sp)
	lw	$s7, 24($sp)
	lw	$ra, 28($sp)
	addiu	$sp, $sp, 32
	jr	$ra


intentar_movimiento:			# ($a0, $a1) = (x, y)
	addiu	$sp, $sp, -12
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)

	move	$s0, $a0		# int x
	move	$s1, $a1		# int y
	move	$a1, $s0
	move	$a2, $s1
	la	$a0, pieza_actual
	jal	probar_pieza
	beqz	$v0, B13_0		# if (probar_pieza(pieza_actual, x, y)) { == if(1/True)..
	la	$t0, pieza_actual_x	# pieza_actual_x = x;
	sw	$s0, 0($t0)
	la	$t0, pieza_actual_y	# pieza_actual_y = y;
	sw	$s1, 0($t0)
	li	$v0, 1
	j	B13_1

B13_0:	li	$v0, 0

B13_1:	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra



bajar_pieza_actual:			# (void)
	addiu	$sp, $sp, -12
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)

	lw	$s0, pieza_actual_x
	lw	$s1, pieza_actual_y
	move	$a0, $s0
	addi	$a1, $s1, 1
	jal	intentar_movimiento

	bnez	$v0, B14_1
	la	$a0, campo
	la	$a1, pieza_actual
	move	$a2, $s0
	move	$a3, $s1
	jal	imagen_dibuja_imagen

	jal	calcula_completado_lineas

	jal	nueva_pieza_actual

	jal	calcula_fin_partida	# calcula fin de partida y actualiza marcador

B14_1:	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra



intentar_rotar_pieza_actual:		#(void)
	addiu	$sp, $sp, -12
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)

	la	$s0, imagen_auxiliar	# Imagen *pieza_rotada = imagen_auxiliar;
	la	$s1, pieza_actual	#

	move	$a0, $s0		# pieza_rotada
	lw	$a1, 4($s1)		# pieza_actual->alto
	lw	$a2, 0($s1)		# pieza_actual->ancho
	move	$a3, $zero		# PIXEL_VACIO
	jal	imagen_init		# imagen_init(pieza_rotada, pieza_actual->alto, pieza_actual->ancho, PIXEL_VACIO);

	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $zero
	move	$a3, $zero
	jal	imagen_dibuja_imagen_rotada	# magen_dibuja_imagen_rotada(pieza_rotada, pieza_actual, 0, 0)

	move	$a0, $s0
	lw	$a1, pieza_actual_x
	lw	$a2, pieza_actual_y
	jal	probar_pieza

	move	$a0, $s1
	move	$a1, $s0
	beqz	$v0, B15_1
	jal	imagen_copy

B15_1:	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra



tecla_salir:
	li	$v0, 1
	sb	$v0, acabar_partida	# acabar_partida = true
	jr	$ra



tecla_izquierda:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	lw	$a1, pieza_actual_y
	lw	$t1, pieza_actual_x
	addiu	$a0, $t1, -1
	jal	intentar_movimiento	# intentar_movimiento(pieza_actual_x - 1, pieza_actual_y)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



tecla_derecha:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	lw	$a1, pieza_actual_y
	lw	$t1, pieza_actual_x
	addiu	$a0, $t1, 1
	jal	intentar_movimiento	# intentar_movimiento(pieza_actual_x + 1, pieza_actual_y)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



tecla_abajo:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	bajar_pieza_actual	# bajar_pieza_actual()
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



tecla_rotar:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	intentar_rotar_pieza_actual	# intentar_rotar_pieza_actual()
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



procesar_entrada:
	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s4, 12($sp)
	sw	$s3, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	jal	keyio_poll_key
	move	$s0, $v0		# int c = keyio_poll_key()
        # for (int i = 0; i < sizeof(opciones) / sizeof(opciones[0]); ++i) {
	li	$s1, 0			# i = 0, $s1 = i * sizeof(opciones[0]) // = i * 8
	la	$s3, procesar_entrada.opciones
	li	$s4, 40			# sizeof(opciones) // == 5 * sizeof(opciones[0]) == 5 * 8
B21_1:	addu	$t1, $s3, $s1		# procesar_entrada.opciones + i*8
	lb	$t2, 0($t1)		# opciones[i].tecla
	bne	$t2, $s0, B21_3		# if (opciones[i].tecla != c) siguiente iteración
	lw	$t2, 4($t1)		# opciones[i].accion
	jalr	$t2			# opciones[i].accion()
	jal	actualizar_pantalla	# actualizar_pantalla()
B21_3:	addiu	$s1, $s1, 8		# ++i, $s1 += 8
	bne	$s1, $s4, B21_1		# sigue si i*8 < sizeof(opciones)
        # } // for i
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s3, 8($sp)
	lw	$s4, 12($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20
	jr	$ra



jugar_partida:
	addiu	$sp, $sp, -16
	sw	$s2, 12($sp)
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	#inicializo a 0 el marcador
	lw	$t0, num_punt		# aumentar marcador en 1
	li	$t1, 0
	sw	$t0, num_punt
	#inicializamos el tiempo
	la	$t0, tiempo	# direccion de tiempo
	li	$t1, 1001		#1001
	sw	$t1, 0($t0)	#valor de tiempo

	la	$a0, pantalla
	li	$a1, 20
	li	$a2, 22
	li	$a3, 32
	jal	imagen_init		# imagen_init(pantalla, 20, 22, ' ')
	la	$a0, campo
	li	$a1, 14
	li	$a2, 20
	li	$a3, 0
	jal	imagen_init		# imagen_init(campo, 14, 20, PIXEL_VACIO)
	jal	nueva_pieza_actual	# nueva_pieza_actual()
	sb	$zero, acabar_partida	# acabar_partida = false
	jal	get_time		# get_time()
	move	$s0, $v0		# Hora antes = get_time()
	jal	actualizar_pantalla	# actualizar_pantalla()
	j	B22_2
        # while (!acabar_partida) {
B22_2:	lbu	$t1, acabar_partida
	bnez	$t1, B22_5		# if (acabar_partida != 0) sale del bucle
	jal	procesar_entrada	# procesar_entrada()
	jal	get_time		# get_time()
	move	$s1, $v0		# Hora ahora = get_time()
	subu	$t1, $s1, $s0		# int transcurrido = ahora - antes
	lw	$s2, tiempo		# int pausa = 1000;
	bltu	$t1, $s2, B22_2		# if (transcurrido < pausa + 1) siguiente iteración
B22_1:	jal	bajar_pieza_actual	# bajar_pieza_actual()
	jal	actualizar_pantalla	# actualizar_pantalla()
	move	$s0, $s1		# antes = ahora
        j	B22_2			# siguiente iteración
       	# }
B22_5:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	lw	$s2, 12($sp)
	addiu	$sp, $sp, 16
	jr	$ra



integer_to_string:			# ($a0, $a1) = (n, buf)
	move 	$t0, $a1		# char *p = buff
	# for (int i = n; i > 0; i = i / base) {
	abs	$t1, $a0		#move	$t1, $a0		# int i = n
	bnez	$t1, B24_3
	li	$t2, 0
	addiu	$t2, $t2, '0'
	sb 	$t2, 0($t0)
	sb	$zero, 1($t0)		# *p = '\0'
	#sub	$t0, $t0, 1
	j	B24_10

B24_3:
	blez	$t1, B24_6		# si i <= 0 salta el bucle
	li	$t7, 10
	div	$t1, $t7		# i / base
	mflo	$t1			# i = i / base
	mfhi	$t2
	blt	$t2, 10, B24_4		# d = i % base
	addiu	$t2, $t2, 'A'
	addiu	$t2, $t2, -10
	j	B24_5
B24_4:	addiu	$t2, $t2, '0'		# d + '0'
B24_5:	sb 	$t2, 0($t0)		# *p = $t2
	addiu	$t0, $t0, 1		# ++p
	j	B24_3			# sigue el bucle
	# }

B24_6:	bgtz	$a0, B24_7		# if(i<0)
	li	$t7, '-'	# t7 = '-'
	sb	$t7, 0($t0)
	addiu	$t0, $t0, 1
	sb	$zero, 0($t0)		# *p = '\0'
	sub	$t0, $t0, 1
	j	B24_8			#else
B24_7:	sb	$zero, 0($t0)		# *p = '\0'
	sub	$t0, $t0, 1

B24_8:	blt 	$t0, $a1, B24_10
	lb	$t3, 0($a1)
	lb	$t4, 0($t0)
	sb	$t3, 0($t0)
	sb	$t4, 0($a1)
	add	$a1, $a1, 1
	add	$t0, $t0, -1
	j	B24_8
B24_10:	jr	$ra



imagen_dibuja_cadena:			# ($a0, $a1, $a2, $a3) = (coord_imagen, coord_cadena, dst_x, dst_y)
	addi	$sp, $sp, -28
	sw	$s5, 24($sp)		# int y
	sw	$s4, 20($sp)		# int x
	sw	$s3, 16($sp)		# int dst_y
	sw	$s2, 12($sp)		# int dst_x
	sw	$s1, 8($sp)		# Imagen *src
	sw	$s0, 4($sp)		# QUITAR
	sw	$ra, 0($sp)

	move	$s0, $a0		# imagen
	move	$s1, $a1		# cadena
	move	$s2, $a2		# int dst_x
	move	$s3, $a3		# int dst_y
	li	$s5, 0			# int y
	li	$s4, 0			# int x

B25_0:	lb	$t0, 0($s1)		#T0 = CADENA[i]
	beqz	$t0, B25_1		# if (p != PIXEL_VACIO) {

	move	$a0, $s0		#imagen
	add	$a1, $s2, $s4		#dst_x + x
	add	$a2, $s3, $s5		#dst_y + y
	move	$a3, $t0		#cadena[i]
	jal	imagen_set_pixel	#imagen_set_pixel(dst, dst_x + x, dst_y + y, p);

	addi	$s4, $s4, 1		#x++
	addi	$s1, $s1, 1		#i++
	j	B25_0

B25_1:
	lw	$s5, 24($sp)
	lw	$s4, 20($sp)
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 28
	jr	$ra


calcula_marcador:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)

	#move $a0, $s0			# la	$s0, pantalla
	la	$a0, pantalla
	la 	$a1, puntuacion
	li 	$a2, 0
	li 	$a3, 0
	jal 	imagen_dibuja_cadena	# ($a0, $a1, $a2, $a3) = (coord_imagen, coord_cadena, dst_x, dst_y)

	lw 	$a0, num_punt		# puntuacion, en inicio = 0
	la 	$a1, buffer			# buffer en el que se convierte el integer a string
	jal 	integer_to_string		# ($a0, $a1) = (n, buf)
	la	$a0, pantalla
	#la $a1, test1
	la 	$a1, buffer
	li 	$a2, 12
	li 	$a3, 0
	jal 	imagen_dibuja_cadena	# ($a0, $a1, $a2, $a3) = (coord_imagen, coord_cadena, dst_x, dst_y)

	la	$a0, pantalla
	la 	$a1, test			# Imprime el '\n\n'
	li 	$a2, 16
	li 	$a3, 0
	jal 	imagen_dibuja_cadena	# ($a0, $a1, $a2, $a3) = (coord_imagen, coord_cadena, dst_x, dst_y)

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



#Procedimiento para calcular el calcular el aumento del tiempo, solo llamar cada 50 puntos
calcula_tiempo:			#(tiempo = tiempo - (tiempo*10/100))
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	la	$t0, tiempo	# direccion de tiempo
	li	$t1, 10		#10
	lw	$t2, 0($t0)	#valor de tiempo
	# tiempo*10
	multu	$t2, $t1
	mflo	$t1
	# ans/100
	divu	$t1, $t1, 100
	# tiempo - ans
	subu	$t2, $t2, $t1
	sw	$t2, 0($t0)	# guardamos el valor del tiempo actualizado

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



calcula_completado_lineas:#hacer que retorne true si hay que eliminar una linea
#REVISAR SI HAY ALGUNA T QUE SE PUEDA BORRAR POR LLAMAR A ESTA FUNCION
	addiu	$sp, $sp, -24
	sw	$s4, 20($sp)		#completa = 1;
	sw	$s3, 16($sp)		# campo->ancho
	sw	$s2, 12($sp)		# pieza_actual_y + pieza_actual->alto;
	sw	$s1, 8($sp)		# int x = 0
	sw	$s0, 4($sp)		# int y = pieza_actual_y
	sw	$ra, 0($sp)

	lw	$s0, pieza_actual_y		# int y = pieza_actual_y
	la	$t0, pieza_actual
	lw	$t1, 4($t0)
	add	$s2, $s0, $t1		# pieza_actual_y + pieza_actual->alto;
B26_0:	bge	$s0, $s2, B26_1		#  for (int y = pieza_actual_y; y < pieza_actual_y + pieza_actual->alto; y++) {
	li	$s1, 0			# int x = 0
	li	$s4, 1			#completa = 1;
	la	$t0, pieza_actual
	lw	$s3, 0($t0)		# campo->ancho
B26_2:	bge	$s1, $s3, B26_3		# for (int x = 0; x < campo->ancho; x++) {
	la	$a0, campo
	move	$a1, $s1
	move	$a2, $s0
	jal	imagen_get_pixel	# int p = imagen_get_pixel(campo, x, y);
	beqz	$v0, B26_4		# if (p != PIXEL_VACIO) {
	li	$s4, 0			# completa = 0;
	addi	$s1, $s1, 1		# x++
	j	B26_5
B26_4:
	addi	$s1, $s1, 1		# x++
	j	B26_2

B26_5:	li	$t0, 1			# 1
	bne	$s4, $t0, B26_3		# if(completa == 1){

	#li	$t0, 1
	#sb	$t0, acabar_partida	# acabar_partida = true

	lw	$t1, num_punt		# aumentar marcador en 10
	addi	$t1, $t1, 10
	sw	$t1, num_punt


B26_3:	addi	$s0, $s0, 1		# y++
	j	B26_0



B26_1:	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	addiu	$sp, $sp, 24
	jr	$ra



fin_partida:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	la	$a0, pantalla
	la	$a1, pieza_fin
	li	$a2, 0
	li	$a3, 5
	jal	imagen_dibuja_imagen
	jal	clear_screen		# clear_screen()
	la	$a0, pantalla
	jal	imagen_print		# imagen_print(pantalla)

	jal	read_character


	li	$t0, 1
	sb	$t0, acabar_partida	# acabar_partida = true

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



calcula_fin_partida:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	#if llamada a intentar_movimiento
	lw	$a0, pieza_actual_x
	lw	$a1, pieza_actual_y #AVERIGUAR VALOR PARA NO TENER QUE CARGAR EN MEMORIA ###################
	addi	$a1, $a1, 1
	jal	intentar_movimiento	# ($a0, $a1) = (x, y)


	#li 	$v0, 0			# BORAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	bnez	$v0, B27_0		# if(!intentar_movimiento)
	li	$t0, 1
	sb	$t0, imprimir_mensaje	# acabar_partida = true

B27_0:	lw	$t1, num_punt		# aumentar marcador en 1
	addi	$t1, $t1, 1
	sw	$t1, num_punt

	#calcular si el marcador es multiplo de 50
	la	$t0, tiempo	# direccion de tiempo
	lw	$t1, 0($t0)	#valor de tiempo
	li	$t2, 50		# multiplp 50
	divu	$t1, $t2
	mfhi	$t0
	bnez	$t0, B27_1	#if(tiempo != 0)
	jal	calcula_tiempo

B27_1:	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra



	.globl	main
main:					# ($a0, $a1) = (argc, argv)
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
B23_2:	jal	clear_screen		# clear_screen()
	la	$a0, str000
	jal	print_string		# print_string("Tetris\n\n 1 - Jugar\n 2 - Salir\n\nElige una opcion:\n")
	jal	read_character		# char opc = read_character()
	beq	$v0, '2', B23_1		# if (opc == '2') salir
	bne	$v0, '1', B23_5		# if (opc != '1') mostrar error
	jal	jugar_partida		# jugar_partida()
	j	B23_2
B23_1:	la	$a0, str001
	jal	print_string		# print_string("\n¡Adios!\n")
	li	$a0, 0
	jal	mips_exit		# mips_exit(0)
	j	B23_2
B23_5:	la	$a0, str002
	jal	print_string		# print_string("\nOpcion incorrecta. Pulse cualquier tecla para seguir.\n")
	jal	read_character		# read_character()
	j	B23_2
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

#
# Funciones de la librería del sistema
#

print_character:
	li	$v0, 11
	syscall
	jr	$ra


print_string:
	li	$v0, 4
	syscall
	jr	$ra


get_time:
	li	$v0, 30
	syscall
	move	$v0, $a0
	move	$v1, $a1
	jr	$ra


read_character:
	li	$v0, 12
	syscall
	jr	$ra


clear_screen:
	li	$v0, 39
	syscall
	jr	$ra


mips_exit:
	li	$v0, 17
	syscall
	jr	$ra


random_int_range:
	li	$v0, 42
	syscall
	move	$v0, $a0
	jr	$ra


keyio_poll_key:
	li	$v0, 0
	lb	$t0, 0xffff0000
	andi	$t0, $t0, 1
	beqz	$t0, keyio_poll_key_return
	lb	$v0, 0xffff0004


keyio_poll_key_return:
	jr	$ra
