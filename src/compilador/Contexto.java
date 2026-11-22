package compilador;

/** Estado compartido de una compilacion: salida de texto y tabla de simbolos. */
public class Contexto {
    public static StringBuilder salida = new StringBuilder();
    public static TablaSimbolos tabla = new TablaSimbolos();

    public static void reset() {
        salida = new StringBuilder();
        tabla = new TablaSimbolos();
    }

    public static void println(String s) {
        salida.append(s).append(System.lineSeparator());
    }
}
