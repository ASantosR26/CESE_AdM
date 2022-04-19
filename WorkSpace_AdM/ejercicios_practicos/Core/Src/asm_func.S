.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum
.global asm_zeros
.global asm_productoEscalar32
.global asm_productoEscalar16
.global asm_productoEscalar12
.global asm_filtroVentana10
.global asm_pack32to16
.global asm_max
.global asm_downsampleM
.global asm_invertir

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
    asm_svc:
        svc 0
        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asmSum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_sum:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asm_zeros (uint32_t *vector, uint32_t longitud)
@
@ Parametros recibidos:
@   r0: puntero a vector
@   r1: longitud del vector
@
@ Valor de retorno:
@   None
@
.thumb_func
	asm_zeros:
		mov	r2, 0
	.asm_zeros_for:
		str r2, [r0], 4		// *vectror++ = r2 // *vector = r2; vector +=4;
		subs r1, 1			// --longitud
		bne .asm_zeros_for
		bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);
@
@ Parametros recibidos:
@   r0: puntero a vector de entrada
@   r1: puntero a vector de salida
@	r2: longitud del vector de entrada
@	r3: número decimal
@
@ Valor de retorno:
@   None
@
.thumb_func
	asm_productoEscalar32:
		push	{r4}
		.asm_product_32_for:
			ldr 	r4, [r0], 4		// r4 = *r0 // r4 = *r0; r0 +=4;
			mul 	r4, r4, r3		// r4 = r4 * escalar
			str 	r4, [r1], 4
			subs 	r2, 1			// --longitud
			bne 	.asm_product_32_for
		pop		{r4}
		bx 		lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint32_t escalar);
@
@ Parametros recibidos:
@   r0: puntero a vector de entrada
@   r1: puntero a vector de salida
@	r2: longitud del vector de entrada
@	r3: número decimal
@
@ Valor de retorno:
@   None
@
.thumb_func
	asm_productoEscalar16:
		push	{r4}
		.asm_product_16_for:
			ldrh	r4, [r0], 2		// r4 = *r0 // r4 = *r0; r0 +=2; h es unsigned 16 bit
			mul		r4, r4, r3		// r4 = r4 * escalar
			strh 	r4, [r1], 2		// *(r1) = r4; r1 +=2; h es unsigned 16 bit
			subs 	r2, 1			// --longitud
			bne 	.asm_product_16_for
		pop		{r4}
		bx 		lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_productoEscalar12(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint32_t escalar);
@
@ Parametros recibidos:
@   r0: puntero a vector de entrada
@   r1: puntero a vector de salida
@	r2: longitud del vector de entrada
@	r3: número decimal
@
@ Valor de retorno:
@   None
@
.thumb_func
	asm_productoEscalar12:
		push	{r4}
		.asm_product_12_for:
			ldrh 	r4, [r0], 2		// r4 = *r0 // r4 = *r0; r0 +=2;
			mul 	r4, r4, r3		// r4 = r4 * escalar(r3)
			usat 	r4, 12, r4
			strh 	r4, [r1], 2
			subs 	r2, 1			// --longitud
			bne 	.asm_product_12_for
		pop		{r4}
		bx 		lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn);
