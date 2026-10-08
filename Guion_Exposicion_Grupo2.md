# Guion de exposición – Grupo 2 (PRINCIPIO)

**Zoom:** 18:15 · **Máximo:** 15 min · **Plan:** 12 min + 3 de margen · Presentan los 5 integrantes.
El reparto es una sugerencia: cambien los nombres como quieran, pero que **cada uno hable al menos una vez**.

| Slide | Quién | Tiempo |
|---|---|---|
| 1-2 Portada y objetivo | Integrante 1 | 2:00 |
| 3 Arquitectura | Integrante 2 | 1:30 |
| 4-5 Qué reconoce y validaciones | Integrante 3 | 3:30 |
| 6 PRINCIPIO | Integrante 4 | 2:00 |
| 7 Demo y cierre | Integrante 5 (maneja el IDE) | 3:00 |

## Antes de conectarse (10 min antes)
- IDE abierto (`java -jar Compilador.jar`) con `prueba.txt` ya cargado y la ventana lista para compartir.
- `pruebas_errores/error_entero_fuera_de_rango.txt` a mano, y `ts.txt` abierto en otra ventana.
- Un solo integrante comparte pantalla y pasa las slides. Quien hace la demo comparte después, o se pasan el control.
- Micrófonos silenciados salvo quien habla.

## Texto por slide

**1-2 · Integrante 1** (2:00)
- "Somos el Grupo 2, nuestro tema especial es PRINCIPIO. Esta es la primera entrega: el analizador léxico."
- "Usamos JFlex y armamos un IDE con Swing: se escribe o carga código, se compila y se ven los tokens o el error."
- "Entregamos `Lexico.flex`, `prueba.txt`, `ts.txt`, el código fuente en Git y el JAR."
- Pase: "Mi compañero explica cómo está armado."

**3 · Integrante 2** (1:30)
- Recorrer el flujo de izquierda a derecha: **Ventana → Analizador → Lexico → Salida**.
- "`Lexico` lo genera JFlex a partir de `Lexico.flex`. Cada vez devuelve un `Token` con nombre, lexema, línea y columna."
- "Si hay un error, se lanza `ErrorLexico`. Si no, se escribe `ts.txt`."
- No entrar en el código Java.

**4-5 · Integrante 3** (3:30)
- Slide 4: "Reconocemos cuatro grupos: reservadas, símbolos y operadores, ID y constantes. Los comentarios se ignoran."
- Remarcar dos cosas: **`:=` es la declaración de tipos y `::=` la asignación**, y **no existe `=` suelto**.
- Slide 5: decir los números sin leer toda la slide: **entero 0..32767, real que entre en un float, string hasta 30 caracteres, comentarios con un solo nivel de anidado**.
- "Ante el primer error el análisis se corta y se informa línea y columna."
- "En la tabla, los ID no guardan valor y las constantes sí, con nombre `_valor`."

**6 · Integrante 4** (2:00)
- "PRINCIPIO suma las primeras N constantes de una lista y asigna el resultado a un id."
- Mostrar el ejemplo: `PRINCIPIO(4;[10,20,30,40,5,4])` suma 100.
- "Para el léxico es una secuencia de tokens: `PRINCIPIO`, paréntesis, entero, punto y coma, corchetes y constantes."
- **Frase clave:** "Los mensajes 'La lista está vacía' y 'No tiene suficientes elementos' se validan en la segunda entrega, con el sintáctico."

**7 · Integrante 5** (3:00, demo)
1. Compartir el IDE con `prueba.txt` cargado → **Compilar**.
2. Mostrar los tokens y recorrer las líneas de `PRINCIPIO`.
3. Pestaña **Tabla de símbolos** y luego `ts.txt`.
4. Abrir `error_entero_fuera_de_rango.txt` → Compilar → mostrar el mensaje con línea y columna.
- Cierre: "Siguiente paso: analizador sintáctico con Java CUP." Agradecer.

## Para no irnos por las ramas
- **No** explicar cómo funciona JFlex por dentro ni leer el `.flex` línea por línea. Solo abrirlo si preguntan.
- **No** adelantar la parte sintáctica ni semántica (tipos, mensajes de PRINCIPIO).
- Si una pregunta se va de tema: "Eso lo vemos en la segunda entrega".
- Si se acaba el tiempo, recortar la explicación de las slides 3 y 5; **la demo no se recorta**.

## Preguntas probables
- **¿Por qué el entero llega hasta 32767?** Por los 16 bits con signo, como indica el ejemplo de clase.
- **¿Por qué se corta en el primer error?** Fue una decisión del grupo, como el ejemplo de clase.
- **¿Dónde se validan pivot y lista vacía?** En la 2ª entrega. Hoy solo se reconocen los tokens.
- **¿Por qué `_` en las constantes?** Para distinguirlas de las variables en la tabla, como en el ejemplo del enunciado.
- **¿Y si un string vale "55"?** Su entrada es `_55` con token CTE_STR, distinta de la del entero 55.
- **¿Las palabras reservadas distinguen mayúsculas?** Sí, como en el regex del grupo.
