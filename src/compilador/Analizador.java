package compilador;

import java.io.IOException;
import java.io.StringReader;

/** Ejecuta el analisis lexico sobre un texto y arma la salida para mostrar. */
public class Analizador {

    public final StringBuilder salida = new StringBuilder();
    public TablaSimbolos tabla;
    public boolean hayError = false;

    public Analizador(String codigo) {
        Lexico lexer = new Lexico(new StringReader(codigo));
        tabla = lexer.tabla;
        String nl = System.lineSeparator();
        try {
            Token t;
            while ((t = lexer.next_token()) != null) {
                salida.append(t).append(nl);
            }
            salida.append(nl).append("Analisis lexico finalizado sin errores.").append(nl);
        } catch (ErrorLexico e) {
            hayError = true;
            salida.append(nl).append(e).append(nl)
                  .append("Analisis detenido en el primer error.").append(nl);
        } catch (IOException e) {
            hayError = true;
            salida.append("Error de lectura: ").append(e.getMessage()).append(nl);
        }
    }
}
