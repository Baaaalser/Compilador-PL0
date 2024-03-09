.386

option casemap:none ;case sensitive


  include \masm32\include\masm32rt.inc
	includelib analizador-lexico.lib
	
	agregorenglon	proto
	multiplicar		proto
	suma			proto
	coma		proto
	resta	proto
	punto	proto
	division	proto
	aversiesletra	proto
	puntoycoma	proto
	estasigual	proto
	esmayor	proto
	esmenor	proto
	abreparentesis	proto
	cierraparentesis	proto
	seraasignacion	proto
	esnumero	proto
	agregocomillas	proto
	palabrareservada	proto
	identificador	proto
	
	.data	
	
	;***************************************************************************************************
	;************				     Constantes palabras reservadas etc    				 ***************	
	;************      todas QWORD asi es mas facil comparar sabiendo un tamaño fijo     ***************
	;************	   esto es de prueba para guardar en un archivo nomas				 *************** 	
	;***************************************************************************************************


  CONSTANTE		db	"_CONST  ",0        ;CONST
  VARIABLE		db	"_VAR    ",0        ;VAR
  PROCEDIMIENTO	db	"_PROC   ",0     	;PROCEDURE
  LLAMADA			db	"_CALL   ",0        ;CALL   
  COMIENZO		db  "_BEGIN  ",0        ;BEGIN
  YES				db	"_IF     ",0        ;IF
  ENTONCES		db	"_THEN   ",0        ;THEN
  MIENTRAS		db	"_WHILE  ",0        ;WHILE    
  HACER			db	"_DO     ",0        ;DO
  FIN				db	"_END    ",0        ;END
  ODD				db	"_ODD    ",0        ;ODD si es impar
  MAYOR			db	"_MAYOR  ",0        ;MAYOR
  MENOR			db	"_<ENOR  ",0        ;menor
  IGUAL			db	"_IGUAL  ",0
  PUNTO_COMA		db  "_PCOMA  ",0
  MAS				db	"_SUMA   ",0
  MENOS			db	"_MENOS  ",0
  POR_MUL			db	"_MUL    ",0
  DIVIDIR			db	"_DIV    ",0
	PUNTO			db	"_PUNTO  ",0
	COMA			db	"_COMA   ",0
	I_GUAL			db	"_IGUAL  ",0
	ESCRIBIR		db	"_WRITE  ",0
	ESCRIBIRLI		db	"_WRITELN",0
	ESCRIBIRLI2		db	"_WLNTELN",0
	LEERLI			db	"_READLN ",0
	ASIGNACION		db	"_ASIGNA ",0	;asignacion o sea :=
	PROCEDURE		db	"_PROCEDURE",0
	IDENTIFICADOR	db	"_IDENT  ",0
	ABREPAR			db	"_ABRO(  ",0
	CIERRAPAR		db	"_CLOSE) ",0
	MENORIGUAL		db	"_<IGUAL ",0
	MAYORIGUAL		db	"_>IGUAL ",0
	DISTINTO		db 	"_DISTIN ",0
	CADENA			db	"_CADENA ",0
	NUMERO			db	"_NUMERO ",0
	CRLF			db	"_CRLF   ",0
	ESNULO			db	"_NULL   ",0
	HALT			db	"_HALT   ",0
	
	CadenaCompararDLL	db 300 dup(20h)				; variable temporal asi cargo las palabras a comparar en el analizador lexico
	
	ident				db 300 dup(20h)
	cadenatemp			db 300 dup(00h)	
	ident2				db 20 dup(00h)	
	saltosdelinea	db "0001",0 					;contador de saltos de linea
	

	
	
  .data?
    hInstance dd ?
    Psalida	DWORD ?								;variable global para guardar puntero de salida
    Pentrada DWORD ?							;variable global para guardar puntero de entrada	
  .code

; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

LibMain proc instance:DWORD,reason:DWORD,unused:DWORD 

    .if reason == DLL_PROCESS_ATTACH
      mrm hInstance, instance       ; copy local to global
      mov eax, TRUE                 ; return TRUE so DLL will start

    .elseif reason == DLL_PROCESS_DETACH

    .elseif reason == DLL_THREAD_ATTACH

    .elseif reason == DLL_THREAD_DETACH

    .endif

    ret

