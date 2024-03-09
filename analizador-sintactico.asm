include \masm32\include\masm32rt.inc
	includelib \masm32\compiladorompletamentefuncional\analizadorlexico.lib
	includelib \masm32\compiladorompletamentefuncional\analizadorsintactico.lib
	
	analizadorlexico proto :DWORD,:DWORD	;prototipo de la funcion en la dll analizadorlexico.dll
	bloque 				proto	:DWORD
	programa 			proto
	proposicion 		proto	:DWORD,:DWORD
	condicion			proto	:DWORD,:DWORD
	expresion			proto	:DWORD,:DWORD
	termino				proto	:DWORD,:DWORD
	factor				proto	:DWORD,:DWORD
	llamalexico			proto
	errorid				proto
	errornum			proto
	errorcomapuntocoma 	proto
	errorpuntocoma 	   	proto
	errorigual			proto
	errorthen			proto
	errordo     		proto
	errormayor  		proto
	errormasmenos 		proto
	erroridnumabrepar 	proto
	errorcierrapar 		proto
	errorpunto			proto
	errorasignacion     proto
	errorabrepar		proto
	analizadorsemantico	proto	:DWORD,:DWORD,:DWORD,:BYTE,:BYTE
	idtienequeexistir	proto
	idnotienequeexistir	proto
	notavarniconst		proto
	notavar				proto
	notaprocedure		proto
	errormuylargo		proto
	
	ident STRUCT
	nombre	db 63 dup(20h)	;63 espacios vacios
	tipo	db 10 dup(20h)
	valor	dd	00000000h			;2 bytes	
	ident ENDS
	
	.data
	PE_HEAD	db	04Dh,05Ah,060h,001h,001h,000h,000h,000h,004h,000h,000h,000h,0FFh,0FFh,000h,000h
			db	060h,001h,000h,000h,000h,000h,000h,000h,040h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0A0h,000h,000h,000h
			db	00Eh,01Fh,0BAh,00Eh,000h,0B4h,009h,0CDh,021h,0B8h,001h,04Ch,0CDh,021h,054h,068h
			db	069h,073h,020h,070h,072h,06Fh,067h,072h,061h,06Dh,020h,069h,073h,020h,061h,020h
			db	057h,069h,06Eh,033h,032h,020h,063h,06Fh,06Eh,073h,06Fh,06Ch,065h,020h,061h,070h
			db	070h,06Ch,069h,063h,061h,074h,069h,06Fh,06Eh,02Eh,020h,049h,074h,020h,063h,061h
			db	06Eh,06Eh,06Fh,074h,020h,062h,065h,020h,072h,075h,06Eh,020h,075h,06Eh,064h,065h
			db	072h,020h,04Dh,053h,02Dh,044h,04Fh,053h,02Eh,00Dh,00Ah,024h,000h,000h,000h,000h
			db	050h,045h,000h,000h,04Ch,001h,001h,000h,000h,000h,053h,04Ch,000h,000h,000h,000h
			db	000h,000h,000h,000h,0E0h,000h,002h,001h,00Bh,001h,001h,000h,000h,008h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,015h,000h,000h,000h,010h,000h,000h
			db	000h,020h,000h,000h,000h,000h,040h,000h,000h,010h,000h,000h,000h,002h,000h,000h
			db	004h,000h,000h,000h,000h,000h,000h,000h,004h,000h,000h,000h,000h,000h,000h,000h
			db	000h,020h,000h,000h,000h,002h,000h,000h,000h,000h,000h,000h,003h,000h,000h,000h
			db	000h,000h,010h,000h,000h,010h,000h,000h,000h,000h,010h,000h,000h,010h,000h,000h
			db	000h,000h,000h,000h,010h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	01Ch,010h,000h,000h,028h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,010h,000h,000h,01Ch,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,02Eh,074h,065h,078h,074h,000h,000h,000h
			db	00Ch,006h,000h,000h,000h,010h,000h,000h,000h,008h,000h,000h,000h,002h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,000h,000h,0E0h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	06Eh,010h,000h,000h,07Ch,010h,000h,000h,08Ch,010h,000h,000h,098h,010h,000h,000h
			db	0A4h,010h,000h,000h,0B6h,010h,000h,000h,000h,000h,000h,000h,052h,010h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,044h,010h,000h,000h,000h,010h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,04Bh,045h,052h,04Eh,045h,04Ch,033h,032h,02Eh,064h,06Ch,06Ch
			db	000h,000h,06Eh,010h,000h,000h,07Ch,010h,000h,000h,08Ch,010h,000h,000h,098h,010h
			db	000h,000h,0A4h,010h,000h,000h,0B6h,010h,000h,000h,000h,000h,000h,000h,000h,000h
			db	045h,078h,069h,074h,050h,072h,06Fh,063h,065h,073h,073h,000h,000h,000h,047h,065h
			db	074h,053h,074h,064h,048h,061h,06Eh,064h,06Ch,065h,000h,000h,000h,000h,052h,065h
			db	061h,064h,046h,069h,06Ch,065h,000h,000h,000h,000h,057h,072h,069h,074h,065h,046h
			db	069h,06Ch,065h,000h,000h,000h,047h,065h,074h,043h,06Fh,06Eh,073h,06Fh,06Ch,065h
			db	04Dh,06Fh,064h,065h,000h,000h,000h,000h,053h,065h,074h,043h,06Fh,06Eh,073h,06Fh
			db	06Ch,065h,04Dh,06Fh,064h,065h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	050h,0A2h,01Ch,011h,040h,000h,031h,0C0h,003h,005h,02Ch,011h,040h,000h,075h,00Dh
			db	06Ah,0F5h,0FFh,015h,004h,010h,040h,000h,0A3h,02Ch,011h,040h,000h,06Ah,000h,068h
			db	030h,011h,040h,000h,06Ah,001h,068h,01Ch,011h,040h,000h,050h,0FFh,015h,00Ch,010h
			db	040h,000h,009h,0C0h,075h,008h,06Ah,000h,0FFh,015h,000h,010h,040h,000h,081h,03Dh
			db	030h,011h,040h,000h,001h,000h,000h,000h,075h,0ECh,058h,0C3h,000h,057h,072h,069h
			db	074h,065h,020h,065h,072h,072h,06Fh,072h,000h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	060h,031h,0C0h,003h,005h,0CCh,011h,040h,000h,075h,037h,06Ah,0F6h,0FFh,015h,004h
			db	010h,040h,000h,0A3h,0CCh,011h,040h,000h,068h,0D0h,011h,040h,000h,050h,0FFh,015h
			db	010h,010h,040h,000h,080h,025h,0D0h,011h,040h,000h,0F9h,0FFh,035h,0D0h,011h,040h
			db	000h,0FFh,035h,0CCh,011h,040h,000h,0FFh,015h,014h,010h,040h,000h,0A1h,0CCh,011h
			db	040h,000h,06Ah,000h,068h,0D4h,011h,040h,000h,06Ah,001h,068h,0BEh,011h,040h,000h
			db	050h,0FFh,015h,008h,010h,040h,000h,009h,0C0h,061h,090h,075h,008h,06Ah,000h,0FFh
			db	015h,000h,010h,040h,000h,00Fh,0B6h,005h,0BEh,011h,040h,000h,081h,03Dh,0D4h,011h
			db	040h,000h,001h,000h,000h,000h,074h,005h,0B8h,0FFh,0FFh,0FFh,0FFh,0C3h,000h,052h
			db	065h,061h,064h,020h,065h,072h,072h,06Fh,072h,000h,000h,000h,000h,000h,000h,000h
			db	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	060h,089h,0C6h,030h,0C0h,002h,006h,074h,008h,046h,0E8h,0E1h,0FEh,0FFh,0FFh,0EBh
			db	0F2h,061h,090h,0C3h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			db	004h,030h,0E8h,0C9h,0FEh,0FFh,0FFh,0C3h,000h,000h,000h,000h,000h,000h,000h,000h
			db	0B0h,00Dh,0E8h,0B9h,0FEh,0FFh,0FFh,0B0h,00Ah,0E8h,0B2h,0FEh,0FFh,0FFh,0C3h,000h
			db	03Dh,000h,000h,000h,080h,075h,04Eh,0B0h,02Dh,0E8h,0A2h,0FEh,0FFh,0FFh,0B0h,002h
			db	0E8h,0CBh,0FFh,0FFh,0FFh,0B0h,001h,0E8h,0C4h,0FFh,0FFh,0FFh,0B0h,004h,0E8h,0BDh
			db	0FFh,0FFh,0FFh,0B0h,007h,0E8h,0B6h,0FFh,0FFh,0FFh,0B0h,004h,0E8h,0AFh,0FFh,0FFh
			db	0FFh,0B0h,008h,0E8h,0A8h,0FFh,0FFh,0FFh,0B0h,003h,0E8h,0A1h,0FFh,0FFh,0FFh,0B0h
			db	006h,0E8h,09Ah,0FFh,0FFh,0FFh,0B0h,004h,0E8h,093h,0FFh,0FFh,0FFh,0B0h,008h,0E8h
			db	08Ch,0FFh,0FFh,0FFh,0C3h,03Dh,000h,000h,000h,000h,07Dh,00Bh,050h,0B0h,02Dh,0E8h
			db	04Ch,0FEh,0FFh,0FFh,058h,0F7h,0D8h,03Dh,00Ah,000h,000h,000h,00Fh,08Ch,0EFh,000h
			db	000h,000h,03Dh,064h,000h,000h,000h,00Fh,08Ch,0D1h,000h,000h,000h,03Dh,0E8h,003h
			db	000h,000h,00Fh,08Ch,0B3h,000h,000h,000h,03Dh,010h,027h,000h,000h,00Fh,08Ch,095h
			db	000h,000h,000h,03Dh,0A0h,086h,001h,000h,07Ch,07Bh,03Dh,040h,042h,00Fh,000h,07Ch
			db	061h,03Dh,080h,096h,098h,000h,07Ch,047h,03Dh,000h,0E1h,0F5h,005h,07Ch,02Dh,03Dh
			db	000h,0CAh,09Ah,03Bh,07Ch,013h,0BAh,000h,000h,000h,000h,0BBh,000h,0CAh,09Ah,03Bh
			db	0F7h,0FBh,052h,0E8h,018h,0FFh,0FFh,0FFh,058h,0BAh,000h,000h,000h,000h,0BBh,000h
			db	0E1h,0F5h,005h,0F7h,0FBh,052h,0E8h,005h,0FFh,0FFh,0FFh,058h,0BAh,000h,000h,000h
			db	000h,0BBh,080h,096h,098h,000h,0F7h,0FBh,052h,0E8h,0F2h,0FEh,0FFh,0FFh,058h,0BAh
			db	000h,000h,000h,000h,0BBh,040h,042h,00Fh,000h,0F7h,0FBh,052h,0E8h,0DFh,0FEh,0FFh
			db	0FFh,058h,0BAh,000h,000h,000h,000h,0BBh,0A0h,086h,001h,000h,0F7h,0FBh,052h,0E8h
			db	0CCh,0FEh,0FFh,0FFh,058h,0BAh,000h,000h,000h,000h,0BBh,010h,027h,000h,000h,0F7h
			db	0FBh,052h,0E8h,0B9h,0FEh,0FFh,0FFh,058h,0BAh,000h,000h,000h,000h,0BBh,0E8h,003h
			db	000h,000h,0F7h,0FBh,052h,0E8h,0A6h,0FEh,0FFh,0FFh,058h,0BAh,000h,000h,000h,000h
			db	0BBh,064h,000h,000h,000h,0F7h,0FBh,052h,0E8h,093h,0FEh,0FFh,0FFh,058h,0BAh,000h
			db	000h,000h,000h,0BBh,00Ah,000h,000h,000h,0F7h,0FBh,052h,0E8h,080h,0FEh,0FFh,0FFh
			db	058h,0E8h,07Ah,0FEh,0FFh,0FFh,0C3h,000h,0FFh,015h,000h,010h,040h,000h,000h,000h
			db	0B9h,000h,000h,000h,000h,0B3h,003h,051h,053h,0E8h,0A2h,0FDh,0FFh,0FFh,05Bh,059h
			db	03Ch,00Dh,00Fh,084h,034h,001h,000h,000h,03Ch,008h,00Fh,084h,094h,000h,000h,000h
			db	03Ch,02Dh,00Fh,084h,009h,001h,000h,000h,03Ch,030h,07Ch,0DBh,03Ch,039h,07Fh,0D7h
			db	02Ch,030h,080h,0FBh,000h,074h,0D0h,080h,0FBh,002h,075h,00Ch,081h,0F9h,000h,000h
			db	000h,000h,075h,004h,03Ch,000h,074h,0BFh,080h,0FBh,003h,075h,00Ah,03Ch,000h,075h
			db	004h,0B3h,000h,0EBh,002h,0B3h,001h,081h,0F9h,0CCh,0CCh,0CCh,00Ch,07Fh,0A8h,081h
			db	0F9h,034h,033h,033h,0F3h,07Ch,0A0h,088h,0C7h,0B8h,00Ah,000h,000h,000h,0F7h,0E9h
			db	03Dh,008h,000h,000h,080h,074h,011h,03Dh,0F8h,0FFh,0FFh,07Fh,075h,013h,080h,0FFh
			db	007h,07Eh,00Eh,0E9h,07Fh,0FFh,0FFh,0FFh,080h,0FFh,008h,00Fh,08Fh,076h,0FFh,0FFh
			db	0FFh,0B9h,000h,000h,000h,000h,088h,0F9h,080h,0FBh,002h,074h,004h,001h,0C1h,0EBh
			db	003h,029h,0C8h,091h,088h,0F8h,051h,053h,0E8h,0C3h,0FDh,0FFh,0FFh,05Bh,059h,0E9h
			db	053h,0FFh,0FFh,0FFh,080h,0FBh,003h,00Fh,084h,04Ah,0FFh,0FFh,0FFh,051h,053h,0B0h
			db	008h,0E8h,07Ah,0FCh,0FFh,0FFh,0B0h,020h,0E8h,073h,0FCh,0FFh,0FFh,0B0h,008h,0E8h
			db	06Ch,0FCh,0FFh,0FFh,05Bh,059h,080h,0FBh,000h,075h,007h,0B3h,003h,0E9h,025h,0FFh
			db	0FFh,0FFh,080h,0FBh,002h,075h,00Fh,081h,0F9h,000h,000h,000h,000h,075h,007h,0B3h
			db	003h,0E9h,011h,0FFh,0FFh,0FFh,089h,0C8h,0B9h,00Ah,000h,000h,000h,0BAh,000h,000h
			db	000h,000h,03Dh,000h,000h,000h,000h,07Dh,008h,0F7h,0D8h,0F7h,0F9h,0F7h,0D8h,0EBh
			db	002h,0F7h,0F9h,089h,0C1h,081h,0F9h,000h,000h,000h,000h,00Fh,085h,0E6h,0FEh,0FFh
			db	0FFh,080h,0FBh,002h,00Fh,084h,0DDh,0FEh,0FFh,0FFh,0B3h,003h,0E9h,0D6h,0FEh,0FFh
			db	0FFh,080h,0FBh,003h,00Fh,085h,0CDh,0FEh,0FFh,0FFh,0B0h,02Dh,051h,053h,0E8h,0FDh
			db	0FBh,0FFh,0FFh,05Bh,059h,0B3h,002h,0E9h,0BBh,0FEh,0FFh,0FFh,080h,0FBh,003h,00Fh
			db	084h,0B2h,0FEh,0FFh,0FFh,080h,0FBh,002h,075h,00Ch,081h,0F9h,000h,000h,000h,000h
			db	00Fh,084h,0A1h,0FEh,0FFh,0FFh,051h,0E8h,014h,0FDh,0FFh,0FFh,059h,089h,0C8h,0C3h
			
	                                                      
			
			
	llamadorsemantico MACRO b,d
	local muylargo
	local adios
	push esi							;copio el identificador devuelto por el lexico
	push edi
	mov ecx,300
	mov esi,ebx
	lea edi,identif
	cld 
	rep movsb	
	mov ecx,300
	lea edi,identif
	mov al,20h
	repne scasb
	cmp ecx,237
	jle	muylargo
	pop edi
	pop esi
	mov eax,dword ptr[d]			;le tengo que pasar la base y el desplazamiento al semantico 
	mov ebx,dword ptr[b]
	jmp adios
