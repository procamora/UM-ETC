# Programa con procedimientos para mostrar cómo realizar el paso de
# parámetros y el uso de la pila en distintas situaciones
        
        .data
msg_cr: .asciiz "\n"
        
        .text
main:   
        addi    $sp, $sp, -4
        sw      $ra, 0($sp)

        # llama a proc1()
        jal     proc1
        
        li      $v0, 10
        syscall

        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
        jr      $ra
            
# proc1: no recibe ni devuelve nada
proc1:
        addi    $sp, $sp, -12
        sw      $s1, 8($sp)
        sw      $s0, 4($sp)
        sw      $ra, 0($sp)

        # llama a proc2(3, 4, 5)
        li      $a0, 3
        li      $a1, 4
        li      $a2, 5
        jal     proc2
        move    $s0, $v0   # Primer valor devuelto por proc2
        move    $s1, $v1   # Segundo valor devuelto por proc2

        # imprime los resultados en orden inverso
        move    $a0, $s1
        jal     printlnInt
        move    $a0, $s0
        jal     printlnInt

        # llama a proc3(8, 7, 6, 5, 4, 3)
        li      $a0, 8
        li      $a1, 7
        li      $a2, 6
        li      $a3, 5
        # Los dos argumentos restantes se pasan usando la pila
        addi    $sp, $sp, -8 # Hace sitio en la pila 
        li      $t0, 4
        sw      $t0, 0($sp)  # Quinto argumento: 4
        li      $t0, 3
        sw      $t0, 4($sp)  # Sexto argumento: 3
        jal     proc3
        addi    $sp, $sp, 8  # Devuelve el espacio a la pila 

        # imprime el resultado
        move    $a0, $v0
        jal     printlnInt
        
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        addi    $sp, $sp, 12
        jr      $ra


# proc2: recibe tres enteros (x, y, z) y devuelve dos (x + y + z, x * y * z)
proc2:
        add     $v0, $a0, $a1
        add     $v0, $v0, $a2
        mul     $v1, $a0, $a1
        mul     $v1, $v1, $a2
        jr      $ra


# proc3: recibe seis enteros y devuelve uno (la suma de todos)
proc3:
        add     $v0, $a0, $a1
        add     $v0, $v0, $a2
        add     $v0, $v0, $a3
        lw      $t0, 0($sp)   # El quinto parámetro está en la cima de la pila
        add     $v0, $v0, $t0
        lw      $t1, 4($sp)   # Y el sexto parámetro en la siguiente posición
        add     $v0, $v0, $t1
        jr      $ra


# imprime un entero (recibido en $a0) y un retorno de carro
printlnInt:
        li $v0, 1 # el entero a imprimir ya se encuentra en $a0
        syscall
        la $a0, msg_cr # dirección de la cadena "\n"
        li $v0, 4
        syscall
        jr $ra
