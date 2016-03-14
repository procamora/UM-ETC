
	.data	
	.align	2
enteros:
	.word	16
	.word	2
	.word	5
	.word	3344
	.word	655
	.word	4294967222
	.word	53
	.word	23
	.word	14
	.word	4294966291
	.word	34
	.word	25
	.word	26
	.word	7
	.word	8
	.word	2
	.word	83
        .space	956	# (255 - 16) elementos de 4 bytes
cadena_resultado:
	.space	256
str000:
	.asciiz		"Introduce el nimero de elementos del array: "
str001:
	.asciiz		"Error: el valor introducido para el numero de elementos no esta soportado."
str002:
	.asciiz		"Introduce el maximo valor absoluto aleatorio: "
str003:
	.asciiz		"Error: el valor introducido para el maximo no esta soportado."
str004:
	.asciiz		"\Practica 3 de ensamblador de ETC\n"
str005:
	.asciiz		"\nActualmente hay "
str006:
	.asciiz		" numeros en el vector: "
str007:
	.asciiz		" "
str008:
	.asciiz		"\n"
str009:
	.asciiz		"\n 1 - Comparar los elementos del vector con un escalar\n 2 - Rellenar el vector con valores aleatorios\n 3 - Salir\n\nElige una opcion: "
str010:
	.asciiz		"Introduce el escalar con el que quieres comparar: "
str011:
	.asciiz		"El resultado de comparar cada elemento con el escalar es: "
str012:
	.asciiz		"Adios!\n"
str013:
	.asciiz		"Opcion incorrecta. Pulse cualquier tecla para seguir.\n"

	.text	

# random_int_max(max) devuelve un numero aleatorio entre 0 y max-1 (inclusive)
random_int_max:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	move	$a1, $a0
	li	$a0, 0
	jal	random_int_range
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

# compara_enteros(a, b) devuelve -1 si a < b, 0 si a == b y 1 si a > b 
compara_enteros:
	beq	$a0, $a1, CE_eq
	blt	$a0, $a1, CE_less
	li	$v0, 1
	j	CE_ex
	
CE_eq:	li	$v0, 0
	j	CE_ex
	
CE_less:	li	$v0, -1
	
CE_ex:	jr	$ra	
	

# compara_vector_con_escalar(escalar) compara los elementos del vector
# global �enteros� con respecto al escalar recibido y almacena los
# resultados en la cadena global �cadena_resultado�.  Debera
# almacenar en la posicion iésima de la cadena un caracter '<',
# '=' o '>' si el elemento iesimo de �enteros� es menor, igual o
# mayor respectivamente que �escalar�. El array
# <<cadena_resultado>> debe quedar como una cadena valida de la
# misma logitud que <<enteros>> (debe acabar con '\0') */
compara_vector_con_escalar:
	addi    $sp, $sp, -24
	sw      $a0, 20($sp)
	sw      $s7, 16($sp)
	sw      $s2, 12($sp)
        sw      $s1, 8($sp)
        sw      $s0, 4($sp)
        sw      $ra, 0($sp)

	#AÑADIR S6/S2 EN LA PILA
	la	$s7, enteros
	lw	$s1, 0($s7)		# int lon = enteros.tam;
	
	la	$s2, cadena_resultado

	
CS_for:	bgt	$s0, $s1, CS_fin	#for (int i = 0; i < lon; ++i) {
	addi	$s0, $s0, 1		#++i
	
	#int c = compara_enteros(enteros.datos[i], escalar);
	addi	$s1, $s1, 4		#entero + 4
	move	$a1, $a0 
	lw	$a0, 0($s1)
	jal	compara_enteros
	move	$t0, $v0		#int c
	li	$t1, '='		#char car = '=';
	
	bne    	$t0, 1, CS_mn		# if (c == 1) {
	li	$t1, '>'

CS_mn:	bne    	$t0, -1, CS_sig		#if (c == -1) {
	li	$t1, '<'


	#cadena_resultado[i] = car;
CS_sig:	addi	$s2, $s2, 1
	sb 	$s2, 0($t1)
	
	
	j	CS_for
CS_fin:

	sb	$zero, 0($s2)		#cadena_resultado[lon] = '\0';
        
        lw      $a0, 20($sp)
        lw      $s7, 16($sp)
        lw      $s2, 12($sp)
        lw      $s1, 8($sp)
        lw      $s0, 4($sp)
        lw      $ra, 0($sp)
	addi    $sp, $sp, 20
	jr	$ra
        
inicializa_vector:
	# TODO
	break

	.globl	main
main:
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	jal	clear_screen
	la	$a0, str004
	jal	print_string
B4_2:	la	$a0, str005
	jal	print_string
	lw	$a0, enteros
	jal	print_integer
	la	$a0, str006
	jal	print_string
	la	$t1, enteros
	addiu	$s1, $t1, 4
	lw	$t1, enteros
	slti	$t1, $t1, 1
	li	$s0, 0
	bnez	$t1, B4_4
B4_3:	lw	$a0, 0($s1)
	jal	print_integer
	la	$a0, str007
	jal	print_string
	addiu	$s0, $s0, 1
	lw	$t1, enteros
	slt	$t1, $s0, $t1
	addiu	$s1, $s1, 4
	bnez	$t1, B4_3
B4_4:	la	$a0, str008
	jal	print_string
	la	$a0, str009
	jal	print_string
	jal	read_character
	move	$s1, $v0
	la	$a0, str008
	jal	print_string
	beq	$s1, '3', B4_7
	bne	$s1, '2', B4_8
	jal	inicializa_vector
	la	$a0, str008
	jal	print_string
	j	B4_2
B4_7:	la	$a0, str012
	jal	print_string
	li	$a0, 0
	jal	mips_exit
	j	B4_2
B4_8:	bne	$s1, '1', B4_10
	la	$a0, str010
	jal	print_string
	jal	read_integer
	move	$a0, $v0
	jal	compara_vector_con_escalar
	la	$a0, str011
	jal	print_string
	la	$a0, cadena_resultado
	jal	print_string
        la      $a0, str008
        jal	print_string
        j       B4_2
B4_10:	la	$a0, str013
	jal	print_string
	jal	read_character	# 121     read_character(); 
	j	B4_2
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
	jr      $ra

print_integer:
	li	$v0, 1
	syscall	
	jr	$ra

read_integer:
	li	$v0, 5
	syscall	
	jr	$ra

print_string:
	li	$v0, 4
	syscall	
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
