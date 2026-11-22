@echo off
rem Genera lexer (JFlex) y parser (CUP), compila y arma el JAR ejecutable.
rem Requisitos: JDK 11 o superior en el PATH.
cd /d "%~dp0"
java -jar lib\jflex-full-1.8.2.jar -d src\compilador Lexico.flex || exit /b 1
java -jar lib\java-cup-11b.jar -destdir src\compilador -package compilador -parser parser -symbols sym Sintactico.cup || exit /b 1
if exist bin rmdir /s /q bin
mkdir bin
javac -encoding UTF-8 --release 11 -cp lib\java-cup-11b-runtime.jar -d bin src\compilador\*.java || exit /b 1
cd bin
jar xf ..\lib\java-cup-11b-runtime.jar
rmdir /s /q META-INF
cd ..
jar cfe Compilador.jar compilador.Main -C bin . || exit /b 1
echo Listo: Compilador.jar  (ejecutar con: java -jar Compilador.jar)
