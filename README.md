# Compilador - Grupo 2 - Primera entrega (analizador lexico)

Teoria de la Computacion I - UNLu - 2026. Tema especial: PRINCIPIO.

## Miembros
- Maria Nazarena Gonzalez - 190217
- Valentino Rigacci - 190150

## Ejecutar
    java -jar Compilador.jar

## Reconstruir (requiere JDK 11+)
    ./build.sh        (Linux/Mac)
    build.bat         (Windows)

## Contenido
- `Lexico.flex`        especificacion JFlex
- `prueba.txt`         prueba general + tema PRINCIPIO
- `ts.txt`             tabla de simbolos generada con prueba.txt
- `pruebas_errores/`   un archivo por cada error lexico detectado
- `src/compilador/`    codigo fuente (Lexico.java es generado por JFlex)
- `lib/`               JFlex 1.8.2
- `Compilador.jar`     ejecutable

## Decisiones
- Entero (CTE_E): 0..32767. Real (CTE_F): debe entrar en un float de Java.
- String (CTE_STR): hasta 30 caracteres; valor sin comillas en la tabla.
- Comentarios //* ... *// con un solo nivel de anidamiento.
- El analisis se detiene en el primer error lexico.
- Palabras reservadas sensibles a mayusculas (WRITE, IF, ...).
