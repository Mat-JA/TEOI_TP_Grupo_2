# Compilador - Grupo 2 - Segunda entrega (analizador sintactico)

Teoria de la Computacion I - UNLu - 2026
Tema especial: **PRINCIPIO**

Analizador lexico (JFlex), sintactico (Java CUP) y controles semanticos basicos,
con un IDE en Swing para escribir o cargar codigo, compilarlo y ver el resultado.

## Ejecutar
Requiere Java 11 o superior.

    java -jar Compilador.jar

En la ventana: **Abrir archivo...** (por ejemplo `prueba.txt`) y luego **Compilar**.
La salida muestra tokens, reglas sintacticas, mensajes y errores. La pestana
*Tabla de simbolos* muestra la tabla; si no hay errores tambien se guarda en `ts.txt`.

## Reconstruir (requiere JDK 11+)

    ./build.sh        (Linux / Mac:  chmod +x build.sh  la primera vez)
    build.bat         (Windows)

Genera `Lexico.java` (JFlex) y `parser.java` / `sym.java` (CUP), compila y arma
`Compilador.jar` con el runtime de CUP incluido. Todo lo necesario esta en `lib/`.

## Contenido
| Archivo / carpeta | Descripcion |
|---|---|
| `Lexico.flex` | Especificacion JFlex (con `%cup`) |
| `Sintactico.cup` | Gramatica, acciones semanticas y mensajes de PRINCIPIO |
| `prueba.txt` | Prueba general: declaraciones, asignaciones, WHILE, IF, WRITE y PRINCIPIO |
| `ts.txt` | Tabla de simbolos generada al compilar `prueba.txt` |
| `pruebas_errores/` | 80 casos: `lex_*` (10 lexicos), `sin_*` (59 sintacticos), `sem_*` (11 semanticos). `INDICE.txt` lista el error de cada uno |
| `src/compilador/` | Codigo fuente. `Lexico.java`, `parser.java` y `sym.java` son generados |
| `lib/` | JFlex 1.8.2, Java CUP 11b y su runtime |
| `Compilador.jar` | Ejecutable |

## Lenguaje reconocido
- **Secciones:** `DECLARE.SECTION ... ENDDECLARE.SECTION` y `PROGRAM.SECTION ... ENDPROGRAM.SECTION`.
- **Declaracion:** `[a1, b1] := [FLOAT, INT]` (variables a la izquierda, tipos a la derecha).
- **Sentencias** (terminan en `;`): asignacion `a ::= expresion;` o `a ::= "texto";`,
  `IF (cond) THEN ... [ELSE ...] ENDIF`, `WHILE (cond) ... ENDWHILE`, `WRITE ...;`.
- **Condiciones:** comparaciones con un solo conector opcional: `(a < b AND c >= d)`.
- **WRITE:** cte string, cte numerica o variable numerica. Se acepta `WRITE` y `write`.
- **Constantes:** entero 0..32767; real (`99.99`, `99.`, `.9999`) dentro del rango de un float;
  string de hasta 30 caracteres entre comillas.
- **Comentarios:** `//* ... *//` con un solo nivel de anidamiento; no generan tokens.

## Tema especial: PRINCIPIO
`id ::= PRINCIPIO(pivot; [lista de constantes numericas]);` puede formar parte de una expresion,
por ejemplo `x ::= 4 + 3 + PRINCIPIO(4;[3,2,1,3,8]);`.
- Pivot menor a 1: **error semantico** (corta el analisis).
- Lista vacia: mensaje "La lista esta vacia"; el resultado es 0 y el analisis sigue.
- Pivot mayor al largo de la lista: mensaje "La lista no tiene suficientes elementos";
  el resultado es 0 y el analisis sigue.
- Caso normal: se informa la suma de las primeras posiciones.
- Si la lista tiene algun real el resultado es Float (una variable INT no puede recibirlo).

## Controles semanticos
- Tipos compatibles en asignaciones: una variable INT no recibe valores reales,
  una STRING solo recibe constantes string, una numerica no recibe strings.
- Una variable string no puede usarse en expresiones ni en WRITE.
- La cantidad de variables debe ser igual a la cantidad de tipos en cada declaracion.

## Errores
El analisis se corta en el primer error y lo informa con linea y columna:
`ERROR LEXICO`, `ERROR SINTACTICO` o `ERROR SEMANTICO`.

## Decisiones tomadas por el grupo (a tener en cuenta)
- La gramatica es la aprobada por la catedra con sus dos correcciones
  (declaracion con variables a la izquierda y PRINCIPIO dentro de `factor`).
  La unica ampliacion: la lista de PRINCIPIO admite tambien constantes reales.
- Una variable no declarada que se usa no genera error; solo se omite el control de tipos.
- Una variable declarada dos veces conserva el primer tipo.
- La division entre enteros da entero.
- Las palabras reservadas distinguen mayusculas (salvo `write`).
- Los strings con espacios figuran en la tabla como `_HOLA MUNDO`.