LibMain endp

; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

analizadorlexico proc ParchivoOrigen:DWORD,ParchivoSalida:DWORD	;ParchivoOrigen = puntero a archivo de origen 
																;ParchivoSalida = puntero a archivo de salida
																;la funcion devuelve en eax el token o cero si llego al final del archivo
																;en ebx devuelve el puntero a la tabla de identificadores
																; y en ecx devuelve donde quedo el puntero de archivo origen
																;y en edx devuelve donde quedo el puntero de salida
																											
										 
									      
	                                                                                      
										mov ecx,dword ptr [ParchivoSalida]		
										mov dword ptr [Psalida],ecx				;copio puntero a variable global
										mov ecx,dword ptr [ParchivoOrigen]
										mov dword ptr [Pentrada],ecx 			;me lo toma como si fuera mov dword ptr Pentrada,ecx
										 
						AverQuees:
										mov edx,dword ptr[Pentrada]
                                        mov al,byte ptr [edx]  					;cargo las letras de Pentrada o sea el codigo ingresado
										cmp	al,00h	;hay algo??
										je	salir	;no, salgo
										cmp	al,09h	;tab???
										jne	sigo	;no, sigo
										mov edx,dword ptr[Psalida]
										mov byte ptr [edx],al		;lo agrego	a la salida
										inc dword ptr[Psalida]
										inc dword ptr [Pentrada]	;si, siguiente caracter
										
										jmp	AverQuees
										
									sigo:
										cmp	al,0Ah	;salto de linea??
										jne	sigo1	;no, sigo
										
										invoke	agregorenglon	;si, lo proceso
										inc dword ptr[Pentrada]
										jmp AverQuees 
									sigo1:
										cmp al,0Dh	;enter??
										jne	sigo2	;no,sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr[edx],al
										inc dword ptr[Psalida]
										inc dword ptr[Pentrada]	;siguiente letra
										
										jmp	AverQuees
									sigo2:
										cmp	al,20h	;espacio?
										jne	sigo21	;no, sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										inc dword ptr [Pentrada]	;siguiente letra
										
										jmp	AverQuees
									sigo21:	
										cmp	al,27h	;comillas?
										jne	sigo31	;no, sigo
										invoke agregocomillas
										
										ret
									sigo31:
										cmp al,28h ;si es (
										jne sigo32  ;si no es sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke abreparentesis	;sino proceso
										
										
										ret
									sigo32:
										cmp al,29h ;si es ) 
										jne sigo3  ;si no es sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke cierraparentesis	;sino proceso
										
										ret
									sigo3:
										cmp	al,2Ah	;asterisco?
										jne	sigo4	;no,sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke	multiplicar	;si, lo proceso
										
										ret
									sigo4:
										cmp	al,2Bh	;es un mas?
										jne	sigo5	;no, sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke	suma	;si, lo proceso
										
										ret
									sigo5:
										cmp al,2Ch	;es una coma?
										jne sigo51
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke coma
										
										ret
									sigo51:	
										cmp al,2Dh	;es un menos?
										jne	sigo6	;no, sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke	resta	;si, lo proceso
										
                                        ret
									sigo6:
										cmp	al,2Eh	;es un punto?
										jne	sigo71	;no,sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke punto	;si lo proceso
										
										ret
									sigo71:
										cmp al,2Fh ;si es / 
										jne sigo7  ;si no es sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke division
										
										ret	
									sigo7:
										cmp al,3Bh	;punto y coma?
										jne	sigo8	;no, sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke	puntoycoma	;si, lo proceso
										
										ret
									sigo8:
										cmp	al,3Ch	;es un menor?
										jne	sigo9	;no, sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke	esmenor	;si, lo proceso
										
										ret
									sigo9:
										cmp	al,3Dh	;es un igual?
										jne	sigo10	;no, sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke	estasigual	;si, lo proceso
										
										ret
									sigo10:
										cmp	al,3Eh	;es un mayor?
										jne	sigo11	;no, sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke	esmayor;si,lo proceso
										
										ret
									sigo11:
										cmp	al,3Ah	;es un 2 puntos?
										jne	sigo12	;no, sigo
										mov edx,dword ptr[Psalida]		;lo agrego	a la salida
										mov byte ptr [edx],al
										inc dword ptr[Psalida]
										invoke	seraasignacion	;si,lo proceso
										
										ret
									sigo12: 
												
										cmp al,41h	;es letra o numero?
										jb sigo13	;no,sigo nomas
										invoke aversiesletra	;si lo proceso
										
                                        ret

									sigo13:
										cmp al,30h 	;es un numero?
										jb  sigo14	;no, sigo
										cmp al,40h  
										jge	sigo14		;no es numero me voy
										invoke esnumero	;si entonces lo proceso
										
										ret
									sigo14:	
                                        mov eax,dword ptr ESNULO
										mov ebx,dword ptr ESNULO+4
										inc dword ptr [Pentrada]
										mov ecx,dword ptr[Pentrada]
										mov edx,dword ptr[Psalida]
										
										ret
									salir:	
										mov eax,0	;indico final del archivo
										ret

																											
	
	
