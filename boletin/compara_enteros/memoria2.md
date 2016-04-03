


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

El principal problema que he tenido era que cuando inicializaba el vector con un tamaño inferior al anterior al hacer las comparaciones me cogia 1 numero de mas del otro vector, por lo que al hacer la comparación estaba con un operador de mas, estuve repasando todos los comparadores para ver si encontraba algun error pero no lo encontre, asi que lo que hice fue en la funcion, antes de llenarla con los nuevos numeros poner todo el vector anterior con `\0`


