# PRACTICA 4 REALIZADA POR JUAN TORRES VILORIA, HECTOR TORIBIO GONZALEZ Y MARIO PEREDA PUYO.

.data
	Mensaje1:	.asciiz "Introduce una cadena de caracteres: "
	Mensaje2:	.asciiz "\nLa diferencia entre las veces que aparece el primer caracter y las veces que aparece el segundo es: "
	Cadena:		.space 1000
	CadenaFinal1:	.space 1000
	CadenaFinal2:	.space 1000
.text
		li	$v0, 4			# Imprimimos mensaje para pedir la cadena
		la	$a0, Mensaje1
		syscall
		
		la	$a0, Cadena		# Pedimos cadena de entrada que se guardara en "Cadena" con longitud maxima de 1000
		li	$a1, 1000		
		li	$v0, 8
		syscall
		
		la	$a2, CadenaFinal1	# Cadena en la que vamos a guardar la respuesta dada la vuelta
		la	$a3, CadenaFinal2	# Cadena donde vamos a guardar la respuesta en sentido correcto
	
		jal	Diferencia		# Llamamos a la función
		
		li	$v0, 4			# Imprimimos mensaje de salida
		la	$a0, Mensaje2
		syscall
		
		li	$v0, 4			# Imprimimos resultado
		la	$a0, CadenaFinal2
		syscall
		
		li	$v0, 10			# Fin del porgrama
		syscall
	
Diferencia:
		lb	$t0, 0($a0)		# Almacen para el primer caracter
		addi	$a0, $a0, 1
		lb	$t1, 0($a0)		# Almacen para segundo caracter
		li	$t2, 0			# Almacen para caracter sacado
		li	$t3, 1			# Contador de las que son iguales para el primero que se inicializa en 1 para contar el primero
		li	$t4, 0			# Contador de las que son iguales para el segundo que se inicializa en 0 porque vamos a contar desde el final hacia atrás
		
		li	$t6, 0			# flag
		li	$t8, 10			# Divisor
		li	$t9, 0			# Resto
		li	$t5, 1			# Contador para meter y sacar el resultado del vector
		addi	$t7, $t7, 45		# Caracter "-" en ascii
		
		
Bucle:
		lb	$t2, 0($a0)		# Cargamos primer caracter del vector empezando por la izquierda en t2
		beq	$t2, $zero, Segundo	# Si se ha acabado la cadena vamos a por la comparación del segundo caracter
		beq	$t2, $t0, Iguales1	# Si el primer caracter y el caracter sacado son iguales vamos a sumarle 1 al contador
		addi	$a0, $a0, 1		# Avanzamos 8 bits en la cadena
		j 	Bucle

		
Iguales1:					
		addi	$t3, $t3, 1		# Sumamos 1 al contador del primer caracter
		addi	$a0, $a0, 1		# Avanzamos 8 bits en la cadena
		j	Bucle

Segundo:
		subi	$a0, $a0, 2		# Pasamos a la ultima posicion del vector
		
Bucleseg:	lb	$t2, 0($a0)		# Sacamos caracter empezando por la derecha
		beq	$t2, $zero, Cuentas	# Si se termina la cadena pasamos a hacer la resta
		beq	$t2, $t1, Iguales2	# Si el caracter sacado es igual al segundo caracter sumamos 1 al contador
		subi	$a0, $a0, 1		# Restamos 8 bits a la cadena
		j	Bucleseg

		
Iguales2:
		addi	$t4, $t4, 1		# Sumamos 1 al contador del segundo caracter
		subi	$a0, $a0, 1		# Restamos 8 bits a la cadena
		j	Bucleseg

