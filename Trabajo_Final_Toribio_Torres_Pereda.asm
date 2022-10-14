.data
Reves:	.space 1000
Devuelta:	.space 1000
CadenaRec:	.space 1000
.text 

	
#biblioteca de distintas funciones del trabajo final	            
atoi:
	la	$a2, CadenaRec			# Cadena invertida
	li	$t0, 0				# Almacen de caracter
	li	$t1, 0				# Almacen del numero final
	li	$t2, 1				# Multiplicador
	li	$t3, 10				# Multiplicador * 10
	li	$t5, 0				# Almacen de numero
	li	$t6, 0				# Flag de signo

	
	comp:	lb	$t0, 0($a0)
	beq	$t0, 32, siguiente
	blt	$t0, 48, Mal
	bgt	$t0, 57, Mal
	j	BucleC
	siguiente:
	addi	$a0, $a0, 1
	j	comp
						
	BucleC:						# (Bucle comprobar) Comprobamos si hay algun caracter no valido
	lb	$t0, 0($a0)
	beq	$t0, $zero, NoLetra
	beq	$t0, 45, Avanzo
	beq	$t0, 43, Avanzo
	beq	$t0, $zero, Avanzo
	blt	$t0, 48, Letra
	bgt	$t0, 57, Letra
	
	Avanzo:	sb	$t0, 0($a2)
	addiu	$a2, $a2, 1
	addiu	$a0, $a0, 1
	
	j	BucleC
	
	NoLetra:						# Si es un numero valido, Devolvemos el string a la ultima posicion y lo pasamos a entero
		subu	$a2, $a2, 1
	ToInt:						# Pasamos a entero recorriendo hacia atras y dividiendo por 10, 100... y los vamos sumando
		lb	$t0, 0($a2)
		beq	$t0, $zero, Terminamos	# Si hemos terminado pasamos a imprimir
		beq	$t0, 45, Negativo	# Si es negativo vamos a hacer el valor absoluto
		beq	$t0, 32, Avanzamos
		beq	$t0, 43, Avanzamos
		subiu	$t0, $t0, 48
		multu	$t0, $t2
		mflo	$t0
		addu	$t1, $t1, $t0
		multu	$t2, $t3		
		mflo	$t2
	Avanzamos:	subu	$a2, $a2, 1
		j	ToInt
	Letra:
		subiu	$a2, $a2, 1
		j	ToInt

	Negativo:	li	$t6, 1			# Valor absoluto
		mulu	$t1, $t1, -1
		j Terminamos
	Mal:		
		beq	$t0, 32, BucleC
		beq	$t0, 43, BucleC
		beq	$t0, 45, BucleC
		li	$v1, 2
		j	Finmalo
	Comprobamos:
		beq	$t6, 0, Finbueno
		li	$v1, 1
		move	$v0, $t1
		jr	$ra
			
	Comprobamos2:
		beq	$t6, 1, Finbueno
		li	$v1, 1
		move	$v0, $t1
		jr	$ra					
	Terminamos:	bgt	$t1, 0, Comprobamos 
		blt	$t1, 0, Comprobamos2
		li	$v1, 0

	Finbueno:	li	$v1, 0
	Finmalo:	move	$v0, $t1
		jr	$ra
itoa:
	la    $a2, Reves 
        li    $t6, 0        # flag
        li    $t2, 10        # Divisor
        li    $t3, 0        # Resto
        li    $t5, 1        # Contador
        li    $t7, 45    # Caracter "-" en ascii

        blt    $a0, 0, Menor1    # Si el número es negativo lo pasamos a Menos que hará su valor absoluto

    Cuentas1:
        divu    $a0, $t2    # Dividimos entre 10
        mfhi    $t3          # Resto a t3
        mflo    $a0        # Cociente a a0
        addiu    $t3, $t3, 48    # Conversióna a ascii
        sb    $t3, 0($a2)    # Guardamos en el vector en el que se van a introducir del reves
        beq    $a0, 0, Vuelta1    # Si hemos terminados de dividir, vamos a darle la vuelta al vector
        addiu    $t5, $t5, 1    # Contador de caracteres +1
        addiu    $a2, $a2, 1    # Sigientes 8 bits del vector
        j    Cuentas1



    Menor1:
        addiu    $t6, $t6, 1    # Sumamos 1 al flag de signo
        mulu    $a0, $a0, -1    # Multiplicamos el número por -1 para valor absoluto de este
        j Cuentas1
	Vuelta1:
    beq    $t6, 1, Signo1        # Si el flag de signpo es uno, pasamos a introducir un "-" en el vector de salida

	Bucle1:
    lb    $t1, 0($a2)        # Cargamos última posicion del vector invertido
    sb    $t1, 0($a1)        # Introducimos esta posición en la primera posicion del vector de salida
    subu    $a2, $a2, 1        # Restamos 8 bits al vector inverso
    beq    $t5, 0, Fin1        # Si el cintador es 0 se pasa al final
    addu    $a1, $a1, 1        # Siguientes 8 bits del vector de salida
    subu    $t5, $t5, 1        # Restamos 1 al contador

    j Bucle1

	Signo1:

    sb    $t7, 0($a1)        # Guardamos "-" en ascii en el vector de salida
    addiu    $a1, $a1, 1        # Avanzamos 8 bits
    j Bucle1

	Fin1:
    	jr    $ra            # RedireccionFuncion:
	
