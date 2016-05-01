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
