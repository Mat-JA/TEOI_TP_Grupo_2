package compilador;

import java.io.StringReader;

/** Ejecuta el analisis lexico + sintactico + semantico sobre un texto. */
public class Analizador {

    public String salida;
    public TablaSimbolos tabla;
    public boolean hayError = false;

    public Analizador(String codigo) {
        Contexto.reset();
        String nl = System.lineSeparator();
        try {
            parser p = new parser(new Lexico(new StringReader(codigo)));
            p.parse();
            Contexto.println(nl + "Compilacion finalizada sin errores.");
        } catch (ErrorCompilador e) {
            hayError = true;
            Contexto.println(nl + e);
            Contexto.println("Analisis detenido en el primer error.");
        } catch (Exception e) {
            hayError = true;
            Contexto.println(nl + "Error inesperado: " + e);
        }
        salida = Contexto.salida.toString();
        tabla = Contexto.tabla;
    }
}