muylargo:
	invoke errormuylargo
	ret
adios:	
	ENDM
	
	hastaelfondo MACRO	b1,d1,id1
	local @0
	local @1
	local @2
	local @3
	local seguir
	local var
	local const
	push edi
	push ebx
	push esi
	push eax
	mov eax,dword ptr[d1]		;guardo el indice
	mov ebx,dword ptr[b1]		;copio base a ebx
	add eax,ebx					;eax es mi puntero a vector le sumo la base
	mov	ebx,eax					;lo copio a ebx
@0:
	
	mov esi,id1					;guardo el identificador
	lea edi,ids					;guardo la tabla
	mov ecx,77
								;guardo el indice
	mul ecx						;multiplico eax por 77 tamaño del struct
	add edi,eax					;se lo sumo a edi para ver a cual posicion del vector voy
	mov ecx,63					;cargo las iteraciones
	cld
	repe cmpsb	
	je @1						;son iguales
	dec ebx
	mov eax,ebx
	cmp eax,00h
	jge @0
	jmp @2
@1:
	pop eax
	mov esi,edi
	cmp byte ptr[esi],76h
	je  var
	cmp byte ptr[esi],63h
	je  const
	mov byte ptr[tipod],02h
	jmp seguir
var:
	mov byte ptr[tipod],00h
	jmp seguir
const:
	mov byte ptr[tipod],01h	
seguir:	
	add esi,0ah
	lea edi,valor1
	mov ecx,1
	rep movsd					;guardo en valor lo que se encontro
	
	pop esi
	pop ebx
	pop edi
	mov al,01h
	jmp @3
@2:
	pop eax
	pop esi
	pop ebx
	pop edi
	mov al,00h	
@3:	
	ENDM
	
	ASCIIahex	MACRO
	local b1
	local b2
	local b3
	local chau
	push esi							;copio el numero devuelto por el lexico
	push edi
	mov dword ptr[numerito],00000000h	;primero pongo en cero
	mov ecx,63
	mov esi,ebx
	lea edi,identifnum
	cld 
	rep movsb
	lea edi,identifnum					;ahora saco el largo del numero
	xor ecx,ecx
b1:
	
	cmp byte ptr[edi+ecx],00h
	je b2
	inc ecx
	cmp ecx,63
	jne b1
b2:	
	cmp ecx,00h
	je b3
	dec ecx								;sino sigo apuntando al cero
b3:	
	mov ebx,0000000Ah					;la unidad en ebx
convertir:
	mov al,byte ptr[identifnum+ecx]		;obtengo los bytes
	and	eax,0000000Fh					;si era 1 por ejemplo que en ascii es 31 lo dejo en 01
	mul	MULTI10								;multiplico por ebx 
	add dword ptr[numerito],eax			;se lo sumo a numerito
	mov eax,dword ptr[MULTI10]
	mul ebx								;siguiente unidad
	mov dword ptr[MULTI10],eax
	dec ecx
	js	chau
	cmp ecx,00h
	jge convertir
chau:	
	mov dword ptr[MULTI10],00000001h
	pop edi
	pop esi	
	ENDM
	
	copiacadena MACRO
	local a_cero
	pushad
	lea esi,cadenatemp
	mov ecx,100
a_cero:	
	mov byte ptr[esi+ecx],00h
	dec ecx
	cmp ecx,00h
	jne	a_cero
	cld
	mov esi,ebx
	lea edi,cadenatemp
	mov ecx,100
	rep movsb
	lea edi,cadenatemp
	mov eax,00h
	mov ecx,100
	repne scasb
	mov eax,100
	sub eax,ecx
	mov byte ptr[tamaniocadena],al
	popad
	ENDM
		respuesta			db 8 dup(0)		;aca voy a guardar lo que devuelva el analizador lexico en eax y ebx
		saltosdelinea		db "0001",0 				;contador de saltos de linea
		columna				db "0000",0					;variable para alojar el numero de columna
		huboerror			db	0						;bandera para ver si se produjo un error
		
		mensajeerrorid				db	"Se esperaba un identificador",0
		mensajeerrorigual			db	" Se esperaba un '=' ",0
		mensajeerrornum				db	" Se esperaba un numero  ",0
		mensajeerrorcpc				db	"Se esperaba un ',' ó ';'",0
		mensajeerrorpc				db	" Se esperaba un ';' "
		mensajeerrorthen			db	" Se esperaba 'THEN' ",0
		mensajeerrordo				db	"Se esperaba 'DO'",0
		mensajeerrormayor			db	"Se esperaba '>' ó '>=' ó '<=' ó '<' ó '<>' ó '='",0
		mensajeerrormasmenos 		db	"Se esperaba un '+' ó '-'",0
		mensajeerroridnumabrepar 	db	"Se esperaba identificador ó numero ó '('",0
		mensajeerrorcierrapar	 	db	" Se esperaba ')'",0
		mensajeerrorabrepar			db	" Se esperaba '('",0		
		mensajeerrorpunto			db	" Se esperaba '.'",0
		mensajeerrorasignacion	 	db "Se esperaba ':='",0	
		messageboxtitulo			db	"Compilador PL/0",0
		messageboxok				db	"Se ha generado el archivo ningun error encontrado",0
		messageboxerror				db	"Se encontro un error se ha generado un archivo de listado",0
		mensajeidtienequeexistir	db	"El identificador no fue previamente declarado",0
		mensajeidnotienequeexistir	db	"El identificador ya fue previamente declarado",0
		mensajeerrorprocedure		db	"El procedimiento no fue declarado previamente",0
		mensajeerrorfaltavar		db	"La variable no fue declarada previamente",0
		mensajeerrornotavarniconst	db	" La variable o constante no fue declarada previamente   ",0
		mensajeerrormuylargo		db	"  El identificador es muy largo el maximo es de 63 chars",0	
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
	ESCRIBIRLI		db	"_WLNTELN",0
	LEERLI			db	"_READLN ",0
	ASIGNACION		db	"_ASIGNA ",0	;asignacion o sea :=
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
	PROCEDURE		db	"_PROCEDURE",0
	HALT			db	"_HALT   ",0	
	
	ids				 ident 500 dup(<>)				;variable donde alojar los identificadores un vector de 500 structs
	contadorids	db	00h								;variable para contar los identificadores
	identif		db	300 dup(20h)						;variable para guardar el identificador
	identifnum	db	63 dup(00h)							;variable para los humeros
	operadores	db	"varconstproc",0
	contvar		dd	00000000h
	posejec		dw	0700h
	baseofcode	dd	00001000h
	imagebase	dd	00400000h
	jmpbloque	dw	0000h
	jmpbloqueexe dd	00000000h
	jmppropexe	dd	00000000h	
	jmpprop		dw	0000h	
	valor1		dd	00000000h
	tipod		db	00h
	numerito	dd	00000000h
	MULTI10		dd	00000001h
	fuemenos	db	00h
	fuedividido	db	00h
	cadenatemp	db	100 dup(00h)
	tamaniocadena db	00h
	fuewriteln	db	00h	
	espacioasigna dd 00000000h
	valorconst	dd	00000000h	
    .data?
	
		hInstance 				dd 	?	;manejador de la dll
		psalidaarchivo			DWORD ?	;aca voy a guardar el puntero al primer byte del archivo a escribir
		plectura				DWORD ?	;aca voy a guardar el puntero de lo que voy leyendo
		Psalidaoriginal			DWORD ?	;aca guardo puntero de salida global
		punteroid				DWORD ?	;puntero a tabla de identificadores
		psalidaexeoriginal		DWORD ? ;puntero al primer byte del exe	
		psalidaexe				DWORD ? ;puntero al exe de lo que voy escribiendo
		psalidamensaje			DWORD ?	;puntero para mandar el mensaje de error
		
		
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
analisissintactico proc	Parchivo:DWORD,Psalida:DWORD,Pexesalida:DWORD

	mov eax,dword ptr[Parchivo]	;copio el puntero del archivo
	mov dword ptr[plectura],eax	;copio de vuelta pero al que voy a usar para leer 
	mov eax,dword ptr[Psalida]
	mov dword ptr[psalidaarchivo],eax
	mov dword ptr[Psalidaoriginal],eax	;guardo puntero original de salida en variable global
	mov eax,dword ptr [Pexesalida]
	mov dword ptr[psalidaexeoriginal],eax
	mov dword ptr[psalidaexe],eax
	mov ecx,0700h		;las iteraciones
	mov eax,offset PE_HEAD
	mov edx,dword ptr[psalidaexe]
