@echo off
if exist analizadorsintactico.obj del analizadorsintactico.obj
if exist analizadorsintactico.dll del analizadorsintactico.dll
\masm32\bin\ml /c /coff analizadorsintactico.asm
\masm32\bin\Link /SUBSYSTEM:WINDOWS /DLL /DEF:analizadorsintactico.def analizadorsintactico.obj 
del analizadorsintactico.obj
del analizadorsintactico.exp
dir analizadorsintactico.*
pause
