@echo off
if exist analizadorlexico.obj del analizadorlexico.obj
if exist analizadorlexico.dll del analizadorlexico.dll
\masm32\bin\ml /c /coff analizadorlexico.asm
\masm32\bin\Link /SUBSYSTEM:WINDOWS /DLL /DEF:analizadorlexico.def analizadorlexico.obj 
del analizadorlexico.obj
del analizadorlexico.exp
dir analizadorlexico.*
pause
