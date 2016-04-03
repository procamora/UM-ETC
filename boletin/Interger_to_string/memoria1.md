





###Parte 1
Me ha parecido la parte mas compleja por la necesidad de usar las operaciones *lb* y *sb* ya que en ese momento aun no terminaba de entender bien su funcionamiento.


###Parte 2
Lo que mas me ha costado de esta parte ha sido darme cuenta de que para añadir el *\0* al final tenia que sumar 1 en vez de 4, ya que es un byte y no un integer.
```
addiu	$t0, $t0, 1
sb	$zero, 0($t0)		# *p = '\0'
```

###Parte 3
Esta parte no ha supuesto ningún problema ya que solamente fue poner un if al principio para comprobar si el numero era 0.



###Parte 4

Esta parte ha sido trivial implementarla partiendo de la anterior.