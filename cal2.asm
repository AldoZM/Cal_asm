title "Calculadora ---- Echa por Aldo Zeitna Muciño"
	.model small
	.386
	.stack 64

imprime_caracter	macro 	caracter ;'0'-30h, '1'-31h, '2'-32h,...,'9'-39h
	mov ah,02h				;preparar AH para interrupcion, opcion 02h
	mov dl,caracter 		;DL = caracter a imprimir
	int 21h 				;int 21h, AH=02h, imprime el caracter en DL
endm


   .data

   valor1     dw     0
   contador   dw    0
   digitos   db    0,0,0,0

   valor2     dw     0
   contador2   dw    0
   digitos2   db    0,0,0,0


   diezmil		dw		10000d
   mil			dw		1000d
   cien 		dw 		100d
   diez		dw		10d

;   val1 dw ?   ;Variable a introducir 1 
;   val2 dw ?   ;Variable a introducir 2 
;   val3 dw ?   ;Variable donde se guarda el resultado
   
   mensajePres db "Hola usuario bienvenido a la calculadora solo se pueden hacer ( + , - , * , / ) $" ;
   mensajeDig1 db "Introduce el primer numero $"
   mensajeDig2 db "Introduce el segundo numero $"

   mensajeSuma db "El resultado de la suma es este: $"                                                ;
   mensajeResta db "El resultado de la resta es este: $"                                              ; Esto son solo mensaje que salen despues 
   mensajeMuti db "El resultasdo de la multiplicacion es este: $"                                     ;
   mensajeDivRes db "El residuo de la divicion es este: $"                                            ;
   mensajeDivCos db "El cosiente de la divicion es este: $"                                           ;
   mesnajeRepetir db "¿Quieres volver a hacer otro calculo?$"										  ;
   mensajeSi db "Si quiere precione [enter]$"																  ;
   mensajeNo db "Si no quiere precione [espacio]$"															  ;
   mesnajeDespedida db "Gracias por usarme$"			
   mesnajeVal db "Los valores de Val1 y Val2$"											  ;

   .code


IMPRIME_BX	proc  		;Se pasa un numero a traves del registro BX que se va a imprimir con 5 digitos
;Calcula digito de decenas de millar
	mov ax,bx 				;pasa el valor de BX a AX para division de 16 bits
	xor dx,dx 				;limpia registro DX, para extender AX a 32 bits
	div [diezmil]			;Division de 16 bits => AX=cociente, DX=residuo
							;El cociente contendrá el valor del dígito que puede ser entre 0 y 9. 
							;Por lo tanto, AX=000Xh => AH=00h y AL=0Xh, donde X es un dígito entre 0 y 9
							;Asumimos que el digito ya esta en AL
							;El residuo se utilizara para los siguientes digitos
	mov cx,dx 				;Guardamos el residuo anterior en un registro disponible para almacenarlo temporalmente
							;debido a que modificaremos DX antes de usar ese residuo
	;Imprime el digito decenas de millar 
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter



;Calcula digito de unidades de millar
	mov ax,cx 				;Recuperamos el residuo de la division anterior y preparamos AX para hacer division
	xor dx,dx 				;limpia registro DX, para extender AX a 32 bits
	div [mil]				;Division de 16 bits => AX=cociente, DX=residuo
							;El cociente contendrá el valor del dígito que puede ser entre 0 y 9. 
							;Por lo tanto, AX=000Xh => AH=00h y AL=0Xh, donde X es un dígito entre 0 y 9
							;Asumimos que el digito ya esta en AL
							;El residuo se utilizara para los siguientes digitos
	mov cx,dx 				;Guardamos el residuo anterior en un registro disponible para almacenarlo temporalmente
							;debido a que modificaremos DX antes de usar ese residuo
	;Imprime el digito unidades de millar
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter



