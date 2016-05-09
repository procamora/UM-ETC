	.data
tiempo:	.word 1001
campo_x:	.word 14
campo_y:	.word 20
pantalla_x:	.word 20
pantalla_y:	.word 22

str_newline:		.asciiz "\n"
str_error:	.asciiz	"Valor incorrecto\n"

str_tam_campo_x:	.asciiz	"Introduzca la x el tamaño del campo:  "
str_tam_campo_y:	.asciiz	"Introduzca la y el tamaño del campo:  "
str_vel_inicial:	.asciiz	"Introduzca la velocidad inicial: "

info_tam_campo_x: 	.asciiz "El valor del campo en x es: "
info_tam_campo_y: 	.asciiz "El valor del campo en y es: "
info_vel_inicial: 	.asciiz "El valor de la velocidad es: "
#info_
#info_
#info_

	.text
info_actual:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	jal 	clear_screen
	la 	$a0, info_tam_campo_x
	jal 	print_string
	lw 	$a0, campo_x
	jal 	print_integer
	la 	$a0, str_newline
	jal 	print_string

	la 	$a0, info_tam_campo_y
	jal 	print_string
	lw 	$a0, campo_y
	jal 	print_integer
	la 	$a0, str_newline
	jal 	print_string

	la 	$a0, info_vel_inicial
	jal 	print_string
	lw 	$a0, tiempo
	jal 	print_integer
	la 	$a0, str_newline
	jal 	print_string

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra


calcula_campo:
	addiu	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$s0, 0($sp)

	jal 	clear_screen
B30_0:	la 	$a0, str_tam_campo_x		#
	jal 	print_string
	jal 	read_integer

	lw 	$t0, pantalla_x
	bge 	$v0, $t0, B30_0_1		# if(valor>0 and valor < pantalla_x)
	li 	$t0, 4				# tam minimo para jugar
	ble 	$v0, $t0, B30_0_1
	sw 	$v0, campo_x
	j 	B30_1
B30_0_1:
	la 	$a0, str_error
	jal 	print_string
	j 	B30_0

B30_1:	la 	$a0, str_tam_campo_y		#
	jal 	print_string
	jal 	read_integer
	lw 	$t0, pantalla_y
	bge 	$v0, $t0, B30_1_1 		# # if(valor>0 and valor < pantalla_y)
	li 	$t0, 8				# tam minimo para jugar
	ble 	$v0, $t0, B30_1_1
	sw 	$v0, campo_y
	j 	B30_3
B30_1_1:
	la 	$a0, str_error
	jal 	print_string
	j 	B30_1

B30_3:	lw	$s0, 0($sp)
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra

	.globl	main

main:
	addiu	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$s0, 0($sp)

	jal 	info_actual
	jal 	calcula_campo
	jal 	info_actual



	li	$a0, 0
	jal	mips_exit		# mips_exit(0)


	lw	$s0, 0($sp)
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra

read_integer:
	li	$v0, 5
	syscall
	jr	$ra

print_integer:
	li	$v0, 1
	syscall
	jr	$ra

print_string:
	li	$v0, 4
	syscall
	jr	$ra

mips_exit:
	li	$v0, 17
	syscall
	jr	$ra



clear_screen:
	li	$v0, 39
	syscall
	jr	$ra
