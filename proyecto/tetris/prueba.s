	.data
buffer:	.space 256
str000:	.asciiz	"Introduzca un numero (n) en base 10: "
str001:	.asciiz	": "
str002:	.asciiz	"n en base "
str003:	.asciiz	"\n"
str004:	.asciiz "-"
	
	.text
# mueve la linea siguiente justo antes de la version que desees probar

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
	#div	$t1, BASE!!!!! NO SE CUAL ES		
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



# Imprime el numero recibido en base 10 seguido de un salto de linea
test1:					# $a0 = n
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	la	$a1, buffer
	jal	integer_to_string	# integer_to_string(n, 10, buffer); 
	la	$a0, buffer
	jal	print_string		# print_string(buffer); 
	la	$a0, str003
	jal	print_string		# print_string("\n"); 
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra


	.globl	main
main:
	addiu	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$s0, 0($sp)
	la	$a0, str000
	jal	print_string		# print_string("Introduzca un numero (n) en base 10: ")
	jal	read_integer
	move	$s0, $v0		# int n = read_integer()
	move	$a0, $s0
	jal	test1			# test1(n)

	li	$a0, 0
	jal	mips_exit		# mips_exit(0)
	li	$v0, 0
	lw	$s0, 0($sp)
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8
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