;Calcula digito de centenas
	mov ax,cx 				;Recuperamos el residuo de la division anterior y preparamos AX para hacer division
	xor dx,dx 				;limpia registro DX, para extender AX a 32 bits
	div [cien]				;Division de 16 bits => AX=cociente, DX=residuo
							;El cociente contendrá el valor del dígito que puede ser entre 0 y 9. 
							;Por lo tanto, AX=000Xh => AH=00h y AL=0Xh, donde X es un dígito entre 0 y 9
							;Asumimos que el digito ya esta en AL
							;El residuo se utilizara para los siguientes digitos
	mov cx,dx 				;Guardamos el residuo anterior en un registro disponible para almacenarlo temporalmente
							;debido a que modificaremos DX antes de usar ese residuo
	;Imprime el digito unidades de millar
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter



;Calcula digito de decenas
	mov ax,cx 				;Recuperamos el residuo de la division anterior y preparamos AX para hacer division
	xor dx,dx 				;limpia registro DX, para extender AX a 32 bits
	div [diez]				;Division de 16 bits => AX=cociente, DX=residuo
							;El cociente contendrá el valor del dígito que puede ser entre 0 y 9. 
							;Por lo tanto, AX=000Xh => AH=00h y AL=0Xh, donde X es un dígito entre 0 y 9
							;Asumimos que el digito ya esta en AL
							;El residuo se utilizara para los siguientes digitos
	mov cx,dx 				;Guardamos el residuo anterior en un registro disponible para almacenarlo temporalmente
							;debido a que modificaremos DX antes de usar ese residuo
	;Imprime el digito unidades de millar
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter



;Calcula digito de unidades
	mov ax,cx 				;Recuperamos el residuo de la division anterior
							;Para este caso, el residuo debe ser un número entre 0 y 9
							;al hacer AX = CX, el residuo debe estar entre 0000h y 0009h
							;=> AX = 000Xh -> AH=00h y AL=0Xh
	;Imprime el digito unidades de millar
	add al,30h				;Pasa el digito en AL a su valor ASCII
	imprime_caracter al 	;Macro para imprimir caracter



;Imprimir salto de linea
	imprime_caracter 0Ah 	;Macro para imprimir caracter
							;0Ah es salto de linea
	ret 					;intruccion ret para regresar de llamada a procedimiento


endp
inicio:


	mov ax,@data
	mov ds,ax


   mov ah, 09h
   lea dx, [mensajePres]
   int 21h
   mov ah, 09h
   lea dx, [mensajeDig1]
   int 21h
;Seccion donde se leera el dato
lee_numero:
	mov ah,08h			
	int 21h				
	cmp al,0Dh 			
	je calcula_num

    ;Después de leer del teclado y comparar por [enter]
    cmp al,30h          ;compara la tecla con 30h ('0')
    jb lee_numero       ;si AL<30h, no es carácter numérico, regresa a lee_numero
    cmp al,39h          ;compara la tecla con 39h ('9')
    jg lee_numero       ;si AL>39h, no es carácter numérico, regresa a lee_numero			

    ;;;;;;
    ;Imprime el carácter de vuelta para mostrarlo en pantalla
    ;;;;;;
    mov dl,al
    mov ah,02h
    int 21h
    ;;;;;;

    ;Almacenar el dígito
    mov di,word ptr [contador]		;Tomar el contador de dígitos para posicionar dentro del arreglo 'digitos'
    sub al,30h						;Resta 30h a AL para convertir la tecla en su valor numérico correspondiente en hexadecimal
    								;Es decir, si AL es 35h (carácter '5'), restamos 30h para que nos quede 5h y poder operarlo.
    mov [digitos+di],al;Guardamos el dígito en el arreglo digitos
    inc [contador];incrementa el contador de digitos

	xor bh,bh
    mov bl,4	
    cmp [contador],bx 
    je calcula_num          ;Sale del ciclo cuando el contador llega 4

    jmp lee_numero          ;Si no ha llegado al máximo de dígitos, entonces sigue leyendo números.

    calcula_num:   
    xor di,di                   ;Vamos a ocupar DI y lo limpiamos   
    mov [valor1],0              ;Inicializamos valor1 en ceros
    
    cmp [contador],0
    je lee_numero               ;si el contador es 0, no se ha ingresado ningún número, entonces hay que regresar el flujo hasta leer un número
    cmp [contador],1
    je num1_1digito             ;si el contador es 1, sólo se ingresó un dígito
    cmp [contador],2
    je num1_2digitos            ;si el contador es 2, sólo se ingresaron dos dígitos
    cmp [contador],3
    je num1_3digitos            ;si el contador es 3, sólo se ingresaron tres dígitos
    cmp [contador],4
    je num1_4digitos            ;si el contador es 4, sólo se ingresaron cuatro dígitos

    num1_4digitos:
    xor ah,ah
    mov al,[digitos+di]
    mov bx,1000d
    mul bx              ;Multiplica el dígito por 1000
    add [valor1],ax
    inc di              ;para apuntar DI al siguiente dígito
    
    num1_3digitos:
    xor ah,ah
    mov al,[digitos+di]
    mov bx,100d
    mul bx          ;Multiplica el dígito por 100
    add [valor1],ax
    inc di          ;para apuntar DI al siguiente dígito

    num1_2digitos:   
    xor ah,ah
    mov al,[digitos+di]
    mov bx,10d
    mul bx          ;Multiplica el dígito por 10
    add [valor1],ax
    inc di          ;para apuntar DI al siguiente dígito
    
    num1_1digito:
    xor ah,ah
    mov al,[digitos+di]   
    add [valor1],ax


	mov ah,02h;
	mov dl,0Ah; Estaa seccion es solo para el salto de linea  
	int 21h	  ;

   mov ah, 09h
   lea dx, [mensajeDig2]
   int 21h