analizadorlexico endp

; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

	agregorenglon proc uses ecx 

		mov ecx,offset saltosdelinea   ;cargo direccion de los numeros en ascii
		inc byte ptr [ecx+3]	;agrego un salto de linea ;incremento el de mas a la derecha
		cmp byte ptr [ecx+3],3Ah   ; llego a 40?
		jne sigamos    ;no , entonces sigo
		
		inc byte ptr [ecx+2]     ;si, le sumo uno al anteultimo
		mov byte ptr [ecx+3],30h ;y pongo en 0 ascii el de mas a la derecha
		cmp byte ptr [ecx+2],3Ah ;el anteultimo es 40?
		jne sigamos 			 ;no, sigo
		mov byte ptr [ecx+2],30h ; si lo pongo en cero
		inc byte ptr [ecx+1] 	 ;incremento el segundo
		cmp byte ptr [ecx+1],3Ah ;  es 40???
		jne sigamos 			 ;no, sigo
		mov byte ptr [ecx+1],30h ;si lo pongo en 0 ascii
		inc byte ptr [ecx] 		;incremento el primero
       
sigamos:	
		mov edx,dword ptr[Pentrada]
		mov al,byte ptr [edx]
		mov edx,dword ptr[Psalida]		;lo agrego	a la salida
		mov byte ptr [edx],al
		inc dword ptr [Psalida]
		mov edx,dword ptr[Psalida]
		mov ecx, dword ptr [saltosdelinea]  
		mov	dword ptr [edx],ecx ;lo agrego al texto de salida
		add dword ptr [Psalida],4	;le sumo 4 al puntero (dword)
		mov edx,dword ptr[Psalida]	
		mov byte ptr [edx],3Ah	;le agrego un 2 puntos
		inc dword ptr [Psalida]	;incremento puntero	
		mov edx,dword ptr[Psalida]
		mov byte ptr [edx],09h	;le agrego un tab
		inc dword ptr[Psalida]	;incremento puntero	
		  
	
	ret
		
	agregorenglon endp

	multiplicar proc	

		mov eax, dword ptr POR_MUL  	

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret	;y vuelvo
	
	multiplicar endp

	suma proc	
	
		mov eax,dword ptr MAS

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret
		
	suma endp

	coma proc	
	
		mov eax,dword ptr COMA

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret
		
	coma endp

	resta proc	

		mov eax,dword ptr MENOS

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret
		
	resta endp

	punto proc	

		mov eax,dword ptr PUNTO

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret
	
	punto endp

	division proc	
		
		mov eax,dword ptr DIVIDIR

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret
		
	division endp

aversiesletra proc	
	  mov edx,dword ptr [Pentrada]
      cmp byte ptr [edx],5Ah ; es menor que Z?
      jle  sigamos1  ;es letra mayuscula
      cmp byte ptr [edx],61h    ;minuscula  mayor que a??
      jle noesletra
      cmp byte ptr [edx],7Ah ;menor que z??
      jnle noesletra ;si no me voy 
	  
sigamos1:    
      xor ecx,ecx
      