strcmp:	
	li $t0, 0	#elementos de String1
	li $t1, 0	#elsementos de String2
	
	compareStrings:			#sacar los elementos de cada string y compararlos
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	add $a0, $a0, 1
	add $a1, $a1, 1
	beq $t0, $t1, hasReachedEnd
	blt $t0, $t1, returnLessThan
	bgt $t0, $t1, returnGreaterThan
	
	hasReachedEnd:			#comprobar si hemos llegado al final del string
	beqz $t0, returnEquals
	j compareStrings
	
	returnEquals:			#devolver 0 si son iguales
	li $v0, 0
	jr $ra
	
	returnLessThan:			#si el primero es menor que el segundo devolver -1
	li $v0, -1
	jr $ra
	
	returnGreaterThan:		#si el primero es mayor que el segundo devolver 1
	li $v0, 1
	jr $ra
	
strncmp:	
	li $t0, 0		#caracter de String1
	li $t1, 0		#caracter de String2
	li $t2, 0		#contador de caracteres iguales
	bltz	$a2, noValido
	
	compareStrings2:
		beq $t2, $a2, compareOrder
		lb $t0, 0($a0)
		lb $t1, 0($a1)
		beqz $t0, compareOrder
		addiu $a0, $a0, 1
		addiu $a1, $a1, 1
		bne $t0, $t1, compareOrder
		addiu $t2, $t2, 1
		j compareStrings2
		
		compareOrder:
		beq $t0, $t1, returnEquals2
		bgt $t0, $t1, returnGreaterThan2
		j returnLessThan2
		
		returnEquals2:			#devolver 0 si son iguales
		li $v0, 0
		li	$v1, 0
		jr $ra
	
		returnLessThan2:			#si el primero es menor que el segundo devolver -1
		li $v0, -1
		li	$v1, 0
		jr $ra
	
		returnGreaterThan2:		#si el primero es mayor que el segundo devolver 1
		li	$v1, 0
		li $v0, 1
		jr $ra
		
		noValido:
		li	$v1, 1
		li	$v0, 0
		jr	$ra
	
	   
strSearch:
	li	$t0, 0		# Almacen cadena 1
	lb	$t1, 0($a1)
	li	$t3, 0		# Contador2
	la	$t4, ($a0)
	la	$t5, ($a1) 
	search:
	move	$t2, $t3
	lb	$t0, 0($t4)
	beqz	$t0, notFoundStr
	beq	$t0, $t1,possible
	addi	$t3, $t3, 1
	addi	$t4, $t4, 1
	j	search

	possible:
	addi	$t4, $t4, 1
	addi	$t5, $t5, 1
	lb	$t0, 0($t4)
	lb	$t1, 0($t5)
	addi	$t3, $t3, 1
	beqz	$t1, foundStr 
	beq	$t0, $t1, possible
	la	$t5, 0($a1)
	lb	$t1, 0($a1)
	j	search

	foundStr:
	move	$v0, $t2
	jr	$ra
	
	notFoundStr:
	li	$v0, -1
	jr	$ra

containsChar:
	li	$t0, 0
	Bucle:
	lb	$t0, 0($a0)
	beq	$t0, $zero, Noesta
	beq	$t0, $a1, Encontrado
	addi	$a0, $a0, 1
	j Bucle
	
	Noesta:
	li	$v0, 1
	jr	$ra
	Encontrado:
	li	$v0, 0
	jr	$ra
	