Cuentas:
		sub	$t3, $t3, $t4		# Hacemos la resta de contador del primero menos contador del segundo
		blt	$t3, 0, Menor		# Si el numero es negativo lo pasamos a Menor que hara su valor absoluto

	Division:
		div	$t3, $t8		# Dividimos entre 10
		mfhi	$t9  			# Resto a t3
		mflo	$t3			# Cociente a a0
		addi	$t9, $t9, 48		# Conversion a ascii
		sb	$t9, 0($a2)		# Guardamos en Cadenafinal1 en el que se van a introducir del reves
		beq	$t3, 0, Vuelta		# Si hemos terminados de dividir, vamos a darle la vuelta al vector
		addi	$t5, $t5, 1		# Contador de caracteres +1
		addi	$a2, $a2, 1		# Sigientes 8 bits de CadenaFinal1
		j	Division

		 
	
	Menor:
		addi	$t6, $t6, 1		# Sumamos 1 al flag de signo
		mul	$t3, $t3, -1		# Multiplicamos el número por -1 para valor absoluto de este
		j Division
		
Vuelta:
	beq	$t6, 1, Signo			# Si el flag de signpo es uno, pasamos a introducir un "-" en el vector de salida
	
Invertir:	
	lb	$t1, 0($a2)			# Cargamos última posicion del vector invertido CadenaFinal1
	sb	$t1, 0($a3)			# Introducimos esta posición en la primera posicion del vector de salida CadenaFinal2
	sub	$a2, $a2, 1			# Restamos 8 bits al vector inverso
	beq	$t5, 0, Fin			# Si el contador es 0 se pasa al final
	add	$a3, $a3, 1			# Siguientes 8 bits del vector de salida
	sub	$t5, $t5, 1			# Restamos 1 al contador
	
	
	j Invertir
	
Signo:

	sb	$t7, 0($a3)			# Guardamos "-" en ascii en el vector de salida
	addi	$a3, $a3, 1			# Avanzamos 8 bits
	j Invertir
	
Fin:
	jr	$ra				# Redireccion
	
	
	
	
	
# Función del ejercicio 1
Funcion:
		li	$t6, 0		# flag
		li	$t2, 10		# Divisor
		li	$t3, 0		# Resto
		li	$t5, 1		# Contador
		addi	$t7, $t7, 45	# Caracter "-" en ascii
		
		
		
	
		blt	$a0, 0, Menor1	# Si el número es negativo lo pasamos a Menos que hará su valor absoluto

	Cuentas1:
		div	$a0, $t2	# Dividimos entre 10
		mfhi	$t3  		# Resto a t3
		mflo	$a0		# Cociente a a0
		addi	$t3, $t3, 48	# Conversióna a ascii
		sb	$t3, 0($a2)	# Guardamos en el vector en el que se van a introducir del reves
		beq	$a0, 0, Vuelta1	# Si hemos terminados de dividir, vamos a darle la vuelta al vector
		addi	$t5, $t5, 1	# Contador de caracteres +1
		addi	$a2, $a2, 1	# Sigientes 8 bits del vector
		j	Cuentas1

		 
	
	Menor1:
		addi	$t6, $t6, 1	# Sumamos 1 al flag de signo
		mul	$a0, $a0, -1	# Multiplicamos el número por -1 para valor absoluto de este
		j Cuentas1
Vuelta1:
	beq	$t6, 1, Signo1		# Si el flag de signpo es uno, pasamos a introducir un "-" en el vector de salida
	
Bucle1:	
	lb	$t1, 0($a2)		# Cargamos última posicion delo vector invertido
	sb	$t1, 0($a1)		# Introducimos esta posición en la primera posicion del vector de salida
	sub	$a2, $a2, 1		# Restamos 8 bits al vector inverso
	beq	$t5, 0, Fin1		# Si el cintador es 0 se pasa al final
	add	$a1, $a1, 1		# Siguientes 8 bits del vector de salida
	sub	$t5, $t5, 1		# Restamos 1 al contador
	
	
	j Bucle1
	
Signo1:

	sb	$t7, 0($a1)		# Guardamos "-" en ascii en el vector de salida
	addi	$a1, $a1, 1		# Avanzamos 8 bits
	j Bucle1
	
Fin1:
	jr	$ra			# Redireccion
	

		
		
