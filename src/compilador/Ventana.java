package compilador;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;

/** IDE minimo del compilador: editor, carga de archivos y analisis lexico. */
public class Ventana extends JFrame {

    private final JTextArea editor = new JTextArea();
    private final JTextArea salida = new JTextArea();
    private final JTextArea tablaSimbolos = new JTextArea();
    private final JLabel estado = new JLabel(" Linea 1, Columna 1");
    private File archivoActual = null;

    public Ventana() {
        super("IDE Compilador - Grupo 2 - Analizador Lexico");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(950, 700);
        setLocationRelativeTo(null);

        Font mono = new Font(Font.MONOSPACED, Font.PLAIN, 13);
        editor.setFont(mono);
        editor.setTabSize(4);
        salida.setFont(mono);
        salida.setEditable(false);
        tablaSimbolos.setFont(mono);
        tablaSimbolos.setEditable(false);

        /* Botonera */
        JButton btnNuevo = new JButton("Nuevo");
        JButton btnAbrir = new JButton("Abrir archivo...");
        JButton btnGuardar = new JButton("Guardar");
        JButton btnCompilar = new JButton("Compilar (analisis lexico)");
        btnNuevo.addActionListener(e -> nuevo());
        btnAbrir.addActionListener(e -> abrir());
        btnGuardar.addActionListener(e -> guardar());
        btnCompilar.addActionListener(e -> compilar());

        JPanel barra = new JPanel(new FlowLayout(FlowLayout.LEFT));
        barra.add(btnNuevo);
        barra.add(btnAbrir);
        barra.add(btnGuardar);
        barra.add(btnCompilar);

        /* Panel inferior con pestanas */
        JTabbedPane pestanas = new JTabbedPane();
        pestanas.addTab("Salida (tokens / errores)", new JScrollPane(salida));
        pestanas.addTab("Tabla de simbolos", new JScrollPane(tablaSimbolos));

        JSplitPane division = new JSplitPane(JSplitPane.VERTICAL_SPLIT,
                new JScrollPane(editor), pestanas);
        division.setResizeWeight(0.55);
        pestanas.setPreferredSize(new Dimension(900, 260));

        editor.addCaretListener(e -> actualizarPosicion());

        add(barra, BorderLayout.NORTH);
        add(division, BorderLayout.CENTER);
        add(estado, BorderLayout.SOUTH);
    }

    private void actualizarPosicion() {
        try {
            int pos = editor.getCaretPosition();
            int linea = editor.getLineOfOffset(pos);
            int col = pos - editor.getLineStartOffset(linea);
            estado.setText(" Linea " + (linea + 1) + ", Columna " + (col + 1)
                    + (archivoActual != null ? "   |   " + archivoActual.getName() : ""));
        } catch (Exception ignorada) { }
    }

    private void nuevo() {
        editor.setText("");
        salida.setText("");
        tablaSimbolos.setText("");
        archivoActual = null;
        actualizarPosicion();
    }

    private void abrir() {
        JFileChooser fc = new JFileChooser(new File("."));
        if (fc.showOpenDialog(this) != JFileChooser.APPROVE_OPTION) return;
        File f = fc.getSelectedFile();
        try {
            editor.setText(new String(Files.readAllBytes(f.toPath()), StandardCharsets.UTF_8));
            editor.setCaretPosition(0);
            archivoActual = f;
            actualizarPosicion();
        } catch (IOException ex) {
            JOptionPane.showMessageDialog(this, "No se pudo leer el archivo:\n" + ex.getMessage(),
                    "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void guardar() {
        File destino = archivoActual;
        if (destino == null) {
            JFileChooser fc = new JFileChooser(new File("."));
            if (fc.showSaveDialog(this) != JFileChooser.APPROVE_OPTION) return;
            destino = fc.getSelectedFile();
        }
        try {
            Files.write(destino.toPath(), editor.getText().getBytes(StandardCharsets.UTF_8));
            archivoActual = destino;
            actualizarPosicion();
        } catch (IOException ex) {
            JOptionPane.showMessageDialog(this, "No se pudo guardar el archivo:\n" + ex.getMessage(),
                    "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void compilar() {
        Analizador a = new Analizador(editor.getText());
        StringBuilder out = new StringBuilder(a.salida);
        if (!a.hayError) {
            try {
                a.tabla.guardar("ts.txt");
                out.append("Tabla de simbolos guardada en ts.txt").append(System.lineSeparator());
            } catch (IOException ex) {
                out.append("No se pudo guardar ts.txt: ").append(ex.getMessage())
                   .append(System.lineSeparator());
            }
        }
        salida.setText(out.toString());
        salida.setCaretPosition(0);
        tablaSimbolos.setText(a.tabla.formatear());
        tablaSimbolos.setCaretPosition(0);
    }
}
