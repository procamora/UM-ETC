        .data
msg:    .asciiz "El resultado es "      # Cadena para imprimir
msg_a:	.asciiz "Introduce el valor de a: "       # Cadena para imprimir
msg_b:	.ascii "Introduce el valor de b: \0"      # Cadena para imprimir
msg_c:	.ascii "Introduce el valor de c: \0"      # Cadena para imprimir
msg_d:	.ascii "Introduce el valor de d: \0"      # Cadena para imprimir
barra:	.asciiz "/"

	.text
# Procedimiento principal
main:   
        addi    $sp, $sp, -4    # Hace espacio en la pila
        sw      $ra, 0($sp)     # Almacena $ra en la pila
       
        la      $a0, msg_a        # Pone en $a0 la direccion de la cadena
        jal	print        
        jal	read
        move	$t0 $v0
        
        la      $a0, msg_b
        jal	print
        jal	read
        move	$t1 $v0

        la      $a0, msg_c
        jal	print
        jal	read
        move	$t2 $v0

        la      $a0, msg_d
        jal	print
        jal	read
        move	$t3 $v0

        mult	$t0, $t3	# a*d
        mflo	$t4
        mult	$t2, $t1	# c*b
        mflo	$t5
        add	$a0, $t4, $t5	# t4 + t5
        mult	$t1, $t3	# b*d
        mflo	$a1

        jal     print_resultado # Llama a print_resultado

        li      $v0, 10         # Codigo de la llamada al sistema "exit" en $v0
        syscall                 # Termina el programa
        lw      $ra, 0($sp)     # Recupera el valor de $ra de la pila
        addi    $sp, $sp, 4     # Devuelve el espacio de pila usado
        jr      $ra

#print string
print:
        li      $v0, 4          # Codigo syscall para imprimir una cadena
        syscall                 # Imprime la cadena
	jr	$ra

#read integer
read:
	li	$v0, 5
	syscall
	jr	$ra

# Procedimiento para imprimir un mensaje con el resultado. Imprime la
# cadena msg seguida del valor que se le pasa como primer argumento (en $a0)
print_resultado:
        move    $t0, $a0        # Guarda en $t0 el valor a imprimir
        move	$t1, $a1
        
        la      $a0, msg        # Pone en $a0 la direccion de la cadena
        li      $v0, 4          # Codigo syscall para imprimir una cadena
        syscall                 # Imprime la cadena

        move	$a0, $t0        # Pone en $a0 el entero a imprimir
        li	$v0, 1          # Codigo syscall para imprimir un entero
        syscall                 # Imprime el entero
        
	la      $a0, barra
        li      $v0, 4
        syscall
        
        move	$a0, $t1
        li	$v0, 1
        syscall
        
        jr      $ra             # Vuelve al procedimiento invocador
