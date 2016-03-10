        .data
buffer:	.space 256
str000:	.asciiz	"Introduzca un numero (n) en base 10: "
str001:	.asciiz	": "
str002:	.asciiz	"n en base "
str003:	.asciiz	"\n"
str004:	.asciiz "-"
        
        .text
# mueve la linea siguiente justo antes de la version que desees probar

integer_to_string_v0:			# ($a0, $a1, $a2) = (n, base, buf)
        move    $t0, $a2		# char *p = buff
	# for (int i = n; i > 0; i = i / base) {
        move	$t1, $a0		# int i = n
B0_3:   blez	$t1, B0_7		# si i <= 0 salta el bucle
	div	$t1, $a1		# i / base
	mflo	$t1			# i = i / base
	mfhi	$t2			# d = i % base
	addiu	$t2, $t2, '0'		# d + '0'
	sb	$t2, 0($t0)		# *p = $t2 
	addiu	$t0, $t0, 1		# ++p
	j	B0_3			# sigue el bucle
        # }
B0_7:	sb	$zero, 0($t0)		# *p = '\0'
B0_10:	jr	$ra


integer_to_string_v1:           	# ($a0, $a1, $a2) = (n, base, buf)
        move 	$t0, $a2		# char *p = buff
	# for (int i = n; i > 0; i = i / base) {
        move	$t1, $a0		# int i = n
        li	$t3, 0			# t3 = 0
B1_3:  
	blez	$t1, B1_7		# si i <= 0 salta el bucle
	div	$t1, $a1		# i / base
	mflo	$t1			# i = i / base
	mfhi	$t2			# d = i % base
	addiu	$t2, $t2, '0'		# d + '0'
	sb 	$t2, 0($t0)		# *p = $t2
	addiu	$t0, $t0, 1		# ++p
	j		B1_3			# sigue el bucle
        # }

B1_7:	sb	$zero, 0($t0)		# *p = '\0'
	sub	$t0, $t0, 1
B1_8:
	blt 	$t0, $a2, B1_10
	lb	$t3, 0($a2)
	lb	$t4, 0($t0)
	sb	$t3, 0($t0)
	sb	$t4, 0($a2)
	add	$a2, $a2, 1
	add	$t0 $t0, -1
	j	B1_8
B1_10:	jr	$ra

integer_to_string:
integer_to_string_v2:           	# ($a0, $a1, $a2) = (n, base, buf)
        move 	$t0, $a2		# char *p = buff
	# for (int i = n; i > 0; i = i / base) {
	abs	$t1, $a0	 	#move	$t1, $a0	# int i = n
       
B2_3:  
	blez	$t1, B2_6		# si i <= 0 salta el bucle
	div	$t1, $a1		# i / base
	mflo	$t1			# i = i / base
	mfhi	$t2			# d = i % base
	addiu	$t2, $t2, '0'		# d + '0'
	sb 	$t2, 0($t0)		# *p = $t2
	addiu	$t0, $t0, 1		# ++p
	j	B2_3			# sigue el bucle
        # }

B2_6:	bgtz	$a0, B2_7		# if(i<0)
	la	$t7, '-'	# t7 = '-'
	sb	$t7, 0($t0)
	addiu	$t0, $t0, 1
	sb	$zero, 0($t0)		# *p = '\0'
	sub	$t0, $t0, 1
	j	B2_8			#else
B2_7:	sb	$zero, 0($t0)		# *p = '\0'
	sub	$t0, $t0, 1
B2_8:
	blt 	$t0, $a2, B2_10
	lb	$t3, 0($a2)
	lb	$t4, 0($t0)
	sb	$t3, 0($t0)
	sb	$t4, 0($a2)
	add	$a2, $a2, 1
	add	$t0 $t0, -1
	j	B2_8
B2_10:	jr	$ra


integer_to_string_v3:
	
        move 	$t0, $a2		# char *p = buff
	# for (int i = n; i > 0; i = i / base) {
	abs	$t1, $a0		#move	$t1, $a0		# int i = n
        bnez	$t1, B3_3
        li	$t2, 0
        addiu	$t2, $t2, '0'
        sb 	$t2, 0($t0)
        addiu	$t0, $t0, 1		# no lo entiendo bien
        sb	$zero, 0($t0)		# *p = '\0'
        #sub	$t0, $t0, 1
        j	B3_10

B3_3:  
	blez	$t1, B3_6		# si i <= 0 salta el bucle
	div	$t1, $a1		# i / base
	mflo	$t1			# i = i / base
	mfhi	$t2			# d = i % base
	addiu	$t2, $t2, '0'		# d + '0'
	sb 	$t2, 0($t0)		# *p = $t2
	addiu	$t0, $t0, 1		# ++p
	j	B3_3			# sigue el bucle
        # }

B3_6:	bgtz	$a0, B3_7		# if(i<0)
	la	$t7, '-'	# t7 = '-'
	sb	$t7, 0($t0)
	addiu	$t0, $t0, 1
	sb	$zero, 0($t0)		# *p = '\0'
	sub	$t0, $t0, 1
	j	B3_8			#else
B3_7:	sb	$zero, 0($t0)		# *p = '\0'
	sub	$t0, $t0, 1
	
B3_8:	blt 	$t0, $a2, B3_10
	lb	$t3, 0($a2)
	lb	$t4, 0($t0)
	sb	$t3, 0($t0)
	sb	$t4, 0($a2)
	add	$a2, $a2, 1
	add	$t0 $t0, -1
	j	B3_8
B3_10:	jr	$ra

integer_to_string_v4:			# ($a0, $a1, $a2) = (n, base, buf)
	# TODO
        break
        jr	$ra

# Imprime el numero recibido en base 10 seguido de un salto de linea
test1:					# $a0 = n
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$a1, 10
	la	$a2, buffer
	jal	integer_to_string	# integer_to_string(n, 10, buffer); 
	la	$a0, buffer
	jal	print_string		# print_string(buffer); 
	la	$a0, str003
	jal	print_string		# print_string("\n"); 
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

# Imprime el numero recibido en todas las bases entre 2 y 36
test2:					# $a0 = n
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	move	$s0, $a0		# n
        # for (int b = 2; b <= 36; ++b) { 
	li	$s1, 2			# b = 2
B6_1:	la	$a0, str002
	jal	print_string		# print_string("n en base ")
	move	$a0, $s1
	li	$a1, 10
	la	$a2, buffer
	jal	integer_to_string	# integer_to_string(b, 10, buffer)
	la	$a0, buffer
	jal	print_string		# print_string(buffer)
	la	$a0, str001
	jal	print_string		# print_string(": "); 
	move	$a0, $s0
	move	$a1, $s1
	la	$a2, buffer
	jal	integer_to_string	# integer_to_string(n, b, buffer); 
	la	$a0, buffer
	jal	print_string		# print_string(buffer)
	la	$a0, str003
	jal	print_string		# print_string("\n")
	addiu	$s1, $s1, 1		# ++b
        li	$t0, 36
	ble	$s1, $t0, B6_1		# sigue el bucle si b <= 36
	# } 
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
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
	move	$a0, $s0
	jal	test2			# test2(n)
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