containsAnyChar:
	li $t0, 0			#Caracteres de String2
	li $t1, 0			#Temporal de String1
	li $t2, 0			#Caracteres de temporal de String1
	
	GetString2Char:			#Sacar cada caracter de String2 para comprobarlo
	lb $t0, 0($a1)
	beqz $t0, ReturnFalse
	la $t1, ($a0)
	addi	$a1, $a1, 1
	
	CheckChar:			#Comprobar si el caracter anterior es igual a alguno de los de String1
	lb $t2, 0($t1)
	beqz $t2, GetString2Char
	beq $t2, $t0, CharEquals
	addi $t1, $t1, 1
	j CheckChar
	
	CharEquals:			#Si hay un caracter igual devolver 0 (true)
	li $v0, 0
	jr $ra
	
	ReturnFalse:			#Sino hay devolver 1 (false)
	li $v0, 1
	jr $ra

containsSomeChars:
	li $t0, 0		#Caracteres de String1
	li $t1, 0		#Copia temporal de String2
	li $t2, 0		#Caracteres de String2
	li $t3, 0		#Contador de caracteres iguales
	la	$t4, 0($a1)	# Inicializamos puntero en a1
	bltz	$a2, returnError
	
	checkerror:
	lb	$t2, 0($t4)
	beqz	$t2, Comp
	addi	$t0, $t0, 1
	addi	$t4, $t4, 1
	j	checkerror
	
	
	Comp:
	blt	$t0, $a2, returnError
	getChar:		#Sacar los caracteres de String1
	lb $t0, 0($a1)
	beqz $t0, returnFalse
	la $t1, ($a0)
	
	checkChar:		#Comprobar si los caracteres anteriores coinciden con alguno de String2
	lb $t2, 0($t1)
	beq $t2, $t0, charEquals
	beqz $t2, nextLoop
	add $t1, $t1, 1
	j checkChar
	
	charEquals:		#Si es igual sumar 1 al contador de iguales. Si se ha llegado al numero de iguales requeridos acaba la funcion
	add $t3, $t3, 1
	beq $t3, $a2, returnTrue
	addi	$a1, $a1, 1
	
	j getChar
	
	nextLoop:		#Pasar a la siguiente posicion de String1
	addi	$a1, $a1, 1
	j getChar
	
	returnError:
	li	$v1, 1
	jr	$ra
	
	returnTrue:		#Devolver 0 (true)
	li	$v1, 0
	li $v0, 0
	jr $ra
	
	returnFalse:		#Devolver 1 (false)
	li	$v1, 0
	li $v0, 1
	jr $ra
	
containsAllChars:
	li $t0, 0		#Caracteres de String2
	li $t1, 0		#Copia temporal de los String
	li $t2, 0		#Caracteres de String1
	li $t3, 0		#Contador de caracteres de String2
	li $t4, 0		#Contador de caracteres iguales
	
	la $t1, ($a1)
	GetString2Length:	#Sacar el tamaño de String2
	lb $t0, 0($t1)
	beqz $t0, GetChar
	add $t1, $t1, 1
	add $t3, $t3, 1
	j GetString2Length
	
	GetChar:
	lb $t0, 0($a1)		#Cargamos el primer valor de string2 en $t0
	beqz $t0, End		#Si llegamos al final de String1 acabamos
	j CheckChar2
	
	CheckChar2:
	la $t1, ($a0)	#Copiamos el string1 en un temporal
	j CheckCharLoop
	CheckCharLoop:
		lb $t2, 0($t1)
		beqz $t2, ReturnFalse2		#Si hemos comprobado todos los caracteres de String2 acabamos
		beq $t2, $t0, FoundChar		#Si hemos encontrado un caracter igual acabamos la comprobacion
		add $t1, $t1, 1			#Avanzamos al siguiente caracter
		j CheckCharLoop			#Volvemos al bucle
		
	FoundChar:
		add $a1, $a1, 1			#Avanzamos a la siguiente posicion de String1
		add $t4, $t4, 1			#Sumamos 1 al contador de caracteres iguales
		j GetChar			#Volvemos a comprobar el siguiente caracter
		
	End:
		bne $t3, $t4, ReturnFalse2	#Si el contador de caracteres iguales es igual que el tamaño de String1 entonces devolvemos true
		li $v0, 0	#true = 0
		jr $ra
		
	ReturnFalse2:
		li $v0, 1	#false = 1
		jr $ra	
	
