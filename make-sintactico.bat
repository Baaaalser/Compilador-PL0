@echo off
if exist analizador-sintactico.obj del analizador-sintactico.obj
if exist analizador-sintactico.dll del analizador-sintactico.dll
\masm32\bin\ml /c /coff analizadorsintactico.asm
\masm32\bin\Link /SUBSYSTEM:WINDOWS /DLL /DEF:analizador-sintactico.def analizador-sintactico.obj 
del analizador-sintactico.obj
del analizador-sintactico.exp
dir analizador-sintactico.*
pause