lee_numero2:
	mov ah,08h			
	int 21h				
	cmp al,0Dh 			
	je calcula_num2

    ;Después de leer del teclado y comparar por [enter]
    cmp al,30h          ;compara la tecla con 30h ('0')
    jb lee_numero2       ;si AL<30h, no es carácter numérico, regresa a lee_numero
    cmp al,39h          ;compara la tecla con 39h ('9')
    jg lee_numero2       ;si AL>39h, no es carácter numérico, regresa a lee_numero			

    ;;;;;;
    ;Imprime el carácter de vuelta para mostrarlo en pantalla
    ;;;;;;
    mov dl,al
    mov ah,02h
    int 21h
    ;;;;;;

    ;Almacenar el dígito
    mov di,word ptr [contador2]		;Tomar el contador de dígitos para posicionar dentro del arreglo 'digitos'
    sub al,30h						;Resta 30h a AL para convertir la tecla en su valor numérico correspondiente en hexadecimal
    								;Es decir, si AL es 35h (carácter '5'), restamos 30h para que nos quede 5h y poder operarlo.
    mov [digitos2+di],al;Guardamos el dígito en el arreglo digitos
    inc [contador2];incrementa el contador de digitos

   xor bh,bh
   mov bl,4	
   cmp [contador],bx 
    je calcula_num2          ;Sale del ciclo cuando el contador llega 4

    jmp lee_numero2         ;Si no ha llegado al máximo de dígitos, entonces sigue leyendo números.

    calcula_num2:   
    xor di,di                   ;Vamos a ocupar DI y lo limpiamos   
    mov [valor2],0              ;Inicializamos valor1 en ceros
    
    cmp [contador2],0
    je lee_numero2               ;si el contador es 0, no se ha ingresado ningún número, entonces hay que regresar el flujo hasta leer un número
    cmp [contador2],1
    je num1_1digito2             ;si el contador es 1, sólo se ingresó un dígito
    cmp [contador2],2
    je num1_2digitos2            ;si el contador es 2, sólo se ingresaron dos dígitos
    cmp [contador2],3
    je num1_3digitos2            ;si el contador es 3, sólo se ingresaron tres dígitos
    cmp [contador2],4
    je num1_4digitos2            ;si el contador es 4, sólo se ingresaron cuatro dígitos

    num1_4digitos2:
    xor ah,ah
    mov al,[digitos2+di]
    mov bx,1000d
    mul bx              ;Multiplica el dígito por 1000
    add [valor2],ax
    inc di              ;para apuntar DI al siguiente dígito
    
    num1_3digitos2:
    xor ah,ah
    mov al,[digitos2+di]
    mov bx,100d
    mul bx          ;Multiplica el dígito por 100
    add [valor2],ax
    inc di          ;para apuntar DI al siguiente dígito

    num1_2digitos2:   
    xor ah,ah
    mov al,[digitos2+di]
    mov bx,10d
    mul bx          ;Multiplica el dígito por 10
    add [valor2],ax
    inc di          ;para apuntar DI al siguiente dígito
    
    num1_1digito2:
    xor ah,ah
    mov al,[digitos2+di]   
    add [valor2],ax

	mov ah,02h				;preparar AH para interrupcion, opcion 02h
	mov dl,0Ah 		;DL = caracter a imprimir
	int 21h 

