#!/bin/sh
# Genera lexer (JFlex) y parser (CUP), compila y arma el JAR ejecutable.
# Requisitos: JDK 11 o superior en el PATH.
set -e
cd "$(dirname "$0")"
java -jar lib/jflex-full-1.8.2.jar -d src/compilador Lexico.flex
java -jar lib/java-cup-11b.jar -destdir src/compilador -package compilador -parser parser -symbols sym Sintactico.cup
rm -rf bin && mkdir bin
javac -encoding UTF-8 --release 11 -cp lib/java-cup-11b-runtime.jar -d bin src/compilador/*.java
# El runtime de CUP va dentro del JAR para que sea autocontenido
(cd bin && jar xf ../lib/java-cup-11b-runtime.jar && rm -rf META-INF)
jar cfe Compilador.jar compilador.Main -C bin .
echo "Listo: Compilador.jar  (ejecutar con: java -jar Compilador.jar)"
