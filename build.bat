@echo off
rem Genera el lexer con JFlex, compila con javac y arma el JAR ejecutable.
rem Requisitos: JDK 11 o superior en el PATH.
cd /d "%~dp0"
java -jar lib\jflex-full-1.8.2.jar -d src\compilador Lexico.flex || exit /b 1
if exist bin rmdir /s /q bin
mkdir bin
javac -encoding UTF-8 --release 11 -d bin src\compilador\*.java || exit /b 1
jar cfe Compilador.jar compilador.Main -C bin . || exit /b 1
echo Listo: Compilador.jar  (ejecutar con: java -jar Compilador.jar)
