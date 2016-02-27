        .data
msg:    .asciiz "El resultado es "      # Cadena para imprimir
var_a:  .word   17                      # Variable inicializada a 17
var_b:  .word   0x17                    # Variable inicializada a 23

        .text
# Procedimiento principal
main:   
        addi    $sp, $sp, -4    # Hace espacio en la pila
        sw      $ra, 0($sp)     # Almacena $ra en la pila
        lw      $t0, var_a      # Carga var_a en $t0
        lw      $t1, var_b      # Carga var_b en $t1
        add     $a0, $t0, $t1   # Suma,  resultado en $a0 para print_resultado
        jal     print_resultado # Llama a print_resultado
        li      $v0, 10         # Código de la llamada al sistema "exit" en $v0
        syscall                 # Termina el programa
        lw      $ra, 0($sp)     # Recupera el valor de $ra de la pila
        addi    $sp, $sp, 4     # Devuelve el espacio de pila usado
        jr      $ra
            
# Procedimiento para imprimir un mensaje con el resultado. Imprime la
# cadena msg seguida del valor que se le pasa como primer argumento (en $a0)
print_resultado:
        move    $t0, $a0        # Guarda en $t0 el valor a imprimir
        la      $a0, msg        # Pone en $a0 la dirección de la cadena
        li      $v0, 4          # Código syscall para imprimir una cadena
        syscall                 # Imprime la cadena
        move    $a0, $t0        # Pone en $a0 el entero a imprimir
        li      $v0, 1          # Código syscall para imprimir un entero
        syscall                 # Imprime el entero
        jr      $ra             # Vuelve al procedimiento invocador
