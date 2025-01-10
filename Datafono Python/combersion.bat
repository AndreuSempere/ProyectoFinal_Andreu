@echo off
REM Verifica que el archivo .ui haya sido arrastrado
if "%~1"=="" (
    echo No se ha proporcionado ningun archivo .ui
    pause
    exit /b
)

REM Convierte el archivo .ui a .py
pyuic6 -x "%~1" -o "%~dpn1.py"

REM Mensaje de éxito
echo Conversión completada: %~dpn1.py
pause
