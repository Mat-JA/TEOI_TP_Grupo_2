/* ===================================================================
   Lexico.flex - Entrega 2 (con %cup) - Teoria de la Computacion I - UNLu
   Grupo 2 - Tema especial: PRINCIPIO
   (Archivo en ASCII a proposito: JFlex lo lee con la codificacion
   por defecto del sistema, por eso no hay tildes ni enes aca.)
   =================================================================== */
package compilador;

import java_cup.runtime.*;

%%

%public
%class Lexico
%cup
%unicode
%line
%column

%state COMENT

%{
    
    /* Control de comentarios (se admite un solo nivel de anidamiento) */
    private int nivelComentario = 0;
    private int lineaInicioComentario = 0;

    /* Muestra el token reconocido y lo entrega al parser (linea y columna base 1) */
    private Symbol tok(int id, String nombre) {
        Contexto.println(String.format("TOKEN  %-20s Lexema: %-22s (linea %d, columna %d)",
                nombre, yytext(), yyline + 1, yycolumn + 1));
        return new Symbol(id, yyline + 1, yycolumn + 1, yytext());
    }

    private ErrorCompilador error(String mensaje) {
        return new ErrorCompilador("LEXICO", mensaje, yyline + 1, yycolumn + 1);
    }
%}

/* ---------------------------- MACROS ---------------------------- */

LETRA            = [a-zA-Z]
DIGITO           = [0-9]
ESPACIO_BLANCO   = [ \t\f\r\n]

ID               = {LETRA}({LETRA}|{DIGITO})*

CTE_E            = {DIGITO}+
CTE_F            = {DIGITO}+ "." {DIGITO}+ | {DIGITO}+ "." | "." {DIGITO}+

/* Caracteres permitidos dentro de un string (regex del grupo + @ y %):
   espacio y tab, signos (, : ;), operadores (+ - / * > < ! =), letras,
   digitos, . ! u00A1 (signo de exclamacion invertido), n y N con tilde,
   @ y %. No incluye saltos de linea ni comillas. */