dalenomas:
	  mov edx,dword ptr[Pentrada]
	  cmp byte ptr [edx+ecx],30h ;es numero??
	  jl  llamoproc ;si es menor que numero me voy

	  cmp byte ptr [edx+ecx],39h 
	  jle cargacadena
	  

	  cmp byte ptr [edx+ecx],41h	;A?
	  jl	llamoproc ;si no es numero y es menor que A entonces dejo de leer
	  cmp byte ptr [edx+ecx],5Ah	;es menor o igual a Z?
	  jle cargacadena
	  cmp byte ptr [edx+ecx],61h	; a?
	  jl  llamoproc ;si no es mayuscula y es menor que a entonces dejo de leer
	  cmp byte ptr [edx+ecx],7Ah	;es menor o igual a z?
	  jle cargacadena
	  jg  llamoproc ; si no es ni numero ni minuscula o mayuscula no sigo
cargacadena:	  
	  mov al,byte ptr [edx+ecx]			;mientras comparo voy copiando lo que leo a cadena temporal
	  mov byte ptr [CadenaCompararDLL+ecx],al
	  mov edx,dword ptr[Psalida]
	  mov byte ptr [edx],al		;lo agrego	a la salida
	  inc dword ptr [Psalida]
      inc ecx
	  jmp dalenomas
llamoproc:
	  push ecx
	  mov ecx,299
llenoespacios1:	  
	  mov byte ptr [ident+ecx],20h
	  loop llenoespacios1
	  mov byte ptr [ident],20h
	  pop ecx
      invoke palabrareservada ;veo si es palabra reservada o identificador
	  push ecx
	  mov ecx,299
llenoespacios:	  
	  mov byte ptr [CadenaCompararDLL+ecx],20h
	  loop llenoespacios
	  mov byte ptr [CadenaCompararDLL],20h
	  pop ecx
      add dword ptr[Pentrada],ecx	;sumo los caracteres leidos
	  mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
	  mov edx,dword ptr[Psalida]
	  ret	
noesletra:
	mov eax,dword ptr ESNULO

	inc dword ptr [Pentrada]
	mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
	mov edx,dword ptr[Psalida]
	ret
aversiesletra endp

	puntoycoma	proc	

		mov eax,dword ptr PUNTO_COMA

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret
	
	puntoycoma	endp

	esmenor proc	
	
		mov edx,dword ptr[Pentrada]
		cmp byte ptr [edx+1],3Dh ;le sigue un igual
		jne no					;no, me voy entonces
		mov eax,dword ptr MENORIGUAL	;si, entonces agrego palabra reservada

		mov edx,dword ptr [Psalida]
		mov dword ptr [edx],3Dh		;lo agrego	a la salida
		inc dword ptr [Psalida]
		inc dword ptr [Pentrada] ;incremento  el proximo caracter ya no necesito leerlo
		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		jmp mevoy
	no:	
		mov edx,dword ptr[Pentrada]
		cmp byte ptr [edx+1] ,3Eh	;le sigue un mayor?
		jne nono	;no entonces es un menor nomas
		mov eax,dword ptr DISTINTO	;si, entonces agrego palabra reservada

		mov edx,dword ptr[Psalida]
		mov dword ptr [edx],3Eh		;lo agrego	a la salida
		inc dword ptr [Psalida]
		inc dword ptr [Pentrada] ;incremento  el proximo caracter ya no necesito leerlo
		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		jmp mevoy
	nono:
		mov eax,dword ptr MENOR

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		
	mevoy:	
		ret
	
	esmenor	endp
	
	estasigual proc	

		mov eax,dword ptr I_GUAL

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret
	
	estasigual endp

	esmayor proc	
		
		mov edx,dword ptr[Pentrada]
		cmp byte ptr [edx+1],3Dh ;le sigue un igual
		jne no					;no, me voy entonces
		mov eax,dword ptr MAYORIGUAL	;si, entonces agrego palabra reservada

		mov edx,dword ptr[Psalida]
		mov dword ptr [edx],3Dh		;lo agrego	a la salida
		inc dword ptr Psalida
		inc dword ptr [Pentrada] ;incremento el proximo caracter ya no necesito leerlo
		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		jmp mevoy
	no:	
		mov eax,dword ptr MAYOR

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		mevoy:	
		ret
	
	esmayor endp

	abreparentesis proc	
		
		mov eax,dword ptr ABREPAR

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret
		
	abreparentesis endp

	cierraparentesis proc	
	
		mov eax,dword ptr CIERRAPAR

		inc dword ptr [Pentrada]
		mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
		mov edx,dword ptr[Psalida]
		ret
		
	cierraparentesis endp

