package compilador;

/** Error del compilador (LEXICO, SINTACTICO o SEMANTICO). Corta el analisis. */
public class ErrorCompilador extends RuntimeException {
    public final String tipo;
    public final int linea;
    public final int columna;

    public ErrorCompilador(String tipo, String mensaje, int linea, int columna) {
        super(mensaje);
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
    }

    @Override
    public String toString() {
        if (linea <= 0) return "ERROR " + tipo + ": " + getMessage();
        return "ERROR " + tipo + " (linea " + linea + ", columna " + columna + "): " + getMessage();
    }
}