@
@ Parametros recibidos:
@   r0: puntero a vector de entrada
@   r1: puntero a vector de salida
@	r2: longitud del vector de entrada
@
@ Valor de retorno:
@   None
@
.thumb_func
	asm_filtroVentana10:
		push	{r4 - r9}
		mov		r4, 10						// valor de la longitud de la ventana. (<= 1byte)
		mov		r9, r4
		movw 	r6, 0						// index
		mov		r7, r2						// r7 = r2 (longitud)
		add		r2, r2, r2					// r2 = 2(r2)
		.asm_vectorIn_for:
			movw	r5, 0					// 	valor de la suma, inicializa a 0. (<= 2 bytes)
			mov		r8,	r6					// Almacena el index
			.asm_filtroVentana_for:
				cmp		r8, r2
				bcs		.p1
				b		.p2
			.p1:
				sub		r8, r8, r2
			.p2:
				ldrh	r3, [r0, r8]		// r3 = *(r0 + r8); Desplazamiento a traves del
				add		r5, r5, r3
				add		r8, 2
				subs	r4, 1				// --longitudVentana
				bne		.asm_filtroVentana_for
			mov		r4, r9
			udiv	r5, r5, r9
			strh	r5, [r1], 2
			add		r6, 2					// index++
			subs	r7, 1					// --longitudVector
			bne		.asm_vectorIn_for
		pop		{r4 - r9}
		bx		lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_pack32to16 (int32_t * vectorIn, int16_t *vectorOut, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: puntero a vector de entrada
@   r1: puntero a vector de salida
@	r2: longitud del vector de entrada
@
@ Valor de retorno:
@   None
@
.thumb_func
	asm_pack32to16:
		push 	{r4}
		.asm_pack32to16_for:
			ldr		r3, [r0], 4
			lsr		r4, r3, 16			// r4 = r3 >> 16
			strh	r4, [r1], 2
			subs	r2, 1
			bne		.asm_pack32to16_for
		pop 	{r4}
		bx		lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   int32_t asm_max (int32_t * vectorIn, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: puntero a vector de entrada
@	r1: longitud del vector de entrada
@
@ Valor de retorno:
@	r2: Máximo de los números
@
.thumb_func
	asm_max:
		push	{r4 - r5}
		ldr 	r2, =0x80000000			// r2: Máximo Valor ; 0x80000000: minimo de int32_t
		mov		r3, 0					// index del array
		mov		r4, 0					// almacena el index del maximo valor
		.asm_max_for:
			ldr		r5, [r0], 4
			cmp 	r5, r2
			itt		ge					// r5 > r2
			movge	r4, r3				// if ( r5 > r2) { r4 = r3}; guarda numeración del vector
			movge	r2, r5				// if ( r5 > r2) { r2 = r5}; actualiza el maximo valor
			add		r3, 1				// iteración del indice del array
			subs	r1, 1
			bne		.asm_max_for
		mov		r0, r4					// actualiza r0 para el valor de retorno
		pop		{r4 - r5}
		bx		lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   int32_t asm_downsampleM (int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t N);
@
@ Parametros recibidos:
@   r0: puntero a vector de entrada
@   r1: puntero a vector de salida
@	r2: longitud del vector de entrada
@
@ Valor de retorno:
@   None
@
.thumb_func
	asm_downsampleM:
		push	{r4 - r6}
		mov		r4, 1
		.asm_downsampleM_for:				//for( uint32_t i = 0; i < longitud; i++)
			sdiv	r5, r4, r3				//if (((i + 1) % N) != 0)
			mul		r6, r5, r3
			cmp		r6, r4
			itt		ne
			movne	r1, r0					//*vectorOut++ = *(vectorIn + i);
			addne	r1, r1, 4
			add		r0, r0, 4
			subs	r2, 1
			bne		.asm_downsampleM_for
		pop		{r4 - r6}
		bx		lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   int32_t asm_invertir (uint16_t * vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: puntero a vector de entrada
@	r1: longitud del vector de entrada
@
@ Valor de retorno:
@   None
@
.thumb_func
	asm_invertir:
		push	{r4 - r7}
		sub		r2, r1, 1				//r2 = 2*(r1 -1 ) = 2*(longitud-1)
		mov		r6, 2
		mul		r2, r2, r6
		udiv	r1, r1, r6
		mov		r5, r0
		mov		r7, 0
		.asm_invertir_for:
			ldrh	r3, [r5], 2			//aux = *(vector + i);
			ldrh	r4, [r0, r2]		//*(vector + i) = *(vector + longitud - 1 - i);
			strh	r4, [r0, r7]
			strh	r3,	[r0, r2]		//*(vector + longitud - 1 - i) = aux;
			sub		r2, r2, 2
			add		r7, r7, 2
			subs	r1, 1
			bne		.asm_invertir_for
		pop		{r4 - r7}
		bx		lr