seraasignacion proc	
	
	mov edx,dword ptr[Pentrada]
	cmp byte ptr [edx+1],3Dh ;le sigue un igual
	jne no					;no, me voy entonces
	mov eax,dword ptr ASIGNACION	;si, entonces agrego palabra reservada

	mov edx,dword ptr[Psalida]
	mov dword ptr [edx],3Dh		;lo agrego	a la salida
	inc dword ptr Psalida
	inc dword ptr [Pentrada] ;incremento edx el proximo caracter ya no necesito leerlo
	inc dword ptr [Pentrada]
	mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
	mov edx,dword ptr[Psalida]
	jmp mevoy
no:	
	mov eax,dword ptr ESNULO	;no, entonces es nulo

	inc dword ptr [Pentrada]
	mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
	mov edx,dword ptr[Psalida]
mevoy:	
	ret
seraasignacion endp

esnumero proc 

	mov eax,dword ptr NUMERO		;guardo lo que retorna la función
	mov ecx,19
llenoceros:
	mov byte ptr[ident2+ecx],00h
	dec ecx
	cmp ecx,00h
	jne llenoceros
	mov byte ptr[ident2],00h
	xor ecx,ecx
	mov dl,30h
	push eax		;guardo eax ya que lo voy a modificar en el bucle
	.while(dl >= 30h && dl <= 39h)	;mientras  sea numero sigo
		
		mov eax,dword ptr[Pentrada]
		mov dl,byte ptr [eax+ecx]	;copio derecho nomas
		mov eax,dword ptr[Psalida]
		mov byte ptr [eax],dl		;lo agrego	a la salida
		mov byte ptr[ident2+ecx],dl	;lo copio a ident
		inc dword ptr [Psalida]
		inc ecx	;siguiente caracter
	.endw
	
	
	dec ecx
	mov byte ptr[ident2+ecx],00h		;piso lo ultimo que no fue numero
	dec dword ptr [Psalida]
	pop eax				;recupero eax
    add dword ptr [Pentrada],ecx	;subo puntero los bytes leidos
	mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
	mov edx,dword ptr[Psalida]
	lea ebx,ident2				;devuelvo el numero
	ret
esnumero endp

agregocomillas proc	
	mov eax,dword ptr CADENA

	xor ecx,ecx
	push eax 		;guardo eax ya que lo modifico en el bucle
	mov eax,dword ptr[Pentrada]
	mov dl,byte ptr [eax]
	mov eax,dword ptr[Psalida]
	mov byte ptr [eax],dl		;lo agrego	a la salida
	inc dword ptr [Psalida]
	inc dword ptr [Pentrada]
	mov eax,dword ptr[Pentrada]
	mov dl,byte ptr [eax]
		.while(dl != "'")	;mientras no sea comillas o se cierre el parentesis
			
			mov eax,dword ptr[Pentrada]
			mov dl,byte ptr [eax+ecx]	;copio derecho nomas
			mov eax,dword ptr[Psalida]
			mov byte ptr [eax],dl		;lo agrego	a la salida
			mov byte ptr[cadenatemp+ecx],dl
			inc dword ptr[Psalida]
			inc ecx	;siguiente caracter
		.endw
		dec ecx		
		mov byte ptr[cadenatemp+ecx],00h
	add dword ptr[Pentrada],ecx	;subo puntero de archivo
	mov eax,dword ptr[Pentrada]
	mov dl,byte ptr[eax]
	mov eax,dword ptr[Psalida]
	mov byte ptr [eax],dl
	inc dword ptr[Pentrada]
	inc dword ptr[Psalida]
	mov ecx,dword ptr[Pentrada]	;guardo puntero en ecx
	mov edx,dword ptr[Psalida]
	pop eax		;recupero eax
	lea ebx,cadenatemp
	ret
agregocomillas endp

