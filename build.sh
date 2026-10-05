#!/bin/sh
# Genera el lexer con JFlex, compila con javac y arma el JAR ejecutable.
# Requisitos: JDK 11 o superior en el PATH.
set -e
cd "$(dirname "$0")"
java -jar lib/jflex-full-1.8.2.jar -d src/compilador Lexico.flex
rm -rf bin && mkdir bin
javac -encoding UTF-8 --release 11 -d bin src/compilador/*.java
jar cfe Compilador.jar compilador.Main -C bin .
echo "Listo: Compilador.jar  (ejecutar con: java -jar Compilador.jar)"
