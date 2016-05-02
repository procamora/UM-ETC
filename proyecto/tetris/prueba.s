	.data
buffer:	.space 256
str000:	.asciiz	"Introduzca un numero (n) en base 10: "
str001:	.asciiz	": "
str002:	.asciiz	"n en base "
str003:	.asciiz	"\n"
str004:	.asciiz "-"
tiempo: .word 1001
	.text
# mueve la linea siguiente justo antes de la version que desees probar


	.globl	main
main:
	addiu	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$s0, 0($sp)

	jal calcula_tiempo
	jal calcula_tiempo

	li	$a0, 0
	jal	mips_exit		# mips_exit(0)
	li	$v0, 0
	lw	$s0, 0($sp)
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra

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


read_integer:
	li	$v0, 5
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

	
	
	
	
	
	
	
	move	$s2, $s1		# int y = pieza_actual_y
	la	$t0, pieza_actual
	lw	$t1, 4($t0)
	add	$s4, $s2, $t1		# pieza_actual_y + pieza_actual->alto;
B26_0:	bge	$s2, $s4, B26_1		#  for (int y = pieza_actual_y; y < pieza_actual_y + pieza_actual->alto; y++) {
	li	$s3, 0			# int x = 0
	#completa = 1;
	la	$t0, pieza_actual
	lw	$s5, 0($t0)		# campo->ancho
B26_2:	bge	$s3, $s5, B26_3		# for (int x = 0; x < campo->ancho; x++) {

	la	$a0, campo
	move	$a1, $s3
	move	$a2, $s2
	jal	imagen_get_pixel	# int p = imagen_get_pixel(campo, x, y);
	li	$t7, 1			#completa = 1;
	beqz	$v0, B26_4		# if (p != PIXEL_VACIO) {
	li	$t7, 0			# completa = 0;
	j	B26_5
B26_4:
	addi	$s3, $s3, 1
	j	B26_2

B26_5:li	$t0, 1
	bne	$t7, $t0, B26_0		# if(completa == 1){
	la	$t0, num_punt		# aumentar marcador en 10
	lw	$t1, 0($t0)
	addi	$t1, $t1, 10
	sw	$t1, 0($t0)

B26_3:	addi	$s2, $s2, 1
	j	B26_0
	
B26_1:  lw ...
