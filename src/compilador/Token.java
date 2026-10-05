package compilador;

/** Componente lexico reconocido por el analizador. */
public class Token {
    public final String nombre;
    public final String lexema;
    public final int linea;
    public final int columna;

    public Token(String nombre, String lexema, int linea, int columna) {
        this.nombre = nombre;
        this.lexema = lexema;
        this.linea = linea;
        this.columna = columna;
    }

    @Override
    public String toString() {
        return String.format("Token: %-20s Lexema: %-22s (linea %d, columna %d)",
                nombre, lexema, linea, columna);
    }
}