copio:									;primero pego el encabezado en el exe
	mov bl,byte ptr[eax+ecx]
	mov byte ptr[edx+ecx],bl
	loop copio
	mov bl,byte ptr[eax+ecx]
	mov byte ptr[edx+ecx],bl
	add dword ptr[psalidaexe],0700h
	
	invoke	programa 
	cmp byte ptr [huboerror],1 ;hubo error??
	jne	seguir
	mov eax,dword ptr [psalidaarchivo]	;recupero puntero inicial de salida
	mov ebx,dword ptr [Psalidaoriginal]	;recupero puntero final de salida
	sub ebx,eax							;resto el total de bytes escritos y lo guardo en ebx
	mov al,01h							;aviso que hubo error
	jmp salida
seguir:
	mov ebx,dword ptr [psalidaexe]	;recupero puntero inicial de salida
	mov eax,dword ptr [psalidaexeoriginal]	;recupero puntero final de salida
	sub ebx,eax							;resto el total de bytes escritos y lo guardo en ebx
	mov al,00h							;aviso que hubo error		
salida:	
	;antes de salir restauro todas las variables
	mov dword ptr[contvar],00h
	mov word ptr[posejec],0700h
	mov word ptr[jmpbloque],00h
	mov dword ptr[jmpbloqueexe],00h
	mov dword ptr[jmppropexe],00h
	mov word ptr[jmpprop],00h
	mov dword ptr[valor1],00h
	mov byte ptr[tipod],00h
	mov dword ptr[numerito],00h
	mov dword ptr[MULTI10],01h
	mov byte ptr[fuemenos],00h
	mov byte ptr[fuedividido],00h
	mov byte ptr[tamaniocadena],00h
	mov byte ptr[fuewriteln],00h
	mov dword ptr[espacioasigna],00h
	mov dword ptr[valorconst],00h
	mov dword ptr[saltosdelinea],30303031h
	mov dword ptr[columna],30303030h
	mov byte ptr[huboerror],00h
	mov byte ptr[contadorids],00h
	ret
analisissintactico endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

llamalexico	proc

		mov eax,dword ptr[Psalidaoriginal]	;hago esto asi el mensaje sale donde tiene que salir y no mas adelante
		mov dword ptr[psalidamensaje],eax
			
		invoke analizadorlexico ,plectura,Psalidaoriginal	;pido primer token   
	mov dword ptr respuesta,eax								;guardo la parte alta
	mov dword ptr [punteroid],ebx							;guardo puntero de tabla de identificadores
	mov dword ptr [plectura],ecx							;ecx guarda donde quedo el puntero de lectura
	mov dword ptr[Psalidaoriginal],edx						;edx guarda donde quedo el puntero de salida
	ret
	
llamalexico	endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
programa proc
	mov edx,dword ptr[psalidaexe]		;agrego el mov[edi+...]
	mov byte ptr[edx],0BFh
	inc edx
	mov dword ptr[edx],00000000h
	add dword ptr[psalidaexe],5
	add dword ptr[posejec],5
	
	invoke llamalexico				;llamo al parser
	invoke bloque,0000h
	cmp byte ptr [huboerror],1 ;hubo error??
	jne	seguir
	invoke MessageBox, NULL, addr messageboxerror, addr messageboxtitulo, MB_OK
	jmp  salir				 ;si entonces salgo	
	
seguir:
		pushad
		mov eax,dword ptr PUNTO		;es punto?
		cmp eax,dword ptr respuesta	
		jne	tamalpunto					;no, entonces esta mal
		mov edx,dword ptr[psalidaexe]
		mov byte ptr[edx],0E9h			;genero el salto para salir del programa
		inc edx
		xor eax,eax
		mov ax,word ptr[posejec]
		add eax,5						;sumo los 5 bytes del jmp
		mov ebx,00000588h
		sub ebx,eax
		mov dword ptr[edx],ebx			;arreglo el salto
		add dword ptr[psalidaexe],5
		add word ptr[posejec],5
		mov bx,word ptr[posejec]
		and ebx,0ffffh
		mov edx,dword ptr[psalidaexe]	;arreglo el mov edi,....
		sub edx,ebx
		add edx,0701h
		xor eax,eax
		mov ax,word ptr[posejec]
		sub eax,0200h
		add eax,dword ptr[imagebase]
		add eax,dword ptr[baseofcode]
		mov dword ptr[edx],eax
		xor ecx,ecx
		mov cl,byte ptr[contadorids]
		cmp ecx,00h						;hay variables???
		je	tomatelas
		mov edx,dword ptr[psalidaexe]
		
	cerovar:
		mov dword ptr[edx],00h
		add edx,4
		add dword ptr[psalidaexe],4
		add word ptr[posejec],4
		dec ecx
		cmp ecx,00h
		jne cerovar
tomatelas:		
		mov edx,dword ptr[psalidaexeoriginal]
		add edx,01A0h
		xor ecx,ecx
		mov cx,word ptr[posejec]
		sub cx,0200h
		mov dword ptr[edx],ecx
		xor eax,eax
		mov ax,word ptr[posejec]
		mov cx,0200h
		div	cx
		cmp dx,00h
		je	tabien
		mov ebx,dword ptr[psalidaexe]
	llenardeceros:
		mov byte ptr[ebx],00h
		inc ebx
		inc dword ptr[psalidaexe]
		inc word ptr[posejec]
		mov ax,word ptr[posejec]
		mov cx,0200h
		div	cx
		cmp dx,00h
		je	tabien
		jmp llenardeceros
	tabien:	
		mov edx,dword ptr[psalidaexeoriginal]
		add edx,00BCh
		xor ecx,ecx
		mov cx,word ptr[posejec]
		sub cx,0200h
		mov dword ptr[edx],ecx
		mov edx,dword ptr[psalidaexeoriginal]
		add edx,01A8h
		xor ecx,ecx
		mov cx,word ptr[posejec]
		sub cx,0200h
		mov dword ptr[edx],ecx               	;guardo el valor de rawdata y de sizeofcodesection en ecx
		mov edx,dword ptr[psalidaexeoriginal]
		add edx,00F0h
		push edx
		xor edx,edx
		mov eax,ecx
		and eax,0FFFFF000h
		mov ebx,1000h
		div ebx
		add eax,2
		mul ebx
		pop edx
		mov dword ptr[edx],eax
		mov edx,dword ptr[psalidaexeoriginal]
		add edx,00D0h
		mov dword ptr[edx],eax
		popad
		invoke MessageBox, NULL, addr messageboxok, addr messageboxtitulo, MB_OK	
		ret
tamalpunto:
			invoke errorpunto
			mov byte ptr[huboerror],1
salir:		
	ret
programa endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
bloque proc	base:DWORD
	
	LOCAL desplazamiento:DWORD
	mov dword ptr [desplazamiento],00000000h
	
	mov dx,word ptr[posejec]			;guardo la posicion del salto
	add dx,5								;le sumo 5 asi salto el e9
	mov word ptr[jmpbloque],dx
	mov edx,dword ptr[psalidaexe]		;en la direccion si le sumo 1 asi me pongo detras del e9
	inc edx
	mov dword ptr[jmpbloqueexe],edx
	mov edx,dword ptr[psalidaexe]		;agrego el jmp
	mov byte ptr[edx],0E9h
	inc edx
	mov dword ptr[edx],00000000h
	add dword ptr[psalidaexe],5
	add dword ptr[posejec],5	
	
	mov eax,dword ptr CONSTANTE			;es constante?
	cmp eax,dword ptr respuesta	
	jne	aversiesvar						;no,entonces sigo

	invoke llamalexico	
		identificador1:		;llamo al parser			
						
					mov eax,dword ptr IDENTIFICADOR		;es identificador?
					cmp eax,dword ptr respuesta	
					jne	tamalid							;no, entonces esta mal
					llamadorsemantico base,desplazamiento
					invoke analizadorsemantico,ADDR identif,eax,ebx,00h,01h	;ultimo parametro en 1 por que es const
					inc dword ptr[desplazamiento]
					cmp byte ptr [huboerror],1	;hubo error??
					je  salir				;si entonces me voy
					invoke llamalexico	;llamo lexico
							mov eax,dword ptr I_GUAL		;es igual?
							cmp eax,dword ptr respuesta	
							jne	tamaligual					;no, entonces esta mal

							invoke llamalexico
									mov eax,dword ptr NUMERO		;es numero?
									cmp eax,dword ptr respuesta	
									jne	tamalnum							;no, entonces esta mal
									ASCIIahex
									mov ebx,dword ptr[valorconst]
									mov eax,dword ptr[numerito]
									mov dword ptr[ebx],eax
									invoke llamalexico
											mov eax,dword ptr PUNTO_COMA		;es punto y coma?
											cmp eax,dword ptr respuesta	
											jne	aversiescoma					;no
											;si entonces todo bien y sigo
											invoke llamalexico
											jmp aversiesvar
								aversiescoma:			
											mov eax,dword ptr COMA				;es coma?
											cmp eax,dword ptr respuesta	
											jne	tamalcomapuntocoma				;no, entonces esta mal

											invoke llamalexico
											jmp  identificador1					;si entonces sigo con otro identificador
											
aversiesvar:
		
			mov eax,dword ptr VARIABLE		;es variable??
			cmp eax,dword ptr respuesta		
			jne aversiesprocedure			;no, entonces vemos si es procedure
			invoke llamalexico
				identificador2:
					
						mov eax,dword ptr IDENTIFICADOR		;es identificador?
						cmp eax,dword ptr respuesta	
						jne	tamalid							;no, entonces esta mal
						llamadorsemantico base,desplazamiento
						invoke analizadorsemantico,ADDR identif,eax,ebx,00h,00h	;ultimo parametro en 0 por que es var
						inc dword ptr[desplazamiento]
						cmp byte ptr [huboerror],1	;hubo error??
						je  salir				;si entonces me voy
						invoke llamalexico
								mov eax,dword ptr PUNTO_COMA		;es punto y coma?
								cmp eax,dword ptr respuesta	
								jne	aversiescoma1					;no

								invoke llamalexico
								jmp	aversiesprocedure    				;si entonces sigo
						aversiescoma1:			
									mov eax,dword ptr COMA				;es coma?
									cmp eax,dword ptr respuesta	
									jne	tamalcomapuntocoma				;no, entonces esta mal

									invoke llamalexico
									jmp  identificador2					;si entonces siguiente identificador
				
aversiesprocedure:
		
			mov eax,dword ptr PROCEDURE		;es procedimiento??
			cmp eax,dword ptr respuesta		
			jne aversiesproposicion				;no, entonces vemos si es proposicion

			invoke llamalexico
				identificador3:
					
						mov eax,dword ptr IDENTIFICADOR		;es identificador?
						cmp eax,dword ptr respuesta	
						jne	tamalid							;no, entonces esta mal
						llamadorsemantico base,desplazamiento
						invoke analizadorsemantico,ADDR identif,eax,ebx,00h,02h	;ultimo parametro en 0 por que es procedure
						inc dword ptr[desplazamiento]
						cmp byte ptr [huboerror],1	;hubo error??
						je  salir				;si entonces me voy
						invoke llamalexico
								mov eax,dword ptr PUNTO_COMA		;es punto y coma?
								cmp eax,dword ptr respuesta	
								jne	tamalpuntocoma					;no, entonces ta mal

								invoke llamalexico
								mov edx,dword ptr [base]
								push edx
								mov eax,dword ptr[desplazamiento]
								push eax
								add eax,edx
								mov dx,word ptr[jmpbloque]
								push dx
								mov edx,dword ptr[jmpbloqueexe]
								push edx
								invoke bloque,eax			;si entonces sigo y reinvoco a bloque
								pop edx
								mov dword ptr[jmpbloqueexe],edx
								pop dx
								mov word ptr[jmpbloque],dx
								pop eax
								mov dword ptr[desplazamiento],eax
								pop edx
								mov dword ptr [base],edx
									cmp byte ptr [huboerror],1			;hubo error??
									je	salir							;si me voy				
										mov eax,dword ptr PUNTO_COMA		;es punto y coma?
										cmp eax,dword ptr respuesta	
										jne	tamalpuntocoma					;no, entonces ta mal
										mov edx,dword ptr[psalidaexe]
										mov byte ptr[edx],0C3h				;cargo el ret en el ejecutable
										inc dword ptr[psalidaexe]
										inc word ptr[posejec]
										invoke llamalexico
										jmp	aversiesprocedure			;si, entonces veo si es prosedure otra vez
										
										
aversiesproposicion:
				pushad
				xor ebx,ebx
				mov ax,word ptr[jmpbloque]				;hago el fix up
				mov bx,word ptr[posejec]
				cmp ax,bx
				je chau
				sub bx,ax
				mov eax,dword ptr[jmpbloqueexe]
				mov dword ptr[eax],ebx
				jmp avanzo
		chau:	
				sub dword ptr[psalidaexe],5
				sub word ptr[posejec],5
				popad
		avanzo:		
				invoke proposicion,base,desplazamiento
salir:				
	ret
	
tamalid:
		invoke errorid
		ret
tamaligual:
		invoke errorigual
		ret
tamalnum:
		invoke	errornum
		ret
tamalcomapuntocoma:
		invoke  errorcomapuntocoma
		ret
tamalpuntocoma:
		invoke errorpuntocoma
		ret
bloque endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
proposicion proc base1:DWORD,desplazamiento1:DWORD
	
	sigo:
		mov eax,dword ptr IDENTIFICADOR		;es identificador?
		cmp eax,dword ptr respuesta	
		jne	aversiescall					;no, entonces veo si es call
		llamadorsemantico base1,desplazamiento1
		invoke analizadorsemantico,ADDR identif,eax,ebx,01h,04h	;ultimo parametro en 4 por que es proposicion
		mov eax,dword ptr[valor1]
		push eax					;guardo el valor devuelto
		cmp byte ptr [huboerror],1	;hubo error??
		je  melaspico				;si entonces me voy
		invoke llamalexico
				mov eax,dword ptr ASIGNACION		;es asignacion?
				cmp eax,dword ptr respuesta	
				jne	tamalasigna						;no, entonces ta mal
				
				invoke llamalexico
				invoke expresion,base1,desplazamiento1				;si entonces llamo a expresion
				pop eax												;restauro valor1
				mov edx,dword ptr[psalidaexe]
				dec	edx
				cmp byte ptr[edx],50h
				je nopop
				inc edx
				mov byte ptr[edx],58h			;pop eax
				inc edx
				inc dword ptr[psalidaexe]
				inc word ptr[posejec]
				jmp sipop
		nopop:
				dec dword ptr[psalidaexe]
				dec word ptr[posejec]
			sipop:	
				mov word ptr[edx],8789h
				add edx,2
				mov dword ptr[edx],eax
				add dword ptr[psalidaexe],6
				add word ptr [posejec],6
				ret					;y me voy
aversiescall:
		mov eax,dword ptr LLAMADA		;es call?
		cmp eax,dword ptr respuesta	
		jne	aversiesbegin				;no, entonces veo si es begin

		invoke llamalexico
				mov eax,dword ptr IDENTIFICADOR		;es identificador?
				cmp eax,dword ptr respuesta	
				jne	tamalid					;no, entonces ta mal
					llamadorsemantico base1,desplazamiento1
					invoke analizadorsemantico,ADDR identif,eax,ebx,01h,03h	;ultimo parametro en 3 por que es call
					mov eax,dword ptr[valor1]	;saco el valor
					mov bx,word ptr[posejec]	;hago la cuenta para saber a donde debo hacer el call
					and ebx,0000FFFFh
					add ebx,5
					sub eax,ebx
					mov edx,dword ptr[psalidaexe];agrego el call	
					mov byte ptr[edx],0E8h
					inc edx
					mov dword ptr[edx],eax
					add dword ptr[psalidaexe],5
					add word ptr[posejec],5
					mov dword ptr[valor1],00h
					cmp byte ptr [huboerror],1	;hubo error??
			        je  melaspico				;si entonces me voy
				invoke llamalexico
				ret						; si, entonces vuelvo
aversiesbegin:
		mov eax,dword ptr COMIENZO		;es begin?
		cmp eax,dword ptr respuesta	
		jne	aversiesif					;no, entonces veo si es if

		invoke llamalexico
		invoke proposicion,base1,desplazamiento1	;si reinvoco funcion
		
			cmp byte ptr [huboerror],1	;hubo error??
			je  melaspico				;si entonces me voy
										;si es cero no llamo
			seguir:
				mov eax,dword ptr FIN		;es end?
				cmp eax,dword ptr respuesta	
				jne	aversiespuntoycoma		;no, entonces veo si es punto y coma

				invoke llamalexico
				ret							;si, entonces vuelvo
		aversiespuntoycoma:		
				mov eax,dword ptr PUNTO_COMA	;es punto y coma?
				cmp eax,dword ptr respuesta	
				jne	tamalpuntocoma				;no, entonces ta mal

				invoke llamalexico
				invoke proposicion 	,base1,desplazamiento1
				cmp byte ptr [huboerror],1			;hubo error??
				je	melaspico						;si me voy				
				jmp seguir							;si, reinvoco funcion y vuelvo
aversiesif:
		mov eax,dword ptr YES				;es if?
		cmp eax,dword ptr respuesta	
		jne	aversieswhile					;no, entonces veo si es while

		invoke llamalexico
		invoke	condicion,base1,desplazamiento1					;si llamo a condicion
				cmp byte ptr [huboerror],1		;hubo error??
				je melaspico					;si me voy
				mov eax,dword ptr ENTONCES		;es then?
				cmp eax,dword ptr respuesta	
				jne	tamalthen					;no, entonces ta mal
				mov dx,word ptr[jmpprop]
				push dx
				mov edx,dword ptr[jmppropexe]
				push edx
				invoke llamalexico
				invoke proposicion	,base1,desplazamiento1		;si llamo a proposicion
				pop edx
				mov dword ptr[jmppropexe],edx
				pop dx
				mov word ptr[jmpprop],dx
				pushad
				mov ax,word ptr[posejec]						;hago fix up del salto generado en condicion
				mov bx,word ptr[jmpprop]
				sub ax,bx
				and eax,0000FFFFh
				mov ebx,dword ptr[jmppropexe]
				mov dword ptr[ebx],eax
				popad
				ret							; y vuelvo
aversieswhile:
		mov eax,dword ptr MIENTRAS				;es while?
		cmp eax,dword ptr respuesta	
		jne	aversiesreadln							;no, entonces me voy

		invoke llamalexico
		mov dx,word ptr[posejec]
		push dx
		invoke	condicion,base1,desplazamiento1					;si llamo a condicion
				cmp byte ptr [huboerror],1		;hubo error??
				je melaspico					;si me voy
				mov eax,dword ptr HACER			;es do?
				cmp eax,dword ptr respuesta	
				jne	tamaldo						;no, entonces tamal
				mov dx,word ptr[jmpprop]
				push dx
				mov edx,dword ptr[jmppropexe]
				push edx
				invoke llamalexico
				invoke proposicion	,base1,desplazamiento1		;si llamo a proposicion
				pop edx
				mov dword ptr[jmppropexe],edx
				pop dx
				mov word ptr[jmpprop],dx
				pop dx
				pushad
				mov eax,dword ptr[psalidaexe]
				mov byte ptr[eax],0E9h							;agrego el salto hacia arriba
				inc eax
				xor ebx,ebx
				xor ecx,ecx
				mov bx,word ptr[posejec]						;hago el fix up del salto de condicion
				add ebx,5
				mov cx,dx
				sub ecx,ebx
				mov dword ptr[eax],ecx
				add dword ptr[psalidaexe],5
				add word ptr[posejec],5
				xor eax,eax
				xor ebx,ebx
				mov ax,word ptr[posejec]						;hago fix up del salto generado en condicion
				mov bx,word ptr[jmpprop]
				sub ax,bx
				mov ebx,dword ptr[jmppropexe]
				mov dword ptr[ebx],eax
				popad
				ret 						;y me voy
aversiesreadln:	
		mov eax,dword ptr LEERLI				;es readln?
		cmp eax,dword ptr respuesta	
		jne	aversieswriteln							;no, entonces me voy

		invoke llamalexico	
			mov eax,dword ptr ABREPAR		;es (?
			cmp eax,dword ptr respuesta	
			jne	tamalabrepar			;no, entonces esta mal
				mov edx,dword ptr[psalidaexe]		;rutina para leer del teclado
				mov byte ptr[edx],0E8h
				inc edx
				inc dword ptr[psalidaexe]
				inc word ptr[posejec]
				xor eax,eax
				mov ax,word ptr[posejec]
				add eax,4
				mov ebx,00000590h					;guardo la direccion y saco la cuenta del call
				sub ebx,eax
				mov dword ptr[edx],ebx
				add dword ptr[psalidaexe],4
				add word ptr[posejec],4
			invoke llamalexico	
			
				mov eax,dword ptr IDENTIFICADOR		;es identificador?
				cmp eax,dword ptr respuesta	
				jne	tamalid					;no, entonces ta mal
					llamadorsemantico base1,desplazamiento1
					invoke analizadorsemantico,ADDR identif,eax,ebx,01h,06h	;ultimo parametro en 6 por que es readln
					
					cmp byte ptr [huboerror],1	;hubo error??
					je  melaspico				;si entonces me voy
					mov eax,dword ptr[valor1]
					mov edx,dword ptr[psalidaexe]
					mov word ptr[edx],8789h
					add edx,2
					mov dword ptr[edx],eax
					add dword ptr[psalidaexe],6
					add word ptr [posejec],6
					mov dword ptr[valor1],00h
					invoke llamalexico
identificador:				
						mov eax,dword ptr COMA				;es coma?
						cmp eax,dword ptr respuesta	
						jne	aversiescierrapar				;no, entonces sigo
						mov edx,dword ptr[psalidaexe]		;rutina para leer del teclado
						mov byte ptr[edx],0E8h
						inc edx
						inc dword ptr[psalidaexe]
						inc word ptr[posejec]
						xor eax,eax
						mov ax,word ptr[posejec]
						add eax,4
						mov ebx,00000590h					;guardo la direccion y saco la cuenta del call
						sub ebx,eax
						mov dword ptr[edx],ebx
						add dword ptr[psalidaexe],4
						add word ptr[posejec],4
						invoke llamalexico
						mov eax,dword ptr IDENTIFICADOR		;es identificador?
						cmp eax,dword ptr respuesta	
						jne	tamalid					;no, entonces ta mal
						llamadorsemantico base1,desplazamiento1
						invoke analizadorsemantico,ADDR identif,eax,ebx,01h,06h	;ultimo parametro en 6 por que es readln
						cmp byte ptr [huboerror],1	;hubo error??
						je  melaspico				;si entonces me voy
							mov eax,dword ptr[valor1]
							mov edx,dword ptr[psalidaexe]

							mov word ptr[edx],8789h
							add edx,2
							mov dword ptr[edx],eax
							add dword ptr[psalidaexe],6
							add word ptr [posejec],6
							mov dword ptr[valor1],00h	
							invoke llamalexico		
							jmp identificador
			aversiescierrapar:
						mov eax,dword ptr CIERRAPAR			;es )?
						cmp eax,dword ptr respuesta	
						jne	tamalcierrapar					;no, entonces esta mal

						invoke llamalexico
						ret
aversieswriteln:
		mov eax,dword ptr ESCRIBIRLI				;es readln?
		cmp eax,dword ptr respuesta	
		jne	aversieswrite							;no, entonces me voy
		mov byte ptr[fuewriteln],01h
		invoke llamalexico
			mov eax,dword ptr ABREPAR		;es (?
			cmp eax,dword ptr respuesta	
			jne	melaspico			;no, entonces esta mal

			invoke llamalexico	
			jmp	aversiescadenaoexpresion
		
aversieswrite:
		mov eax,dword ptr ESCRIBIR				;es readln?
		cmp eax,dword ptr respuesta	
		jne	aversieshalt						;no, entonces me voy
		mov byte ptr[fuewriteln],00h
		invoke llamalexico
			mov eax,dword ptr ABREPAR		;es (?
			cmp eax,dword ptr respuesta	
			jne	tamalabrepar			;no, entonces esta mal

			invoke llamalexico	
			aversiescadenaoexpresion:
				mov eax,dword ptr CADENA		;es cadena?
				cmp eax,dword ptr respuesta	
				jne	aversiesexpresion			;no, entonces sigo
				copiacadena						;salvo la cadena
				pushad
				mov edx,dword ptr[psalidaexe]
				mov word ptr[edx],0B8h			;mov eax,.......
				inc dword ptr [psalidaexe]
				inc word ptr[posejec]
				xor ecx,ecx
				mov cx,word ptr[posejec]
				add word ptr[posejec],9
				add cx,14						;le sumo los bytes para pasar el call y el jmp
				sub ecx,200h					;le resto las rutinas de e/s
				add ecx,dword ptr[baseofcode]	;le sumo la base del codigo
				add ecx,dword ptr[imagebase]	;la base de la imagen
				mov edx,dword ptr[psalidaexe]	;y lo cargo al mov eax del principio
				mov dword ptr[edx],ecx			
				add edx,4	
				add dword ptr[psalidaexe],4		;se lo sumo al puntero
				mov byte ptr[edx],0E8h			;cargo el call
				inc dword ptr [psalidaexe]		;me pongo despues del e8
				mov eax,000003E0h
				xor ebx,ebx
				mov bx,word ptr[posejec]
				sub eax,ebx
				mov edx,dword ptr[psalidaexe]
				mov dword ptr[edx],eax			;actualizo el call
				add edx,4
				mov byte ptr[edx],0E9h			;cargo el salto
				add dword ptr[psalidaexe],5		;y actualizo punteros justo despues del e9
				add word ptr[posejec],5			;posejec lo mando despues del salto donde va a estar la cadena
				xor ecx,ecx
				mov cl,byte ptr[tamaniocadena]	;salvo el largo de la cadena con cero inclusive
				lea esi,cadenatemp				;leo la cadena
				mov edi,dword ptr[psalidaexe]	;leo el puntero a archivo exe
				add edi,4						;sumo sino piso el jmp
				rep movsb						;y copio la cadena
				xor eax,eax
				xor ecx,ecx
				xor ebx,ebx
				mov al,byte ptr[tamaniocadena]	;salvo el tamaño
				mov cx,word ptr[posejec]		;se lo sumo a pos ejec
				mov bx,cx
				add ecx,eax						;tengo la posicion donde termina la cadena
				sub ecx,ebx						;saco la distancia del salto
				mov edx,dword ptr[psalidaexe]
				mov dword ptr[edx],ecx			;actualizo el salto
				add dword ptr[psalidaexe],4		;los 4 bytes que actualice
				xor ecx,ecx
				mov cl,byte ptr[tamaniocadena]
				add dword ptr[psalidaexe],ecx	;le sumo el tamanio de la cadena
				add word ptr[posejec],cx
				popad
				invoke llamalexico
				jmp aversiescoma
			aversiesexpresion:			
				invoke expresion,base1,desplazamiento1
					pushad
					mov edx,dword ptr[psalidaexe]
					dec edx
					cmp byte ptr[edx],50h
					je seguir1
					mov edx,dword ptr[psalidaexe]
					mov byte ptr[edx],58h			;pop eax
					inc edx
					inc dword ptr[psalidaexe]
					inc word ptr [posejec]
					jmp seguirnormal
				seguir1:	
					dec dword ptr[psalidaexe]
					dec word ptr[posejec]
				seguirnormal:	
					xor eax,eax 
					mov edx,dword ptr[psalidaexe]
					mov byte ptr[edx],0E8h			;agrego el call 0420
					inc dword ptr[psalidaexe]
					mov ax,word ptr[posejec]
					add ax,5						;agrego los 5 bytes del call
					mov ebx,0420h
					sub ebx,eax
					mov edx,dword ptr[psalidaexe]
					mov dword ptr[edx],ebx
					add dword ptr[psalidaexe],4
					add word ptr[posejec],5
				aversiescoma:
						mov eax,dword ptr COMA				;es coma?
						cmp eax,dword ptr respuesta	
						jne	cierrapar				;no, entonces sigo

						invoke llamalexico
						
		aversiescadenaoexpresion2:		;si entonces siguiente cadena o expresion
						mov eax,dword ptr CADENA		;es cadena?
						cmp eax,dword ptr respuesta	
						jne	aversiesexpresion1			;no, entonces esta mal
						copiacadena
						pushad
						mov edx,dword ptr[psalidaexe]
						mov word ptr[edx],0B8h			;mov eax,.......
						inc dword ptr [psalidaexe]
						inc word ptr[posejec]
						xor ecx,ecx
						mov cx,word ptr[posejec]
						add word ptr[posejec],9
						add cx,14						;le sumo los bytes para pasar el call y el jmp
						sub ecx,200h					;le resto las rutinas de e/s
						add ecx,dword ptr[baseofcode]	;le sumo la base del codigo
						add ecx,dword ptr[imagebase]	;la base de la imagen
						mov edx,dword ptr[psalidaexe]	;y lo cargo al mov eax del principio
						mov dword ptr[edx],ecx			
						add edx,4	
						add dword ptr[psalidaexe],4		;se lo sumo al puntero
						mov byte ptr[edx],0E8h			;cargo el call
						inc dword ptr [psalidaexe]		;me pongo despues del e8
						mov eax,000003E0h
						xor ebx,ebx
						mov bx,word ptr[posejec]
						sub eax,ebx
						mov edx,dword ptr[psalidaexe]
						mov dword ptr[edx],eax			;actualizo el call
						add edx,4
						mov byte ptr[edx],0E9h			;cargo el salto
						add dword ptr[psalidaexe],5		;y actualizo punteros justo despues del e9
						add word ptr[posejec],5			;posejec lo mando despues del salto donde va a estar la cadena
						xor ecx,ecx
						mov cl,byte ptr[tamaniocadena]	;salvo el largo de la cadena con cero inclusive
						lea esi,cadenatemp				;leo la cadena
						mov edi,dword ptr[psalidaexe]	;leo el puntero a archivo exe
						add edi,4						;sumo sino piso el jmp
						rep movsb						;y copio la cadena
						xor eax,eax
						xor ecx,ecx
						xor ebx,ebx
						mov al,byte ptr[tamaniocadena]	;salvo el tamaño
						mov cx,word ptr[posejec]		;se lo sumo a pos ejec
						mov bx,cx
						add ecx,eax						;tengo la posicion donde termina la cadena
						sub ecx,ebx						;saco la distancia del salto
						mov edx,dword ptr[psalidaexe]
						mov dword ptr[edx],ecx			;actualizo el salto
						add dword ptr[psalidaexe],4		;los 4 bytes que actualice
						xor ecx,ecx
						mov cl,byte ptr[tamaniocadena]
						add dword ptr[psalidaexe],ecx	;le sumo el tamanio de la cadena
						add word ptr[posejec],cx
						popad						
						invoke llamalexico
						jmp aversiescoma
					
				aversiesexpresion1:	
						invoke expresion,base1,desplazamiento1

						pushad
						mov edx,dword ptr[psalidaexe]
						dec edx
						cmp byte ptr[edx],50h
						je seguir10
						mov edx,dword ptr[psalidaexe]
						mov byte ptr[edx],58h			;pop eax
						inc edx
						inc dword ptr[psalidaexe]
						inc word ptr [posejec]
						jmp seguirnormal10
					seguir10:	
						dec dword ptr[psalidaexe]
						dec word ptr[posejec]
					seguirnormal10:	
						xor eax,eax 
						mov edx,dword ptr[psalidaexe]
						mov byte ptr[edx],0E8h			;agrego el call 0420
						inc dword ptr[psalidaexe]
						mov ax,word ptr[posejec]
						add ax,5						;agrego los 5 bytes del call
						mov ebx,0420h
						sub ebx,eax
						mov edx,dword ptr[psalidaexe]
						mov dword ptr[edx],ebx
						add dword ptr[psalidaexe],4
						add word ptr[posejec],5
					
						jmp aversiescoma
				cierrapar:			
						mov eax,dword ptr CIERRAPAR			;es )?
						cmp eax,dword ptr respuesta	
						jne	tamalcierrapar					;no, entonces esta mal
						
						pushad
						cmp byte ptr[fuewriteln],00h
						je	melastomo
						mov edx,dword ptr[psalidaexe]
						mov byte ptr[edx],0E8h				;cargo el call
						mov eax,00000410h
						xor ebx,ebx
						mov bx,word ptr[posejec]
						add bx,5							;le sumo el tamaño del call
						sub eax,ebx
						inc edx
						mov dword ptr[edx],eax
						add dword ptr[psalidaexe],5
						add word ptr[posejec],5
				melastomo:	
						popad
						invoke llamalexico
						mov byte ptr[fuewriteln],00h
						ret					
melaspico:	
						pushad
						cmp byte ptr[fuewriteln],00h
						je	melastomo1
						mov edx,dword ptr[psalidaexe]
						mov byte ptr[edx],0E8h				;cargo el call
						mov eax,00000410h
						xor ebx,ebx
						mov bx,word ptr[posejec]
						add bx,5							;le sumo el tamaño del call
						sub eax,ebx
						inc edx
						mov dword ptr[edx],eax
						add dword ptr[psalidaexe],5
						add word ptr[posejec],5
				melastomo1:	
						popad
						mov byte ptr[fuewriteln],00h
	ret
aversieshalt:
				pushad
				mov eax,dword ptr HALT				;es halt?
				cmp eax,dword ptr respuesta	
				jne	melaspico						;no, entonces me voy	
				mov edx,dword ptr[psalidaexe]
				mov byte ptr[edx],0E9h			;genero el salto para salir del programa
				inc edx
				xor eax,eax
				mov ax,word ptr[posejec]
				add eax,5						;sumo los 5 bytes del jmp
				mov ebx,00000588h
				sub ebx,eax
				mov dword ptr[edx],ebx			;arreglo el salto
				add dword ptr[psalidaexe],5
				add word ptr[posejec],5
				popad
				invoke llamalexico
				ret
				
tamalasigna:
		invoke errorasignacion
		ret
tamalid:
		invoke errorid
		ret
tamalpuntocoma:
		invoke errorpuntocoma
		ret
tamalthen:
		invoke errorthen
		ret	
tamaldo:
		invoke errordo
		ret	
tamalcierrapar:
		invoke errorcierrapar
		ret
tamalabrepar:
		invoke errorabrepar
		ret	
proposicion endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
condicion proc base5:DWORD,desplazamiento5:DWORD

		mov eax,dword ptr ODD			;es odd?
		cmp eax,dword ptr respuesta	
		jne	aversiesexpresion			;no, entonces veo si es expresion

		invoke llamalexico
		invoke expresion,base5,desplazamiento5
		mov edx, dword ptr [psalidaexe]
		dec	edx
		cmp byte ptr[edx],50h
		je nopop
		inc edx
		mov byte ptr[edx],58h			;pop eax
		inc edx
		inc dword ptr[psalidaexe]
		inc word ptr[posejec]		
		jmp sipop
nopop:
		dec dword ptr[psalidaexe]
		dec word ptr[posejec]
sipop:	
		mov word ptr[edx],01A8h			;test al,01
		add edx,2
		mov word ptr[edx],057Bh			;jpo
		add edx,2
		mov byte ptr[edx],0E9h			;jmp.....
		add dword ptr[psalidaexe],09h
		add word ptr[posejec],09h
		mov dx,word ptr[posejec]
		mov word ptr[jmpprop],dx
		mov edx,dword ptr[psalidaexe]
		sub edx,4
		mov dword ptr[jmppropexe],edx	;guardo la direccion despues del e9
		ret
aversiesexpresion:		
		invoke expresion,base5,desplazamiento5
			cmp byte ptr [huboerror],1			;hubo error??
			je	salir							;si me voy
			mov eax,dword ptr I_GUAL			;es =?
			cmp eax,dword ptr respuesta	
			jne	aversiesdistinto					;no, entonces veo si es distinto

			invoke llamalexico
			invoke expresion,base5,desplazamiento5
			mov edx,dword ptr[psalidaexe]
			dec	edx
			cmp byte ptr[edx],50h
			je nopop1
			inc edx
			mov byte ptr[edx],58h			;pop eax
			inc edx
			inc dword ptr[psalidaexe]
			inc word ptr[posejec]		
			jmp sipop1
nopop1:
			dec dword ptr[psalidaexe]
			dec word ptr[posejec]
sipop1:	
			mov byte ptr[edx],5Bh					;pop ebx
			inc edx
			mov word ptr[edx],0C339h				;cmp eax,ebx
			add edx,2			
			mov word ptr[edx],0574h					;je
			add edx,2
			mov byte ptr[edx],0E9h					;jmp ......
			add dword ptr[psalidaexe],0Ah
			add word ptr[posejec],0Ah
			mov dx,word ptr[posejec]
			mov word ptr[jmpprop],dx
			mov edx,dword ptr[psalidaexe]
			sub edx,4
			mov dword ptr[jmppropexe],edx	;guardo la direccion despues del e9
			ret
aversiesdistinto:
			mov eax,dword ptr DISTINTO				;es <>?
			cmp eax,dword ptr respuesta	
			jne	aversiesmenor					;no, entonces veo si es menor

			invoke llamalexico
			invoke expresion,base5,desplazamiento5
			mov edx,dword ptr[psalidaexe]
			dec	edx
			cmp byte ptr[edx],50h
			je nopop2
			inc edx
			mov byte ptr[edx],58h			;pop eax
			inc edx
			inc dword ptr[psalidaexe]
			inc word ptr[posejec]	
			jmp sipop2
nopop2:
			dec dword ptr[psalidaexe]
			dec word ptr[posejec]
sipop2:	
			mov byte ptr[edx],5Bh
			inc edx
			mov word ptr[edx],0C339h
			add edx,2			
			mov word ptr[edx],0575h
			add edx,2
			mov byte ptr[edx],0E9h					;jmp ......			
			add dword ptr[psalidaexe],0Ah
			add word ptr[posejec],0Ah
			mov dx,word ptr[posejec]
			mov word ptr[jmpprop],dx
			mov edx,dword ptr[psalidaexe]
			sub edx,4
			mov dword ptr[jmppropexe],edx	;guardo la direccion despues del e9
			ret
aversiesmenor:
			mov eax,dword ptr MENOR					;es <?
			cmp eax,dword ptr respuesta	
			jne	aversiesmenorigual					;no, entonces veo si es menor igual

			invoke llamalexico
			invoke expresion,base5,desplazamiento5
			mov edx,dword ptr[psalidaexe]
			dec	edx
			cmp byte ptr[edx],50h
			je nopop3
			inc edx
			mov byte ptr[edx],58h			;pop eax
			inc edx
			inc dword ptr[psalidaexe]
			inc word ptr[posejec]			
			jmp sipop3
nopop3:
			dec dword ptr[psalidaexe]
			dec word ptr[posejec]
sipop3:	
			mov byte ptr[edx],5Bh
			inc edx
			mov word ptr[edx],0C339h
			add edx,2
			mov word ptr[edx],057Ch
			add edx,2
			mov byte ptr[edx],0E9h					;jmp ......			
			add dword ptr[psalidaexe],0Ah
			add word ptr[posejec],0Ah
			mov dx,word ptr[posejec]
			mov word ptr[jmpprop],dx
			mov edx,dword ptr[psalidaexe]
			sub edx,4
			mov dword ptr[jmppropexe],edx	;guardo la direccion despues del e9		
			ret
aversiesmenorigual:
			mov eax,dword ptr MENORIGUAL			;es <=?
			cmp eax,dword ptr respuesta	
			jne	aversiesmayor						;no, entonces veo si es mayor

			invoke llamalexico
			invoke expresion,base5,desplazamiento5
			mov edx,dword ptr[psalidaexe]
			dec	edx
			cmp byte ptr[edx],50h
			je nopop4
			inc edx
			mov byte ptr[edx],58h			;pop eax
			inc edx
			inc dword ptr[psalidaexe]
			inc word ptr[posejec]		
			jmp sipop4
nopop4:
			dec dword ptr[psalidaexe]
			dec word ptr[posejec]
sipop4:	
			mov byte ptr[edx],5Bh
			inc edx
			mov word ptr[edx],0C339h
			add edx,2			
			mov word ptr[edx],057Eh
			add edx,2
			mov byte ptr[edx],0E9h					;jmp ......			
			add dword ptr[psalidaexe],0Ah
			add word ptr[posejec],0Ah	
			mov dx,word ptr[posejec]
			mov word ptr[jmpprop],dx
			mov edx,dword ptr[psalidaexe]
			sub edx,4
			mov dword ptr[jmppropexe],edx	;guardo la direccion despues del e9	
			ret
aversiesmayor:
			mov eax,dword ptr MAYOR					;es >?
			cmp eax,dword ptr respuesta	
			jne	aversiesmayorigual					;no, entonces veo si es mayor igual

			invoke llamalexico
			invoke expresion,base5,desplazamiento5
			mov edx,dword ptr[psalidaexe]
			dec	edx
			cmp byte ptr[edx],50h
			je nopop5
			inc edx
			mov byte ptr[edx],58h			;pop eax
			inc edx
			inc dword ptr[psalidaexe]
			inc word ptr[posejec]		
			jmp sipop5
nopop5:
			dec dword ptr[psalidaexe]
			dec word ptr[posejec]
sipop5:	
			mov byte ptr[edx],5Bh
			inc edx
			mov word ptr[edx],0C339h
			add edx,2			
			mov word ptr[edx],057Fh
			add edx,2
			mov byte ptr[edx],0E9h					;jmp ......			
			add dword ptr[psalidaexe],0Ah
			add word ptr[posejec],0Ah	
			mov dx,word ptr[posejec]
			mov word ptr[jmpprop],dx
			mov edx,dword ptr[psalidaexe]
			sub edx,4
			mov dword ptr[jmppropexe],edx	;guardo la direccion despues del e9		
			ret
aversiesmayorigual:
			mov eax,dword ptr MAYORIGUAL			;es >=?
			cmp eax,dword ptr respuesta	
			jne	tamalmayor								;no, entonces si no es niguno esta mal

			invoke llamalexico
			invoke expresion,base5,desplazamiento5
			mov edx,dword ptr[psalidaexe]
			dec	edx
			cmp byte ptr[edx],50h
			je nopop6
			inc edx
			mov byte ptr[edx],58h			;pop eax
			inc edx
			inc dword ptr[psalidaexe]
			inc word ptr[posejec]		
			jmp sipop6
nopop6:
			dec dword ptr[psalidaexe]
			dec word ptr[posejec]
sipop6:	
			mov byte ptr[edx],5Bh
			inc edx
			mov word ptr[edx],0C339h
			add edx,2			
			mov word ptr[edx],057Dh
			add edx,2
			mov byte ptr[edx],0E9h					;jmp ......			
			add dword ptr[psalidaexe],0Ah
			add word ptr[posejec],0Ah
			mov dx,word ptr[posejec]
			mov word ptr[jmpprop],dx
			mov edx,dword ptr[psalidaexe]
			sub edx,4
			mov dword ptr[jmppropexe],edx	;guardo la direccion despues del e9			
			ret
tamalmayor:
			invoke errormayor
			ret	
salir:			
	ret
condicion endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
expresion proc base4:DWORD,desplazamiento4:DWORD

	mov eax,dword ptr MAS					;es +?
	cmp eax,dword ptr respuesta	
	jne	aversiesmenos						;no, entonces veo si es menos
	mov byte ptr[fuemenos],00h
	invoke llamalexico
	jmp	llamotermino
aversiesmenos:
	mov eax,dword ptr MENOS					;es -?
	cmp eax,dword ptr respuesta	
	jne	llamotermino						;no, entonces sigo
	mov byte ptr[fuemenos],01h
	invoke llamalexico	
llamotermino:	
	invoke termino,base4,desplazamiento4
				cmp byte ptr [huboerror],1			;hubo error??
				je	mevoy							;si me voy
				cmp byte ptr[fuemenos],01			;fue menos el anterior??
				jne nofuemenos
				mov edx,dword ptr[psalidaexe]
				dec	edx
				cmp byte ptr[edx],50h
				je nopop
				inc edx
				mov byte ptr[edx],58h			;pop eax
				inc edx
				inc dword ptr[psalidaexe]
				inc word ptr[posejec]
				jmp sipop
nopop:
				dec dword ptr[psalidaexe]
				dec word ptr[posejec]
sipop:	
				mov word ptr[edx],0D8F7h			;neg eax
				add edx,2
				mov byte ptr[edx],50h				;push eax
				add dword ptr[psalidaexe],3
				add word ptr[posejec],3
nofuemenos:				
				mov eax,dword ptr MAS					;es +?
				cmp eax,dword ptr respuesta	
				jne	aversiesmenos1						;no, entonces veo si es menos
				mov byte ptr[fuemenos],00h				;fue mas
				invoke llamalexico
				invoke termino,base4,desplazamiento4
				cmp byte ptr [huboerror],1			;hubo error??
				je	mevoy							;si me voy
				cmp byte ptr[fuemenos],00h
				je mas
				jne menos
				
		aversiesmenos1:
				mov eax,dword ptr MENOS					;es -?
				cmp eax,dword ptr respuesta	
				jne	mevoy								;no, entonces si no es niguno me voy
				mov byte ptr[fuemenos],01h
				invoke llamalexico
				invoke termino,base4,desplazamiento4
				cmp byte ptr [huboerror],1			;hubo error??
				je	mevoy							;si me voy				
				cmp byte ptr[fuemenos],00h
				je mas
				jne menos				
				
mevoy:	
	mov byte ptr[fuemenos],00h				
	ret
mas:
	mov edx,dword ptr[psalidaexe]
	dec	edx
	cmp byte ptr[edx],50h
	je nopop1
	inc edx
	mov byte ptr[edx],58h			;pop eax
	inc edx
	inc dword ptr[psalidaexe]
	inc word ptr[posejec]	
	jmp sipop1
nopop1:
	dec dword ptr[psalidaexe]
	dec word ptr[posejec]
sipop1:	
	mov byte ptr[edx],5Bh
	inc edx
	mov word ptr[edx],0D801h
	add edx,2
	mov byte ptr[edx],50h
	add dword ptr[psalidaexe],4
	add word ptr[posejec],4
	jmp nofuemenos
menos:	
	mov edx,dword ptr[psalidaexe]
	dec	edx
	cmp byte ptr[edx],50h
	je nopop2
	inc edx
	mov byte ptr[edx],58h			;pop eax
	inc edx
	inc dword ptr[psalidaexe]
	inc word ptr[posejec]	
	jmp sipop2
nopop2:
	dec dword ptr[psalidaexe]
	dec word ptr[posejec]
sipop2:	
	mov byte ptr[edx],5Bh
	inc edx
	mov byte ptr[edx],93h
	inc edx
	mov word ptr[edx],0D829h
	add edx,2
	mov byte ptr[edx],50h
	add dword ptr[psalidaexe],5
	add word ptr[posejec],5
	jmp nofuemenos
expresion endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
termino proc base3:DWORD,desplazamiento3:DWORD

llamofactor:	
	invoke factor ,base3,desplazamiento3
		cmp byte ptr[huboerror],1		;hubo error??
		je  mevoy						;si, salgo
	aver:
				mov eax,dword ptr POR_MUL					;es *?
				cmp eax,dword ptr respuesta	
				jne	aversiesdividido						;no, entonces veo si es dividido
				mov byte ptr[fuedividido],00h					;1 para dividido 0 para por
				invoke llamalexico
				invoke factor ,base3,desplazamiento3
				cmp byte ptr[huboerror],1		;hubo error??
				je  mevoy						;si, salgo		
				cmp byte ptr[fuedividido],00h
				je	multiplica
				jne	dividi
		aversiesdividido:
				mov eax,dword ptr DIVIDIR					;es /?
				cmp eax,dword ptr respuesta	
				jne	mevoy								    ;no, entonces si no es niguno me voy
				mov byte ptr[fuedividido],01h
				invoke llamalexico
				invoke factor ,base3,desplazamiento3
				cmp byte ptr[huboerror],1		;hubo error??
				je  mevoy						;si, salgo
				cmp byte ptr[fuedividido],00h
				je	multiplica
				jne	dividi				
mevoy:				
	ret
multiplica:
	mov edx,dword ptr[psalidaexe]
	dec	edx
	cmp byte ptr[edx],50h
	je nopop
	inc edx
	mov byte ptr[edx],58h			;pop eax
	inc edx
	inc dword ptr[psalidaexe]
	inc word ptr[posejec]		
	jmp sipop
nopop:
	dec dword ptr[psalidaexe]
	dec word ptr[posejec]
sipop:	
	mov byte ptr[edx],5Bh				;pop ebx
	inc edx
	mov word ptr[edx],0EBF7h			;imul ebx
	add edx,2
	mov byte ptr[edx],50h				;push eax
	add dword ptr[psalidaexe],4
	add word ptr[posejec],4
	jmp aver
dividi:
	mov edx,dword ptr[psalidaexe]
	dec	edx
	cmp byte ptr[edx],50h
	je nopop1
	inc edx
	mov byte ptr[edx],58h			;pop eax
	inc edx
	inc dword ptr[psalidaexe]
	inc word ptr[posejec]		
	jmp sipop1
nopop1:
	dec dword ptr[psalidaexe]
	dec word ptr[posejec]
sipop1:	
	mov byte ptr[edx],5Bh				;pop ebx
	inc edx
	mov byte ptr[edx],93h				;xchg eax,ebx
	inc edx
	mov byte ptr[edx],99h				;cdq
	inc edx
	mov word ptr[edx],0FBF7h			;idiv ebx
	add edx,2
	mov byte ptr[edx],50h				;push eax
	add dword ptr[psalidaexe],6
	add word ptr[posejec],6
	jmp aver	
termino endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
factor proc	base2:DWORD,desplazamiento2:DWORD
	
			mov eax,dword ptr IDENTIFICADOR		;es identificador?
			cmp eax,dword ptr respuesta	
			jne	aversiesnumero					;no, entonces veo si es numero
			llamadorsemantico base2,desplazamiento2
			invoke analizadorsemantico,ADDR identif,eax,ebx,01h,05h	;1 tiene que existir 5 es factor
			
			cmp byte ptr [huboerror],1	;hubo error??
			je  salir				;si entonces me voy
			
			cmp byte ptr[tipod],00h
			je ajaesvar					;0 es var sino es const
			mov edx,dword ptr[psalidaexe]
			mov byte ptr[edx],0B8h		;agrego el mov eax,.....
			inc edx
			mov eax,dword ptr[valor1]
			mov dword ptr[edx],eax		;cargo el valor
			add edx,04h
			mov byte ptr[edx],50h		;push eax
			add dword ptr[psalidaexe],06h		;le sumo los 5 bytes
			add word ptr[posejec],06h			;al puntero y a posejec	
			mov dword ptr[valor1],00000000h
			jmp sigamos
		ajaesvar:
			mov edx,dword ptr[psalidaexe]
			mov byte ptr[edx],08Bh		;agrego el mov eax,.....
			inc edx
			mov byte ptr[edx],87h
			inc edx
			mov eax,dword ptr[valor1]
			mov dword ptr[edx],eax
			add edx,4
			mov byte ptr[edx],50h
			add dword ptr[psalidaexe],07h
			add word ptr[posejec],07h
			mov dword ptr[valor1],00000000h
	sigamos:		
			invoke llamalexico
			ret									;si me voy				
aversiesnumero:
			mov eax,dword ptr NUMERO		;es numero?
			cmp eax,dword ptr respuesta	
			jne	aversiesparentesis			;no, entonces veo si abre parentesis
			ASCIIahex
			mov edx,dword ptr[psalidaexe]
			mov byte ptr[edx],0B8h			;mov eax....
			inc edx
			mov eax,dword ptr[numerito]		;le paso el numero en hexa
			mov dword ptr[edx],eax			
			add edx,4
			mov byte ptr[edx],50h			;push eax....
			add dword ptr[psalidaexe],06h
			add word ptr[posejec],06h
			 
			invoke llamalexico
			ret								;si me voy
aversiesparentesis:
			mov eax,dword ptr ABREPAR		;es (?
			cmp eax,dword ptr respuesta	
			jne	tamalidnumabrepar			;no, entonces si no es ninguno esta mal
			mov al,byte ptr[fuemenos]
			push ax
			invoke llamalexico
				invoke expresion,base2,desplazamiento2
					pop dx
					mov byte ptr[fuemenos],dl
					cmp byte ptr [huboerror],1			;hubo error??
					je	salir							;si me voy
					mov eax,dword ptr CIERRAPAR		;es )?
					cmp eax,dword ptr respuesta	
					jne	tamalcierrapar						;no, entonces esta mal

					invoke llamalexico
					ret
tamalidnumabrepar:
		invoke erroridnumabrepar
		ret
tamalcierrapar:
		invoke errorcierrapar
salir:		
		ret	
factor endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errorid proc
	lea esi,mensajeerrorid
	mov edi,dword ptr [psalidamensaje]
	mov ecx,7
	cld
	rep movsd
	add dword ptr [Psalidaoriginal],1Ch
	mov byte ptr  [huboerror],1
	
	ret
errorid endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errorigual proc
	lea esi,mensajeerrorigual
	mov edi,dword ptr [psalidamensaje]
	mov ecx,5
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],20
	mov byte ptr[huboerror],1
	ret
errorigual endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errornum proc
	
	lea esi,mensajeerrornum
	mov edi,dword ptr [psalidamensaje]
	mov ecx,6
	cld
	rep movsd
	add dword ptr [Psalidaoriginal],24
	mov dword ptr[huboerror],1
	ret
	
errornum endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errorcomapuntocoma proc
	
	lea esi,mensajeerrorcpc
	mov edi,dword ptr [psalidamensaje]
	mov ecx,6
	cld
	rep movsd
	add dword ptr [Psalidaoriginal],24
	mov dword ptr[huboerror],1
	ret
	
errorcomapuntocoma endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errorpuntocoma proc
	
	lea esi,mensajeerrorpc
	mov edi,dword ptr [psalidamensaje]
	mov ecx,5
	cld
	rep movsd
	add dword ptr [Psalidaoriginal],20
	mov dword ptr[huboerror],1
	ret
	
errorpuntocoma endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errorthen proc
	lea esi,mensajeerrorthen
	mov edi,dword ptr [psalidamensaje]
	mov ecx,5
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],20
	mov byte ptr[huboerror],1
	ret
errorthen endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errordo proc
	lea esi,mensajeerrordo
	mov edi,dword ptr [psalidamensaje]
	mov ecx,4
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],16
	mov byte ptr[huboerror],1
	ret
