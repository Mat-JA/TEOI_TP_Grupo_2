package compilador;

/** Error detectado por el analizador lexico (corta el analisis). */
public class ErrorLexico extends RuntimeException {
    public final int linea;
    public final int columna;

    public ErrorLexico(String mensaje, int linea, int columna) {
        super(mensaje);
        this.linea = linea;
        this.columna = columna;
    }

    @Override
    public String toString() {
        return "ERROR LEXICO (linea " + linea + ", columna " + columna + "): " + getMessage();
    }
}
