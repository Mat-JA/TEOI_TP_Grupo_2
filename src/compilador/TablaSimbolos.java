package compilador;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Tabla de simbolos de la 1ra entrega: NOMBRE, TOKEN, TIPO, VALOR, LONG.
 * - Variables (ID): no guardan valor. TIPO queda vacio en esta entrega.
 * - Constantes: nombre con prefijo "_"; guardan su valor.
 *   CTE_STR guarda el valor sin comillas y su longitud.
 */
public class TablaSimbolos {

    public static class Entrada {
        public final String nombre, token, tipo, valor, longitud;

        Entrada(String nombre, String token, String tipo, String valor, String longitud) {
            this.nombre = nombre;
            this.token = token;
            this.tipo = tipo;
            this.valor = valor;
            this.longitud = longitud;
        }
    }

    private static final String VACIO = "-";

    /* La clave incluye el token: el string "55" y el entero 55 llevan el
       mismo nombre "_55" pero son entradas distintas. */
    private final Map<String, Entrada> entradas = new LinkedHashMap<>();

    private void agregar(Entrada e) {
        entradas.putIfAbsent(e.token + "|" + e.nombre, e);
    }

    public void agregarID(String nombre) {
        agregar(new Entrada(nombre, "ID", VACIO, VACIO, VACIO));
    }

    public void agregarCteE(String lexema) {
        agregar(new Entrada("_" + lexema, "CTE_E", VACIO, lexema, VACIO));
    }

    public void agregarCteF(String lexema) {
        agregar(new Entrada("_" + lexema, "CTE_F", VACIO, lexema, VACIO));
    }

    public void agregarCteStr(String valorSinComillas) {
        agregar(new Entrada("_" + valorSinComillas, "CTE_STR", VACIO,
                valorSinComillas, String.valueOf(valorSinComillas.length())));
    }

    public List<Entrada> getEntradas() {
        return new ArrayList<>(entradas.values());
    }

    /** Tabla formateada en columnas alineadas. */
    public String formatear() {
        int wNombre = 6, wToken = 5, wTipo = 4, wValor = 5, wLong = 4;
        for (Entrada e : entradas.values()) {
            wNombre = Math.max(wNombre, e.nombre.length());
            wToken = Math.max(wToken, e.token.length());
            wValor = Math.max(wValor, e.valor.length());
        }
        String fmt = "%-" + wNombre + "s | %-" + wToken + "s | %-" + wTipo + "s | %-"
                + wValor + "s | %-" + wLong + "s%n";
        StringBuilder sb = new StringBuilder();
        sb.append(String.format(fmt, "NOMBRE", "TOKEN", "TIPO", "VALOR", "LONG"));
        int total = wNombre + wToken + wTipo + wValor + wLong + 12;
        for (int i = 0; i < total; i++) sb.append('-');
        sb.append(System.lineSeparator());
        for (Entrada e : entradas.values()) {
            sb.append(String.format(fmt, e.nombre, e.token, e.tipo, e.valor, e.longitud));
        }
        return sb.toString();
    }

    /** Guarda la tabla en un archivo de texto (UTF-8), por ejemplo ts.txt. */
    public void guardar(String ruta) throws IOException {
        try (PrintWriter pw = new PrintWriter(
                Files.newBufferedWriter(Paths.get(ruta), StandardCharsets.UTF_8))) {
            pw.print(formatear());
        }
    }
}