errordo endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errormayor proc
	lea esi,mensajeerrormayor
	mov edi,dword ptr [psalidamensaje]
	mov ecx,12
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],48
	mov byte ptr[huboerror],1
	ret
errormayor endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errormasmenos proc
	
	lea esi,mensajeerrormasmenos
	mov edi,dword ptr [psalidamensaje]
	mov ecx,6
	cld
	rep movsd
	add dword ptr [Psalidaoriginal],24
	mov dword ptr[huboerror],1
	ret
	
errormasmenos endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
erroridnumabrepar proc
	
	lea esi,mensajeerroridnumabrepar
	mov edi,dword ptr [psalidamensaje]
	mov ecx,10
	cld
	rep movsd
	add dword ptr [Psalidaoriginal],40
	mov dword ptr[huboerror],1
	ret
	
erroridnumabrepar endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errorcierrapar proc
	
	lea esi,mensajeerrorcierrapar
	mov edi,dword ptr [psalidamensaje]
	mov ecx,4
	cld
	rep movsd
	add dword ptr [Psalidaoriginal],16
	mov dword ptr[huboerror],1
	ret
	
errorcierrapar endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errorpunto proc
	lea esi,mensajeerrorpunto
	mov edi,dword ptr [psalidamensaje]
	mov ecx,4
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],16
	mov byte ptr[huboerror],1
	ret
errorpunto endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errorasignacion proc
	lea esi,mensajeerrorasignacion
	mov edi,dword ptr [psalidamensaje]
	mov ecx,4
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],16
	mov byte ptr[huboerror],1
	ret
errorasignacion endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
errorabrepar proc
	lea esi,mensajeerrorabrepar
	mov edi,dword ptr [psalidamensaje]
	mov ecx,4
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],16
	mov byte ptr[huboerror],1
	ret
errorabrepar endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
analizadorsemantico proc	id:DWORD,indice:DWORD,base:DWORD,tienequeexistir:BYTE,tipo:BYTE	;recibe el identificador y el indice de la tabla en base a eso compara desde indice hacia atras
;verificar bien por las dudas
;tipo:
;0 = var
;1 = const
;2 = procedure
;3 = call
;4 = proposicion
;5 = factor
;6 = readln		
	pushad
	mov eax,dword ptr[indice]	;guardo el indice
	mov ebx,dword ptr[base]		;copio base a ebx
	add eax,ebx					;le sumo la base para ir al ulimo ingresado
	dec eax						;desplazamiento -1
	js	nosoniguales			;si era cero salgo directamente total no hay nada para ver
sigo:	
	
	mov esi,id					;guardo el identificador
	lea edi,ids					;guardo la tabla
	mov ecx,77
	push eax					;guardo el indice

	mul ecx						;multiplico eax por 75 tamaño del struct
	add edi,eax					;se lo sumo a edi para ver a cual posicion del vector voy
	mov ecx,63					;cargo las iteraciones
	pop eax
	cld
	repe cmpsb	
	je iguales					;son iguales
	
	
	dec eax
	js  nosoniguales
	cmp ebx,eax
	jle sigo
	jmp nosoniguales
iguales:
	push esi
	push edi
	push ecx
	mov esi,edi
	add esi,0ah
	lea edi,valor1
	mov ecx,1
	rep movsd					;guardo en valor lo que se encontro
	pop ecx
	pop edi
	pop esi
	mov al,01h					;se encontro
;	cmp tienequeexistir,01h		;tiene que existir??
;	jne	tamalnotienequeexistir	;no, entonces ta mal
;	jmp cargatabla	
	cmp byte ptr[tipo],0		;es tipo var?
	je	tamalnotienequeexistir	

	cmp byte ptr[tipo],1		;es tipo const?
	je tamalnotienequeexistir

	cmp byte ptr[tipo],2		;es tipo procedure
	je	tamalnotienequeexistir	

	cmp byte ptr[tipo],3		; es tipo call?
	jne espropo
	mov ecx,4
	lea esi,operadores+8
	repe cmpsb
	jne  tamalnotaprocedure		;indicar que falta le procedure con ese nombre
	jmp salida1
espropo:	
	
	cmp byte ptr[tipo],4		; es tipo proposicion?
	jne esfact
	mov ecx,3
	lea esi,operadores			;tiene que ser var
	repe cmpsb
	jne tamalnotavar			;indicar que falta el var con ese nombre
	jmp salida1
esfact:	
	
	cmp byte ptr[tipo],5		;es tipo factor?
	jne esread
	mov byte ptr[tipod],00h
	mov ecx,3
	mov edx,edi
	lea esi,operadores
	repe cmpsb
	je salida1
	mov byte ptr[tipod],01h
	mov ecx,4
	mov edi,edx
	lea esi,operadores+3
	repe cmpsb
	jne tamalnotavarniconst		;indicar que falta un var o const con ese nombre
	jmp salida1
esread:	
	

	
	mov ecx,3
	lea esi,operadores
	repe cmpsb
	jne tamalnotavar			;indicar que falta un var de ese nombre
	jmp salida1
nosoniguales:					;si no existe devuelvo 0 en eax
	mov al,00h
;	cmp tienequeexistir,00h		;tiene que existir??
;	jne  tamaltienequeexistir
;	jmp cargatabla
	cmp byte ptr[tipo],0		;es tipo var?
	je	esvar				
	cmp byte ptr[tipo],1		;es tipo const?
	je esconst
	cmp byte ptr[tipo],2		;es tipo procedure
	je	esprocedure			
	cmp byte ptr[tipo],3		; es tipo call?
	je escall
	cmp byte ptr[tipo],4		; es tipo proposicion?
	je esproposicion			
	cmp byte ptr[tipo],5		;es tipo factor?
	je esfactor
	cmp byte ptr[tipo],6		;es tipo readln?
	je	esreadln	
salida:
	popad
	ret
tamaltienequeexistir:
	popad
	invoke idtienequeexistir
	ret
tamalnotienequeexistir:	
	popad
	invoke idnotienequeexistir
	ret
tamalnotaprocedure:
	popad
	invoke notaprocedure
	ret	
tamalnotavar:
	popad
	invoke notavar
	ret
tamalnotavarniconst:
	popad
	invoke notavarniconst
	ret	
cargatabla:	

	mov esi,id					;guardo el identificador
	lea edi,ids					;guardo la tabla
	mov eax,dword ptr[indice]
	mov ebx,dword ptr[base]
	mov ecx,77
	add eax,ebx
	mul ecx						;multiplico eax por 77 tamaño del struct
	add edi,eax					;se lo sumo a edi para ver a cual posicion del vector voy
	mov ecx,63					;cargo las iteraciones
	cld
	rep movsb					;copio a la tabla
	cmp byte ptr[tipo],0		;es tipo var?
	jne	averconst
	mov ecx,3
	lea esi,operadores
	rep movsb
	add edi,7
	lea esi,contvar				;si es var guardo valor de a 4 en 4
	mov ecx,1
	rep movsw
	add dword ptr[contvar],00000004h
	jmp salida1
averconst:	
	cmp byte ptr[tipo],1		;es tipo const?
	jne averprocedure
	mov ecx,4
	lea esi,operadores+3
	rep movsb
	add edi,6
	mov dword ptr[valorconst],edi	;guardo la posicion para cargar el valor despues
	jmp salida1
averprocedure:	
	cmp byte ptr[tipo],2
	jne salida1
	mov ecx,4
	lea esi,operadores+8
	rep movsb
	add edi,6
	lea esi,posejec
	mov ecx,2
	rep movsb
	jmp salida1	

salida1:	
	mov ecx,299
a_cero:
	mov byte ptr[identif+ecx],20h
	loop a_cero
	mov byte ptr[identif],20h
	jmp	salida
esvar:
	cmp tienequeexistir,al		;no tiene que existir
	jne tamalnotienequeexistir
	inc byte ptr[contadorids]	;incremento el contador de variables
	jmp cargatabla
esconst:
	cmp tienequeexistir,al		;no tiene que existir
	jne tamalnotienequeexistir
	jmp cargatabla
esprocedure:
	cmp tienequeexistir,al		;no tiene que existir
	jne tamalnotienequeexistir
	jmp cargatabla
escall:
	hastaelfondo base,indice,id
	cmp tienequeexistir,al		;tiene que existir
	jne tamalnotaprocedure
	jmp salida1	
esproposicion:
	hastaelfondo base,indice,id
	cmp tienequeexistir,al		;tiene que existir
	jne tamalnotavarniconst
	jmp salida1	
esfactor:
	hastaelfondo base,indice,id
	cmp tienequeexistir,al		;tiene que existir
	jne tamalnotavarniconst
	jmp salida1	
esreadln:
	hastaelfondo base,indice,id
	cmp tienequeexistir,al		;tiene que existir
	jne tamalnotavar
	jmp salida1	
analizadorsemantico endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
idtienequeexistir proc
	lea esi,mensajeidtienequeexistir
	mov edi,dword ptr [psalidamensaje]
	mov ecx,12
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],45
	mov byte ptr[huboerror],1
	ret
idtienequeexistir endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
idnotienequeexistir proc
	lea esi,mensajeidnotienequeexistir
	mov edi,dword ptr [psalidamensaje]
	mov ecx,12
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],45
	mov byte ptr[huboerror],1
	ret
idnotienequeexistir endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
notaprocedure proc
	lea esi,mensajeerrorprocedure
	mov edi,dword ptr [psalidamensaje]
	mov ecx,12
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],45
	mov byte ptr[huboerror],1
	ret
notaprocedure endp
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
notavar proc	
	lea esi,mensajeerrorfaltavar
	mov edi,dword ptr [psalidamensaje]
	mov ecx,10
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],40
	mov byte ptr[huboerror],1
	ret
notavar endp	
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««	
notavarniconst proc
	lea esi,mensajeerrornotavarniconst
	mov edi,dword ptr [psalidamensaje]
	mov ecx,14
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],56
	mov byte ptr[huboerror],1
	ret
notavarniconst endp	
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««	
errormuylargo proc
	lea esi,mensajeerrormuylargo
	mov edi,dword ptr [psalidamensaje]
	mov dword ptr[Psalidaoriginal],edi
	mov ecx,14
	cld
	rep	movsd
	add dword ptr [Psalidaoriginal],56
	mov byte ptr[huboerror],1
	ret
errormuylargo endp	
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««	
end LibMain