palabrareservada proc uses ecx edi esi
	;primero que nada paso la palabra a mayusculas
	mov edx, ecx ;guardo el contador
	add ecx,1
	hasnext:
		cmp byte ptr [CadenaCompararDLL-1+ecx],61h	;es mayor o igual que 'a'
		jl	nomesirve	;no entonces siguiente caracter	
		cmp byte ptr [CadenaCompararDLL-1+ecx],7Ah  ;es menor o igual a 'z'
		jg 	nomesirve	;no entonces siguiente caracter
		sub byte ptr [CadenaCompararDLL-1+ecx],20h	;es minuscula entonces la paso a mayuscula
		nomesirve:
		loop hasnext ;siguiente caracter	
	
	mov ecx,edx ;restauro ecx
	
	dec ecx			;le resto 1 a ecx 
	mov edx,ecx     ;guardo contador
	mov ecx,5		;las iteraciones
	lea esi,CONSTANTE+1	;cargo en esi lo que voy a buscar y le saco el guion bajo
	lea edi,CadenaCompararDLL	;cargo la cadema donde voy a buscar
	repe cmpsb				;comparo byte a byte a ver si es igual
	je	esconstante	;si son iguales
	mov ecx,3		;las iteraciones
	lea esi,VARIABLE+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	esvar	;si son iguales
	mov ecx,9		;las iteraciones
	lea esi,PROCEDURE+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	esproc	;si son iguales
	mov ecx,4		;las iteraciones
	lea esi,LLAMADA+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	escall	;si son iguales
	mov ecx,5		;las iteraciones
	lea esi,COMIENZO+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je esbegin
	mov ecx,2		;las iteraciones
	lea esi,YES+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	esif	;si son iguales
	mov ecx,4		;las iteraciones
	lea esi,ENTONCES+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je esthen
	mov ecx,5		;las iteraciones
	lea esi,MIENTRAS+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	eswhile
	mov ecx,2		;las iteraciones
	lea esi,HACER+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	esdo
	mov ecx,3		;las iteraciones
	lea esi,FIN+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	esend
	mov ecx,3		;las iteraciones
	lea esi,ODD+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je 	esodd
	mov ecx,7		;las iteraciones
	lea esi,ESCRIBIRLI+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	eswriteln
	mov ecx,5		;las iteraciones
	lea esi,ESCRIBIR+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	eswrite
	mov ecx,3		;las iteraciones
	lea esi,LEERLI+1
	lea edi,CadenaCompararDLL 
	repe cmpsb
	je	esreadln	;si son iguales
	mov ecx,4
	lea esi,HALT+1
	lea edi,CadenaCompararDLL
	repe cmpsb
	je	eshalt
	mov ecx,edx		;restauro el contador
	invoke identificador	;si no es ninguna entonces es un identificador	
	jmp	salir
	
esconstante:
	mov eax,dword ptr CONSTANTE	;si es contante

	jmp salir
esvar:
	mov eax,dword ptr VARIABLE	;si es var

	jmp salir
esproc:
	mov eax,dword ptr PROCEDURE	;si es procedure

	jmp salir
escall:
	mov eax,dword ptr LLAMADA	;si es call

	jmp salir
esbegin:
	mov eax,dword ptr COMIENZO	;si es begin

	jmp salir
esif:
	mov eax,dword ptr YES	;si es if

	jmp salir
esthen:
	mov eax,dword ptr ENTONCES	;si es then

	jmp salir
eswhile:
	mov eax,dword ptr MIENTRAS	;si es while

	jmp salir
esdo:
	mov eax,dword ptr HACER	;si es do

	jmp salir
esend:
	mov eax,dword ptr FIN	;si es end

	jmp salir
esodd:
	mov eax,dword ptr ODD	;si es ODD

	jmp salir
eswrite:
	mov eax,dword ptr ESCRIBIR	;si es write

	jmp salir
eswriteln:	
	mov eax,dword ptr ESCRIBIRLI2	;si es writeln

	jmp salir
esreadln:
	mov eax,dword ptr LEERLI	;si es readln
	jmp salir
eshalt:
	mov eax,dword ptr HALT	

salir:
	ret
palabrareservada endp

identificador proc 
	inc ecx		;le sumo uno para restaurar al contador original	
	mov eax,dword ptr IDENTIFICADOR
	pushad		;guardo registros
	lea esi,CadenaCompararDLL
	lea edi,ident
					;el tamaño esta en ecx
	cld
	rep movsb			;copio
	popad				;restauro

	lea ebx,ident		;guardo la direccion del identificador leido
	
	ret
	
identificador endp

end LibMain
