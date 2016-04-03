


###compara_enteros:
Esta función ha sido trivial de implementar, lo he hecho a la primera.




###compara_vector_con_escalar:

Algunas erratas que he cometido en esta función y que mas tarde averigue son:
1. Apilar y desapilar $a0 porque pensaba que era necesario.
2. En el for tenia puesto `bgt` en vez de `bge`
`CS_for:	bge	$s0, $s6, CS_fin`
3. Las 3 operaciones de suma las hacia al principio, me confundi por el `++i` del bucle `for`
```
addi	$s2, $s2, 1
addi	$s0, $s0, 1	#++i
addi	$s1, $s1, 4	#entero + 4
```


###inicializa_vector:




