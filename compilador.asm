.486
.model flat,stdcall	;memoria plana
option casemap:none ;case sensitive
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD			;prototipo de funcion para el procedimiento de ventana
analisissintactico proto :DWORD,:DWORD,:DWORD 	; prototipo de la funcion analisis sintactico

include \masm32\include\windows.inc  ;las api...
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\comdlg32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comdlg32.lib
includelib analizador-sintactico.lib

.const 	;definicion de constantes
IDM_OPEN equ 1		;constantes del control menu
IDM_SAVE equ 2
IDM_EXIT equ 3
IDM_ANALISIS equ 4	
MAXSIZE equ 260		;tamaño de caracteres para alojar directorio de archivo si es mayor hasta windows no lo reconoce...
MEMSIZE equ 65535	; espacio de memoria reservado para archivo a abrir y luego para cerrar (nadie va a hacer mas de 64k en PL0 supongo)
MEMSIZEEXE equ	2048000	;2 mega para el exe mas no creo que tenga
EditID equ 1
  

.data ; datos inicializados

ClassName 		db "Win32ASMEditClass",0 	;clase ventana
AppName  		db "Compilador PL0",0 		;tiutlo de la ventana
EditClass		db "edit",0 				;clase de la caja de edicion de texto
MenuName 		db "Mimenu",0  				;nombre de la clase menu (archivo de recurso)
ofn   OPENFILENAME <>   					;estructura para dialog box
FilterString 	db "Todos los archivos",0,"*.*",0  ;cadena de filtro para dialog box
				db "Archivos PL0",0,"*.txt",0,0    
buffer 			db MAXSIZE dup(0)    		;buffer para almacenar nombre de archivo
nombreexe		db MAXSIZE dup(0)			;buffer para nombre del ejecutable
prueba 			db MAXSIZE dup(0)    		;nombre para guardar archivo de prueba
extensionprueba	db ".lst",0
titulomensaje 	db "Compilador PL/0",0
extension		db ".exe",0					;extension ejectable
mensajeok 		db "Se escribieron:      Bytes",0
mensajenook 	db "Se produjo un error al escribir archivo",0
BytesaEscribir	db 4 dup(0)					;variable para alojar los bytes a escribir en el archivo

CadenaComparar	db 40 dup(0)				; variable temporal asi cargo las palabras a comparar en el analizador lexico


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
    MENOR			db	"_MENOR  ",0        ;menor
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
	

.data? 

 ;datos no inicializados
 
hInstance HINSTANCE ? 	;instancia de ventana
CommandLine LPSTR ?		;puntero a la linea de comando
hwndEdit HWND ? 		;handle de ventana de texto
hFile HANDLE ?  		;handle para archivo
hMenu HANDLE ?  		;handle para menu
hMemory HANDLE ?    	;handle para memoria
hMemorydos HANDLE ?    	;handle para memoria
hmemoryexe	HANDLE ?	;handle para memoria del ejecutable
pMemory DWORD ? 		;puntero a memoria
Ptexto DWORD ?  		;puntero a memoria para texto temporal del control edit
Pmemoryexe DWORD ?		;puntero a memoria de bytes a escribir en el exe
SizeReadWrite DWORD ?   ;puntero a bytes escritos/leidos
PcadenaS	DWORD ?   	;variable que va a alojar el texto a escribir en el analizador lexico asi lo escribo en archivo aparte
PcadenaSoriginal DWORD ?;variable para alojar el puntero original al texto de salida	
Pexe			DWORD ?	;puntero a archivo exe
Pexeoriginal	DWORD ? ;puntero original asi despues saco la cuenta de los bytes a escribir			

.code   ;codigo...
start:
	invoke GetModuleHandle, NULL   	;pido manejador para mi ventana
	mov    hInstance,eax  			;lo guardo
	invoke GetCommandLine  			;pido linea de comando para mensajes
	invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT ; llamo al constructor de ventana
	invoke ExitProcess,eax 			;cierro aplicacion
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL wc:WNDCLASSEX    			;tipo de clase
	LOCAL msg:MSG  					;mensajes
	LOCAL hwnd:HWND    				;manejador
	mov   wc.cbSize,SIZEOF WNDCLASSEX  ;parametros de ventana
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	mov   wc.cbClsExtra,NULL
	mov   wc.cbWndExtra,NULL
	push  hInst
	pop   wc.hInstance
	mov   wc.hbrBackground,COLOR_WINDOW+1
	mov   wc.lpszMenuName,OFFSET MenuName
	mov   wc.lpszClassName,OFFSET ClassName
	invoke LoadIcon,NULL,IDI_APPLICATION ;icono
	mov   wc.hIcon,eax
	mov   wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW ;sino cargo esto no tgengo puntero de mouse
	mov   wc.hCursor,eax
	invoke RegisterClassEx, addr wc ;registro la clase
	INVOKE CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassName,ADDR AppName,\
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
           CW_USEDEFAULT,300,200,NULL,NULL,\
           hInst,NULL
	mov   hwnd,eax ;creo la ventana y guardo manejador
	INVOKE ShowWindow, hwnd,SW_SHOWNORMAL  ;la muestro
	INVOKE UpdateWindow, hwnd
	.WHILE TRUE    ;ciclo infinito de captura de mensajes
                INVOKE GetMessage, ADDR msg,NULL,0,0
                .BREAK .IF (!eax)   ;si hay mensaje
                INVOKE TranslateMessage, ADDR msg   ;lo proceso
                INVOKE DispatchMessage, ADDR msg    ;lo devuevo al sistema
	.ENDW
	mov     eax,msg.wParam
	ret
WinMain endp
WndProc proc uses ebx hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM    ;mensajes de ventana
	.IF uMsg==WM_CREATE    ;creo interfaz
		INVOKE CreateWindowEx,NULL,ADDR EditClass,NULL,\
                   WS_VISIBLE or WS_CHILD or ES_LEFT or ES_MULTILINE or\
                   WS_HSCROLL or WS_VSCROLL,0,\
                   0,0,0,hWnd,EditID,\
                   hInstance,NULL
		mov hwndEdit,eax
		invoke SetFocus,hwndEdit
		mov ofn.lStructSize,SIZEOF ofn
		push hWnd
		pop  ofn.hWndOwner
		push hInstance
		pop  ofn.hInstance
		mov  ofn.lpstrFilter, OFFSET FilterString
		mov  ofn.lpstrFile, OFFSET buffer
		mov  ofn.nMaxFile,MAXSIZE
    invoke GetMenu,hWnd
		mov  hMenu,eax
	.ELSEIF uMsg==WM_SIZE  ;si redimensionamos...
		mov eax,lParam
		mov edx,eax
		shr edx,16
		and eax,0ffffh
		invoke MoveWindow,hwndEdit,0,0,eax,edx,TRUE
	.ELSEIF uMsg==WM_DESTROY ;cruz de salir??
		invoke PostQuitMessage,NULL
	.ELSEIF uMsg==WM_COMMAND   ;mensaje de accion sobre ventana
		mov eax,wParam
		.if lParam==0
			.if ax==IDM_OPEN ;si viene del menu
				mov  ofn.Flags, OFN_FILEMUSTEXIST or \
                                OFN_PATHMUSTEXIST or OFN_LONGNAMES or\
                                OFN_EXPLORER or OFN_HIDEREADONLY
				invoke GetOpenFileName, ADDR ofn    ;muestro pantalla de dialogo de abrir archivo
				.if eax==TRUE   ;si todo sale bien...
					invoke CreateFile,ADDR buffer,\
                                       GENERIC_READ or GENERIC_WRITE ,\
                                       FILE_SHARE_READ or FILE_SHARE_WRITE,\
                                       NULL,OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,\
                                       NULL ;creo el archivo
					mov hFile,eax
					invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,MEMSIZE  ;reservo espacio en memoria
					mov  hMemory,eax
					invoke GlobalLock,hMemory  ;lo asigno
					mov  pMemory,eax
					invoke ReadFile,hFile,pMemory,MEMSIZE-1,ADDR SizeReadWrite,NULL    ;y leo el archivo
					invoke SendMessage,hwndEdit,WM_SETTEXT,NULL,pMemory    ;ahora lo coloco en la caja de texto
					invoke CloseHandle,hFile   ;cierro el archivo
					invoke GlobalUnlock,pMemory    ;libero memoria
					invoke GlobalFree,hMemory
                              invoke EnableMenuItem,hMenu,IDM_SAVE,MF_ENABLED  ;habilito salvar archivo
                              invoke EnableMenuItem,hMenu,IDM_ANALISIS,MF_ENABLED ;habilito analisis lexico
							  
							  
							  ;ahora copio el nombre del archivo y le cambio la extension por exe
							  pushad
							  lea esi,buffer
							  lea edi,nombreexe
							  mov ecx,MAXSIZE
							  cld
							  rep movsb					;copio ta cual esta
							  mov ecx,MAXSIZE
							  lea edi,nombreexe			;ahora busco el '.'
							  mov al,'.'
							  repne scasb
							  mov ebx,ecx
							  lea esi,extension			;en ecx esta la posicion del punto
							  lea edi,nombreexe
							  mov ecx,MAXSIZE			;saco la diferencia de lo que conto ecx hasta el . y lo que faltaba
							  sub ecx,ebx
							  add edi,ecx				;se lo sumo a edi asi apunto al caracter siguiente al punto
							  dec edi					;ahora si apunto al punto :P
							  mov ecx,4
							  rep movsb					;sigo de edi para adelante o se de . al final y cambio la extension
							  lea esi,buffer
							  lea edi,prueba
							  mov ecx,MAXSIZE
							  cld
							  rep movsb					;copio ta cual esta
							  mov ecx,MAXSIZE
							  lea edi,prueba			;ahora busco el '.'
							  mov al,'.'
							  repne scasb
							  mov ebx,ecx
							  lea esi,extensionprueba	;en ecx esta la posicion del punto
							  lea edi,prueba
							  mov ecx,MAXSIZE			;saco la diferencia de lo que conto ecx hasta el . y lo que faltaba
							  sub ecx,ebx
							  add edi,ecx				;se lo sumo a edi asi apunto al caracter siguiente al punto
							  dec edi					;ahora si apunto al punto :P
							  mov ecx,4
							  rep movsb					;sigo de edi para adelante o se de . al final y cambio la extension
							  popad							  
							  
				.endif
					invoke SetFocus,hwndEdit ; doy foco a la caja de texto
			.elseif ax==IDM_SAVE  ; si guardo...
				mov ofn.Flags,OFN_LONGNAMES or\
                                OFN_EXPLORER or OFN_HIDEREADONLY
				invoke GetSaveFileName, ADDR ofn
				.if eax==TRUE   ;hago lo mismo pero para guardar el archivo
					invoke CreateFile,ADDR buffer,\
                                                GENERIC_READ or GENERIC_WRITE ,\
                                                FILE_SHARE_READ or FILE_SHARE_WRITE,\
                                                NULL,CREATE_NEW,FILE_ATTRIBUTE_ARCHIVE,\
                                                NULL
					mov hFile,eax
					invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,MEMSIZE
					mov  hMemory,eax
					invoke GlobalLock,hMemory
					mov  pMemory,eax
					invoke SendMessage,hwndEdit,WM_GETTEXT,MEMSIZE-1,pMemory
					invoke WriteFile,hFile,pMemory,eax,ADDR SizeReadWrite,NULL
					invoke CloseHandle,hFile
					invoke GlobalUnlock,pMemory
					invoke GlobalFree,hMemory
                              
                                
				.endif
				invoke SetFocus,hwndEdit
            .elseif ax==IDM_ANALISIS
						invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,MEMSIZE			;creo espacio en memoria
						mov  hMemory,eax													;guardo el manejador de memoria
						invoke GlobalLock,hMemory											;la fijo 
					  mov  Ptexto,eax														;guardo el puntero a memoria donde voy a alojar el texto original
						invoke SendMessage,hwndEdit,WM_GETTEXT,MEMSIZE-1,Ptexto				;obtengo el texto
						invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,MEMSIZE			;ahora creo espacio en memoria para el texto de salida
					  mov  hMemorydos,eax													;guardo el puntero
						invoke GlobalLock,hMemorydos										;fijo la memoria
					  mov  PcadenaS,eax   												;y guardo el puntero a memoria fija para escribir texto de salida
						mov  PcadenaSoriginal,eax 											;y tambien lo guardo en la variable de puntero original asi veo el tamaño del archivo antes de escribirlo
						mov dword ptr [eax],31303030h 									; le agrego el primer renglon al archivo de salida
						add dword ptr [PcadenaS],4
						mov eax,dword ptr[PcadenaS]
						mov dword ptr [eax],3Ah       									; le agrego el :
						inc dword ptr [PcadenaS]			 							;ya esta listo para pasarlo al analizador	
						invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,MEMSIZEEXE		;reservo espacio para el exe
						mov hmemoryexe,eax
						invoke GlobalLock,hmemoryexe
						mov Pexe,eax														;puntero a  memoria para el exe
						mov Pexeoriginal,eax

							
						invoke  analisissintactico,Ptexto,PcadenaS,Pexe					;llamo al analizador sintactico y le paso el puntero del archivo leido
						mov dword ptr [BytesaEscribir],ebx 								;guardo los bytes a escribir
																							;en eax recibo que voy a escribir si el exe 1 o la lista 0
							.if al==1																
								invoke CreateFile,ADDR prueba,\
                                                GENERIC_READ or GENERIC_WRITE ,\
                                                FILE_SHARE_READ or FILE_SHARE_WRITE,\
                                                NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,\
                                                NULL
								mov hFile,eax
								mov ecx,dword ptr[BytesaEscribir] 
								add ecx,5
								invoke WriteFile,hFile,PcadenaSoriginal, ecx,ADDR SizeReadWrite,NULL
								invoke CloseHandle,hFile
								invoke GlobalUnlock,Ptexto
								invoke GlobalFree,hMemory   
								invoke GlobalUnlock,PcadenaS
								invoke GlobalFree,hMemorydos
								invoke GlobalUnlock,Pexe
								invoke GlobalFree,hmemoryexe
							.else
								invoke CreateFile,ADDR nombreexe,\
                                                GENERIC_READ or GENERIC_WRITE ,\
                                                FILE_SHARE_READ or FILE_SHARE_WRITE,\
                                                NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,\
                                                NULL
								mov hFile,eax
								mov ecx,dword ptr[BytesaEscribir]	
								invoke WriteFile,hFile,Pexeoriginal, ecx,ADDR SizeReadWrite,NULL
								invoke CloseHandle,hFile
								invoke GlobalUnlock,Ptexto
								invoke GlobalFree,hMemory   
								invoke GlobalUnlock,PcadenaS
								invoke GlobalFree,hMemorydos
								invoke GlobalUnlock,Pexe
								invoke GlobalFree,hmemoryexe
							.endif	
			.else
				invoke DestroyWindow, hWnd
			.endif
		.endif
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.ENDIF
	xor    eax,eax
	ret
WndProc endp

end start
