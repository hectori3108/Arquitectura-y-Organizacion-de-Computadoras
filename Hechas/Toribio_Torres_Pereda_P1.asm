.data
	Vector: .space 1000
	Mensaje1: .asciiz "A continuación vas a introducir una a una las componentes de nuestro vector. \n"
	Mensaje2: .asciiz "Introduce la componente número "
	Mensaje3: .asciiz "¿Que número quiere buscar?"
	Mensaje4: .asciiz "Su número se encuentra en el índice: "
	
.text
main:

	
	li $v0, 4			# Imprimimos mensaje1
	la $a0, Mensaje1
	syscall
	
	la	$a1, Vector		# Cargamos en a1 el vector
	addi	$a2, $0, 0		# cargamos en a2 el numero a buscar en el vector (en este caso 18)
	addi	$a3, $0, 0		# cargamos en a3 la longitud del vector
	
	jal	Funcion
	
	add $a0, $v1, 0			#Impresión de resultado y fin del porgrama
	li $v0, 1
	syscall

	li	$v0, 10
	syscall
	
Funcion:
	
	li	$v0, 4			# Imprimimos mensaje2
	la 	$a0, Mensaje2
	syscall
	
	li	$v0, 1			# Imprimimos digito por el que se llega el usuario
	add	$a0, $0, $a3
	syscall
	
	li	$v0, 5			# Introduce el entero
	syscall
	
	move	$t0, $v0		# Se guarda el número en un registro
	
	blt	$t0, $0, Peticion 	# Comprobamos si es menos que 0
	
	sw	$t0, 0($a1)		# Introducciñon del nñumero en el vector
	
	addi	$a1, $a1, 4		# Siguiente posicion del vector
	addi	$a3, $a3, 1		# Incremento del número de dígitos
	
	j Funcion

Peticion:				#Petición del número a buscar 
	sll	$t4, $a3, 2
	sub	$a1, $a1, $t4
	
	li	$v0, 4
	la	$a0, Mensaje3
	syscall
	
	li	$v0, 5
	syscall
	
	move	$a2, $v0
	
#Función que construimos en el ejercicio 1 immplementada (aún que en el programa la función empieza antes ya que necesitábamos meter las peticiones dentro)
Buscar:				#revisión de números por si no está el vector
		add $t0, $a1, 0
	CheckNum:
		lw $t1, 0($t0)
		beq $t1, $a2, Start
		add $t2, $t2, 1
		beq $t2, $a3, NotFound
		add $t0, $t0, 4
		b CheckNum
	
Start:
	add $t4, $a3, 0		#conservar el tama�o del vector
	srl $a3, $a3, 1		#dividir el indice entre 2
	add $t0, $a1, $0	#cargar en $t0 el vector
	sll $t1, $a3, 2		#multiplicar por 4
	add $t0, $t0, $t1	#poner el vector en el indice central
	lw $t2, 0($t0)		#cargar el valor que indica el indice
	add $t3, $t3, $t1	#contador de indice
	Check:				#comprobar si es mayor, menor o igual
		beq $t2, $a2, Equals	
		blt $a2, $t2, Menor
		bgt $a2, $t2, Mayor
	
	Equals:
		srl $t3, $t3, 2		#si es igual sale de la funcion y devuelve el indice encontrado
		add $v1, $t3, 0
		jr $ra
	Menor:				#si es menor va a buscar al centro de la mitad menor
		beq $a3, 1, SkipMen	#si la longitud a restar es 1 no se puede dividir mas y saltamos a restar
		srl $a3, $a3, 1		#dividir la longitud a restar al vector entre 2
		sll $t1, $a3, 2		#multiplicarlo por 4 para restarselo al vector
	SkipMen:
		sub $t3, $t3, $t1	#restar al contador de indice
		blt $t3, $0, NotFound	#si no encuentra el numero sale de la funcion y devuelve -1
		sub $t0, $t0, $t1	#restar al vector
		lw $t2, 0($t0)		#cargar en el vector el valor que indica el indice
		b Check			#comprobar si es el que buscamos
	Mayor:				#lo mismo que con menor, excepto sumando en vez de restando
		beq $a3, 1, SkipMay	
		srl $a3, $a3, 1
		sll $t1, $a3, 2
	SkipMay:
		add $t3, $t3, $t1
		beq $t3, $t4, NotFound
		add $t0, $t0, $t1
		lw $t2, 0($t0)
		b Check
		
	NotFound:
		addi $v1, $0, -1
		jr $ra 
