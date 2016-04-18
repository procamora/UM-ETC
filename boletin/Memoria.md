
<table width="955" height="1396">
	<tr>
		<td align="center" valign="top" style="background-image:url(http://s14.postimg.org/qzrysxvm9/portada1.png); background-size:cover; background-repeat:no-repeat; width:393;">
			<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
			
			
			<h3>06/04/2016</h3>
			
			
			<p>
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</p>
		</td>
		<td align="center" valign="top">
			<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
			
			
			<h1>Entrega Boletines de Ensamblador </h1>
			<h6>ESTRUCTURA Y TECNOLOGÍA DE COMPUTADORES</h6>
			
			
			<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
			<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
			<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
			
			
			<h5>Pablo Jose Rocamora Zamora 48743203Q</h5>
			<h5>Arturo Cordoba</h5>
			
			
		</td>
	</tr>
</table>



# Práctica 2: Interger_to_string

###Parte 1
Me ha parecido la parte más compleja por la necesidad de usar las operaciones `lb` y `sb`,  ya que en ese momento aún no terminaba de entender bien su funcionamiento.

```
lb	$t3, 0($a2)
lb	$t4, 0($t0)
sb	$t3, 0($t0)
sb	$t4, 0($a2)
```


###Parte 2
Lo que más me ha costado de esta parte, ha sido darme cuenta de que para añadir el **\0** al final tenía que sumar **1** en vez de **4**, ya que es un byte y no un integer.

```
addiu	$t0, $t0, 1
sb	$zero, 0($t0)		# *p = '\0'
```


###Parte 3
Esta parte no ha supuesto ningún problema ya que solamente fue poner un `if` al principio para comprobar si el numero era **0**.

```
abs	$t1, $a0		#move	$t1, $a0		# int i = n
bnez	$t1, B3_3
...

B3_3:  
	blez	$t1, B3_6		# si i <= 0 salta el bucle
```


###Parte 4

Esta parte ha sido trivial implementarla partiendo de la anterior.


# Práctica 3: Compara_enteros

###compara_enteros:
Esta función ha sido trivial de implementar, lo he hecho a la primera.


###compara_vector_con_escalar:

Algunas erratas que he cometido en esta función y que más tarde averigüe son:
1. Apilar y desapilar `$a0` porque pensaba que era necesario.

2. En el for tenía puesto `bgt` en vez de `bge`

	`CS_for:	bge	$s0, $s6, CS_fin`
	
3. Las 3 operaciones de suma las hacia al principio, me confundí por el `++i` del bucle `for`
```
addi	$s2, $s2, 1
addi	$s0, $s0, 1	#++i
addi	$s1, $s1, 4	#entero + 4
```


###inicializa_vector:

El principal problema que he tenido era que cuando inicializaba el vector con un tamaño inferior al anterior al hacer las comparaciones me cogía 1 número de más del otro vector, por lo que al hacer la comparación estaba con un operador de mas, estuve repasando todos los comparadores para ver si encontraba algún error pero no lo encontré, así que lo que hice fue en la función, antes de llenarla con los nuevos números poner todo el vector anterior con `\0`

```
	la	$t1, cadena_resultado
	li	$t2, 0
IV_cle:	bge	$t2, $t0, IV_fisi	# blucle para vaciar cadena_resultado
	sw	$zero, 0($t1)
	addi	$t1, $t1, 4
	addi	$t2, $t2, 1
	j	IV_cle

IV_fisi: ...
```