Suma:
   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;

   mov ah, 09h          ;
   lea dx, [mesnajeVal] ; Muestra mensaje
   int 21h              ;

   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;

   mov bx, [valor1]  ;Pasamo [valor1] a bx para luego utilizarlo en la siguiente linea
   call IMPRIME_BX   ;
   
   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;

   mov bx,[valor2]
   call IMPRIME_BX
   
   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;
   
   mov ah, 09h
   lea dx, [mensajeSuma]
   int 21h
   
   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;
;   mov ax,0 
   mov ax,[valor2]   ;
   add ax, [valor1]  ;Muestra mensaje 
   mov bx, ax        ;
   call IMPRIME_BX;Mandamos a llamara el proceso 


Resta:

   mov ah, 09h             ;
   lea dx, [mensajeResta]  ;Muestra mensaje 
   int 21h                 ;
   
   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;

;   mov ax,0    
   mov ax, [valor2];
   sub ax, [valor1];Esta es la parte de la operacion resta
   mov bx, ax      ;
   call IMPRIME_BX;Mandamos a llamara el proceso 

Multiplica:

   mov ah, 09h          ;
   lea dx, [mensajeMuti];Muestra mensaje
   int 21h              ;
   
   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;
   
;   mov ax,0 
   mov dx, [valor2]  ;
   mov ax, [valor1]  ;Esta es la seccion de la multiplicacion
   mul dx            ;

   mov bx, ax

   call IMPRIME_BX



Division:

   mov ah, 09h             ;
   lea dx, [mensajeDivCos] ;Mensaje para la divicion
   int 21h                 ;
   
   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;
   
;   mov ax,0 
;   mov dx,0
   mov dx, 0000h
   mov ax,[valor1]
   div [valor2]
   mov bx, ax
   call IMPRIME_BX

   mov ah, 09h
   lea dx, [mensajeDivRes]
   int 21h
   
   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;

   mov dx, 0000h
   mov ax,[valor1]
   div [valor2]
   mov bx, dx
   call IMPRIME_BX

Repetir:

   mov ah, 09h                ;
   lea dx, [mesnajeRepetir]   ;
   int 21h                    ;

   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;

   mov ah, 09h			;
   lea dx, [mensajeSi]	; Solo despliega un mensaje en pantalla 
   int 21h				; 

   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;

   mov ah, 09h		  ;
   lea dx, [mensajeNo]; Solo despliega un mensaje en pantalla 
   int 21h 			  ;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO
	cmp al,20h 			;compara si la tecla presionada fue [enter]
	je salir			;Si tecla es [enter], salta a etiqueta imprimir_num

   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;

	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO
	cmp al,0Dh 			;compara si la tecla presionada fue [enter]
	mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;
   je inicio
   

   mov ah, 09h				     ;
   lea dx, [mesnajeDespedida];Desplegar el mensaje
   int 21h					     ;

   mov ah,02h;
   mov dl,0Ah; Esta seccion es solo para el salto de linea  
   int 21h   ;   
salir:				;inicia etiqueta Salir
	mov ah,4Ch		;AH = 4Ch, opcion para terminar programa
	mov al,0	;AL = 0 exit Code, codigo devuelto al finalizar el programa
	int 21h			;senal 21h de interrupcion, pasa el control al sistema operativo
	end inicio		;fin de etiqueta inicio, fin de programa

