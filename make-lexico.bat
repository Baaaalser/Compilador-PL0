@echo off
if exist analizador-lexico.obj del analizador-lexico.obj
if exist analizador-lexico.dll del analizador-lexico.dll
\masm32\bin\ml /c /coff analizador-lexico.asm
\masm32\bin\Link /SUBSYSTEM:WINDOWS /DLL /DEF:analizador-lexico.def analizador-lexico.obj 
del analizador-lexico.obj
del analizador-lexico.exp
dir analizador-lexico.*
pause