CHAR_STRING      = [a-zA-Z0-9 \t,:;+\-/*><!=.@%\u00A1\u00F1\u00D1]
CTE_STR          = \" {CHAR_STRING}* \"

%%

<YYINITIAL> {

    /* ------------------ Palabras reservadas ------------------ */
    "DECLARE.SECTION"        { return tok(sym.DECLARE_SECTION, "DECLARE_SECTION"); }
    "ENDDECLARE.SECTION"     { return tok(sym.ENDDECLARE_SECTION, "ENDDECLARE_SECTION"); }
    "PROGRAM.SECTION"        { return tok(sym.PROGRAM_SECTION, "PROGRAM_SECTION"); }
    "ENDPROGRAM.SECTION"     { return tok(sym.ENDPROGRAM_SECTION, "ENDPROGRAM_SECTION"); }
    "IF"                     { return tok(sym.IF, "IF"); }
    "THEN"                   { return tok(sym.THEN, "THEN"); }
    "ELSE"                   { return tok(sym.ELSE, "ELSE"); }
    "ENDIF"                  { return tok(sym.ENDIF, "ENDIF"); }
    "WHILE"                  { return tok(sym.WHILE, "WHILE"); }
    "ENDWHILE"               { return tok(sym.ENDWHILE, "ENDWHILE"); }
    /* El enunciado escribe WRITE y tambien write (seccion SALIDA): se aceptan ambas formas */
    "WRITE" | "write"        { return tok(sym.WRITE, "WRITE"); }
    "FLOAT"                  { return tok(sym.FLOAT, "FLOAT"); }
    "INT"                    { return tok(sym.INTEGER, "INTEGER"); }
    "STRING"                 { return tok(sym.STRING, "STRING"); }
    "AND"                    { return tok(sym.AND, "AND"); }
    "OR"                     { return tok(sym.OR, "OR"); }
    "PRINCIPIO"              { return tok(sym.PRINCIPIO, "PRINCIPIO"); }

    /* ------------------ Signos y simbolos -------------------- */
    "::="                    { return tok(sym.ASIGNACION, "ASIGNACION"); }
    ":="                     { return tok(sym.ASIG_DECL, "ASIG_DECL"); }
    ","                      { return tok(sym.COMA, "COMA"); }
    "."                      { return tok(sym.PUNTO, "PUNTO"); }
    ";"                      { return tok(sym.PUNTO_Y_COMA, "PUNTO_Y_COMA"); }
    "("                      { return tok(sym.PAR_A, "PAR_A"); }
    ")"                      { return tok(sym.PAR_C, "PAR_C"); }
    "["                      { return tok(sym.COR_A, "COR_A"); }
    "]"                      { return tok(sym.COR_C, "COR_C"); }
    "{"                      { return tok(sym.LLAV_A, "LLAV_A"); }
    "}"                      { return tok(sym.LLAV_C, "LLAV_C"); }

    /* ------------------ Operadores --------------------------- */
    ">="                     { return tok(sym.OP_MAYOR_IGUAL, "OP_MAYOR_IGUAL"); }
    "<="                     { return tok(sym.OP_MENOR_IGUAL, "OP_MENOR_IGUAL"); }
    ">"                      { return tok(sym.OP_MAYOR, "OP_MAYOR"); }
    "<"                      { return tok(sym.OP_MENOR, "OP_MENOR"); }
    "=="                     { return tok(sym.OP_IGUAL, "OP_IGUAL"); }
    "!="                     { return tok(sym.OP_DISTINTO, "OP_DISTINTO"); }
    "+"                      { return tok(sym.OP_SUMA, "OP_SUMA"); }
    "-"                      { return tok(sym.OP_RESTA, "OP_RESTA"); }
    "*"                      { return tok(sym.OP_MULT, "OP_MULT"); }
    "/"                      { return tok(sym.OP_DIV, "OP_DIV"); }

    /* ------------------ Identificadores ---------------------- */
    /* Va despues de las reservadas: ante igual longitud gana la
       primera regla, y "IF" debe ser palabra reservada y no ID. */
    {ID}                     { Contexto.tabla.agregarID(yytext());
                               return tok(sym.ID, "ID"); }

    /* ------------------ Constantes --------------------------- */
    {CTE_F}                  { float f = Float.parseFloat(yytext());
                               if (Float.isInfinite(f))
                                   throw error("Constante real fuera de rango (32 bits): " + yytext());
                               Contexto.tabla.agregarCteF(yytext());
                               return tok(sym.CTE_F, "CTE_F"); }

    {CTE_E}                  { if (new java.math.BigInteger(yytext())
                                       .compareTo(java.math.BigInteger.valueOf(32767)) > 0)
                                   throw error("Constante entera fuera de rango (0..32767): " + yytext());
                               Contexto.tabla.agregarCteE(yytext());
                               return tok(sym.CTE_E, "CTE_E"); }

    {CTE_STR}                { String valor = yytext().substring(1, yytext().length() - 1);
                               if (valor.length() > 30)
                                   throw error("String de mas de 30 caracteres (" + valor.length() + "): " + yytext());
                               Contexto.tabla.agregarCteStr(valor);
                               return tok(sym.CTE_STR, "CTE_STR"); }

    /* ------------------ Comentarios -------------------------- */
    "//*"                    { nivelComentario = 1;
                               lineaInicioComentario = yyline + 1;
                               yybegin(COMENT); }

    "*//"                    { throw error("Cierre de comentario '*//' sin apertura"); }

    /* ------------------ Ignorados ---------------------------- */
    {ESPACIO_BLANCO}+        { /* no genera token ni salida */ }

    /* ------------------ Errores ------------------------------ */
    \"                       { throw error("String mal formado (sin cerrar, con caracter no permitido o con salto de linea)"); }

    <<EOF>>                  { return new Symbol(sym.EOF); }
}

<COMENT> {
    "//*"                    { if (nivelComentario == 1) {
                                   nivelComentario = 2;
                               } else {
                                   throw error("Los comentarios solo pueden anidarse un nivel");
                               } }
    "*//"                    { nivelComentario--;
                               if (nivelComentario == 0) yybegin(YYINITIAL); }
    [^]                      { /* el contenido del comentario se ignora */ }
    <<EOF>>                  { throw new ErrorCompilador("LEXICO", "Comentario sin cerrar (abierto en la linea "
                                   + lineaInicioComentario + ")", yyline + 1, yycolumn + 1); }
}

[^]                          { throw error("Caracter no permitido: <" + yytext() + ">"); }
