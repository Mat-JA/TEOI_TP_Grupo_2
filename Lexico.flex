/* ===================================================================
   Lexico.flex - Primera entrega - Teoria de la Computacion I - UNLu
   Grupo 2 - Tema especial: PRINCIPIO
   (Archivo en ASCII a proposito: JFlex lo lee con la codificacion
   por defecto del sistema, por eso no hay tildes ni enes aca.)
   =================================================================== */
package compilador;

%%

%public
%class Lexico
%type Token
%function next_token
%unicode
%line
%column

%state COMENT

%{
    /* Tabla de simbolos que se va llenando durante el analisis */
    public TablaSimbolos tabla = new TablaSimbolos();

    /* Control de comentarios (se admite un solo nivel de anidamiento) */
    private int nivelComentario = 0;
    private int lineaInicioComentario = 0;

    private Token tok(String nombre) {
        return new Token(nombre, yytext(), yyline + 1, yycolumn + 1);
    }

    private ErrorLexico error(String mensaje) {
        return new ErrorLexico(mensaje, yyline + 1, yycolumn + 1);
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
    "DECLARE.SECTION"        { return tok("DECLARE_SECTION"); }
    "ENDDECLARE.SECTION"     { return tok("ENDDECLARE_SECTION"); }
    "PROGRAM.SECTION"        { return tok("PROGRAM_SECTION"); }
    "ENDPROGRAM.SECTION"     { return tok("ENDPROGRAM_SECTION"); }
    "IF"                     { return tok("IF"); }
    "THEN"                   { return tok("THEN"); }
    "ELSE"                   { return tok("ELSE"); }
    "ENDIF"                  { return tok("ENDIF"); }
    "WHILE"                  { return tok("WHILE"); }
    "ENDWHILE"               { return tok("ENDWHILE"); }
    "WRITE"                  { return tok("WRITE"); }
    "FLOAT"                  { return tok("FLOAT"); }
    "INT"                    { return tok("INTEGER"); }
    "STRING"                 { return tok("STRING"); }
    "AND"                    { return tok("AND"); }
    "OR"                     { return tok("OR"); }
    "PRINCIPIO"              { return tok("PRINCIPIO"); }

    /* ------------------ Signos y simbolos -------------------- */
    "::="                    { return tok("ASIGNACION"); }
    ":="                     { return tok("ASIG_DECL"); }
    ","                      { return tok("COMA"); }
    "."                      { return tok("PUNTO"); }
    ";"                      { return tok("PUNTO_Y_COMA"); }
    "("                      { return tok("PAR_A"); }
    ")"                      { return tok("PAR_C"); }
    "["                      { return tok("COR_A"); }
    "]"                      { return tok("COR_C"); }
    "{"                      { return tok("LLAV_A"); }
    "}"                      { return tok("LLAV_C"); }

    /* ------------------ Operadores --------------------------- */
    ">="                     { return tok("OP_MAYOR_IGUAL"); }
    "<="                     { return tok("OP_MENOR_IGUAL"); }
    ">"                      { return tok("OP_MAYOR"); }
    "<"                      { return tok("OP_MENOR"); }
    "=="                     { return tok("OP_IGUAL"); }
    "!="                     { return tok("OP_DISTINTO"); }
    "+"                      { return tok("OP_SUMA"); }
    "-"                      { return tok("OP_RESTA"); }
    "*"                      { return tok("OP_MULT"); }
    "/"                      { return tok("OP_DIV"); }

    /* ------------------ Identificadores ---------------------- */
    /* Va despues de las reservadas: ante igual longitud gana la
       primera regla, y "IF" debe ser palabra reservada y no ID. */
    {ID}                     { tabla.agregarID(yytext());
                               return tok("ID"); }

    /* ------------------ Constantes --------------------------- */
    {CTE_F}                  { float f = Float.parseFloat(yytext());
                               if (Float.isInfinite(f))
                                   throw error("Constante real fuera de rango (32 bits): " + yytext());
                               tabla.agregarCteF(yytext());
                               return tok("CTE_F"); }

    {CTE_E}                  { if (new java.math.BigInteger(yytext())
                                       .compareTo(java.math.BigInteger.valueOf(32767)) > 0)
                                   throw error("Constante entera fuera de rango (0..32767): " + yytext());
                               tabla.agregarCteE(yytext());
                               return tok("CTE_E"); }

    {CTE_STR}                { String valor = yytext().substring(1, yytext().length() - 1);
                               if (valor.length() > 30)
                                   throw error("String de mas de 30 caracteres (" + valor.length() + "): " + yytext());
                               tabla.agregarCteStr(valor);
                               return tok("CTE_STR"); }

    /* ------------------ Comentarios -------------------------- */
    "//*"                    { nivelComentario = 1;
                               lineaInicioComentario = yyline + 1;
                               yybegin(COMENT); }

    "*//"                    { throw error("Cierre de comentario '*//' sin apertura"); }

    /* ------------------ Ignorados ---------------------------- */
    {ESPACIO_BLANCO}+        { /* no genera token ni salida */ }

    /* ------------------ Errores ------------------------------ */
    \"                       { throw error("String mal formado (sin cerrar, con caracter no permitido o con salto de linea)"); }

    <<EOF>>                  { return null; }
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
    <<EOF>>                  { throw new ErrorLexico("Comentario sin cerrar (abierto en la linea "
                                   + lineaInicioComentario + ")", yyline + 1, yycolumn + 1); }
}

[^]                          { throw error("Caracter no permitido: <" + yytext() + ">"); }
