        .data
msg:    .asciiz "El resultado es "      # Cadena para imprimir
msg_a:	.asciiz "Introduce el valor de a: "       # Cadena para imprimir
msg_b:	.ascii "Introduce el valor de b: \0"      # Cadena para imprimir
#var_a:  .word   17                      # Variable inicializada a 17
#var_b:  .word   0x17                    # Variable inicializada a 23

        .text
# Procedimiento principal
main:   
        addi    $sp, $sp, -4    # Hace espacio en la pila
        sw      $ra, 0($sp)     # Almacena $ra en la pila
       
        la      $a0, msg_a        # Pone en $a0 la direccion de la cadena
        jal	print
        
        jal	read
        move	$t0 $a0
        #lw      $t0, var_a      # Carga var_a en $t0
        
        la      $a0, msg_b        # Pone en $a0 la direccion de la cadena
        jal	print
        
        jal	read
        move	$t1 $a0
        #lw      $t1, var_b      # Carga var_b en $t1
        
        add     $a0, $t0, $t1   # Suma,  resultado en $a0 para print_resultado
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
	#move	$a0 $v0 
	add	$a0, $v0, $zero
	jr	$ra
	

# Procedimiento para imprimir un mensaje con el resultado. Imprime la
# cadena msg seguida del valor que se le pasa como primer argumento (en $a0)
print_resultado:
        move    $t0, $a0        # Guarda en $t0 el valor a imprimir
        la      $a0, msg        # Pone en $a0 la direccion de la cadena
        li      $v0, 4          # Codigo syscall para imprimir una cadena
        syscall                 # Imprime la cadena
        move    $a0, $t0        # Pone en $a0 el entero a imprimir
        li      $v0, 1          # Codigo syscall para imprimir un entero
        syscall                 # Imprime el entero
        jr      $ra             # Vuelve al procedimiento invocador
