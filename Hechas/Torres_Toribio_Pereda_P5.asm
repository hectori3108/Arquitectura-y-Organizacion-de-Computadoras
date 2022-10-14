# PRACTICA 5 REALIZADA POR JUAN TORRES VILORIA, HECTOR TORIBIO GONZALEZ Y MARIO PEREDA PUYO.
.data
	Entrada:	.space 1000
	CadenaInv:	.space 1000
	CadenaRec:	.space 1000
	Mensaje0:	.asciiz "Todo es correcto\n"
	Mensaje1:	.asciiz "Caracter incorrecto, a continuacion la suma de los anterior:\n"
	Mensaje2:	.asciiz "Numero demasiado grande\n"
.text
	la	$a0, Entrada			# Donde guardamos la entrada
	la	$a2, CadenaRec			# Cadena invertida
	li	$t0, 0				# Almacen de caracter
	li	$t2, 1				# Multiplicador
	li	$t3, 10				# Multiplicador * 10
	li	$t5, 0				# Almacen de numero
	
Pedir:						# Pedimos por teclado
	li	$t2, 1
	li	$t1, 0
	li	$a1, 1000
	li	$v0, 8
	syscall
	

	
BucleC:						# (Bucle comprobar) Comprobamos si hay algun caracter no valido
	lb	$t0, 0($a0)
	beq	$t0, $zero, ToInt
	beq	$t0, 45, Avanzo
	beq	$t0, 10, Avanzo
	blt	$t0, 48, ErrorCaracter
	bgt	$t0, 57, ErrorCaracter
Avanzo:	addi	$a0, $a0, 1
	
	j	BucleC
	
ToInt:						# Si es un numero valido, Devolvemos el string a la ultima posicion y lo pasamos a entero
		sub	$a0, $a0, 2
ToInt1:						# Pasamos a entero recorriendo hacia atras y dividiendo por 10, 100... y los vamos sumando
		lb	$t0, 0($a0)
		beq	$t0, $zero, Cuentas	# Si hemos terminado pasamos a hacer la suma con el anterior
		beq	$t0, 45, Negativo	# Si es negativo vamos a hacer el valor absoluto
		subi	$t0, $t0, 48
		multu	$t0, $t2
		mflo	$t0
		add	$t1, $t1, $t0
		mult	$t2, $t3		
		mflo	$t2
		sub	$a0, $a0, 1
		j	ToInt1

Negativo:					# Valor absoluto
		mul	$t1, $t1, -1
		j Cuentas

Cuentas:					# Sumamos el numero al anterior y llamamos a pedir de nuevo
	add	$t1, $t1, $t5
	move	$t5, $t1
	j	Pedir
ErrorCaracter:					# Si se ha introducido un caracter no valido, inicializamos parametros y llamamos a funcion para pasar de entero a string
	la	$a1, CadenaInv
	move	$a0, $t5
	
	jal	Funcion
	
	li	$v0, 4				# Imprimimos mensaje de error
	la	$a0, Mensaje1
	syscall
	
	li	$v0, 4				# Imprimimos cadena resultado
	la	$a0, CadenaRec
	syscall
	
	li	$v0, 10				# C'est fini
	syscall
	
Funcion:
		li	$t1, 0		# Registro en el que guardamos el decimal
		
		li	$t6, 0		# flag
		li	$t7, 10		# Divisor
		li	$t8, 0		# Resto
		li	$t5, 1		# Contador
		li	$t4, 45		# "-"
		
		blt	$a0, 0, Menor	# Si el número es negativo lo pasamos a Menos que hará su valor absoluto

	Cuentas1:
		div	$a0, $t7	# Dividimos entre 10
		mfhi	$t8  		# Resto a t3
		mflo	$a0		# Cociente a a0
		addi	$t8, $t8, 48	# Conversióna a ascii
		sb	$t8, 0($a1)	# Guardamos en el vector en el que se van a introducir del reves
		beq	$a0, 0, Vuelta	# Si hemos terminados de dividir, vamos a darle la vuelta al vector
		addi	$t5, $t5, 1	# Contador de caracteres +1
		addi	$a1, $a1, 1	# Sigientes 8 bits del vector
		j	Cuentas1

		 
	
	Menor:
		addi	$t6, $t6, 1	# Sumamos 1 al flag de signo
		mul	$a0, $a0, -1	# Multiplicamos el número por -1 para valor absoluto de este
		j Cuentas1
Vuelta:
	beq	$t6, 1, Signo		# Si el flag de signpo es uno, pasamos a introducir un "-" en el vector de salida
	
Bucle:	
	lb	$t2, 0($a1)		# Cargamos última posicion delo vector invertido
	sb	$t2, 0($a2)		# Introducimos esta posición en la primera posicion del vector de salida
	sub	$a1, $a1, 1		# Restamos 8 bits al vector inverso
	beq	$t5, 0, Fin		# Si el cintador es 0 se pasa al final
	add	$a2, $a2, 1		# Siguientes 8 bits del vector de salida
	sub	$t5, $t5, 1		# Restamos 1 al contador
	
	
	j Bucle
	
Signo:

	sb	$t4, 0($a2)		# Guardamos "-" en ascii en el vector de salida
	addi	$a2, $a2, 1		# Avanzamos 8 bits
	j	Bucle

Fin:
	jr	$ra			# Devolvemos flujo
	