containsOnlyChars:
	li $t0, 0
	li $t1, 0
	li $t2, 0
	
	getChars:
	lb $t0, 0($a0)
	beqz $t0, returnTrue2
	la $t1, ($a1)
	j checkChar2
	
	checkChar2:
	lb $t2, 0($t1)
	beqz $t2, returnFalse2
	beq $t2, $t0, charFound
	add $t1, $t1, 1
	j checkChar2
			
	charFound:
	add $a0, $a0, 1
	j getChars
	
	returnFalse2:
	li $v0, 1
	jr $ra
	
	returnTrue2:
	li $v0, 0
	jr $ra
			
countTokens:
	li $t0, 0				# Contador de cadena
	li $t1, 0				# Contador de tokens.
	li $t2, 0				# Almacen cadena.
	li $t6, 0				# flag para saber si tengo un token al lado
	
	Bucle2:
		lb	$t2, 0($a0)
		beq	$t2, $zero, Final
		bne	$t2, $a1, Suma
		bne	$t0, 0, SumaToken
		addi	$a0, $a0, 1
		j	Bucle2
		
		
	Suma:
		addi	$t0, $t0, 1
		addi	$a0, $a0, 1
		li	$t6, 0
		j	Bucle2
	
	SumaToken:
		beq	$t6, 1, Lado
		addi	$t1, $t1, 1
	Lado:	
		li	$t6, 1
		addi	$a0, $a0, 1
		j	Bucle2
	Final:
		sub	$a0, $a0, 1
		lb	$t2, 0($a0)
		beq	$a1, $t2, Final1
		addi	$t1, $t1, 1
		
	Final1:
		move	$v0, $t1
		jr	$ra

getToken:
	li $t0, 0				# Contador de cadena
	li $t1, 0				# Contador de tokens.
	li $t5, 0				# Contador salida
	li $t2, 0				# Almacen cadena.
	li $t6, 0				# flag para saber si tengo un token al lado
	blt	$a2, 0, ErrorToken
	Bucle3:
		lb	$t2, 0($a0)
		beq	$t2, $zero, Final3
		bne	$t2, $a1, Suma3
		bne	$t0, 0, SumaToken3
		addi	$a0, $a0, 1
		j	Bucle3
	GuardoCad:
		sb	$t2, 0($a3)	
		addi	$t5, $t5, 1
		addi	$a3, $a3, 1
		addi	$a0, $a0, 1
		addi	$t0, $t0, 1
		li	$t6, 0
		j	Bucle3
	Suma3:
		beq	$a2, $t1, GuardoCad
		li	$t6, 0
		addi	$t0, $t0, 1
		addi	$a0, $a0, 1
		j	Bucle3
	SumaToken3:
		beq	$t6, 1, Lado3
		addi	$t1, $t1, 1
	Lado3:	
		li	$t6, 1
		addi	$a0, $a0, 1
		j	Bucle3
	Final3:
		bgt	$a2, $t1, ErrorToken
		sb	$zero, 0($a3)
		sub	$a3, $a3, $t5
		sub	$a0, $a0, 1
		lb	$t2, 0($a0)
		beq	$a1, $t2, Final31
		addi	$t1, $t1, 1
	Final31:
		li	$v1, 0
		jr	$ra
	ErrorToken:
		li	$v1, 1
		jr	$ra

	
splitAtToken:
		li	$t0, 0		# Almacen para el termino
	li	$t1, 0		# Alamcen de direccion de la cadena
	li	$t2, 0		# Contador de token
	bltz	$a2, MalS
	loopS:
	lb	$t0, 0($a0)
	beqz	$t0, MalS
	beq	$t0, $a1, SumaTokenS
	addi	$a0, $a0, 1
	j loopS
	
	SumaTokenS:
	addi	$t2, $t2, 1
	beq	$t2, $a2, FoundS
	addi	$a0, $a0, 1
	j	loopS

	FoundS:
	li	$v1, 0
	la	$v0, 1($a0)
	jr	$ra
	
	MalS:
	li	$v1, 1
	jr	$ra
	
sumaNumTokens:
	jr $ra			
