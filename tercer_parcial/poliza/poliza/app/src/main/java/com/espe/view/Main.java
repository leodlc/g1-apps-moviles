package com.espe.view;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.ArrayAdapter;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import android.widget.ListView;
import android.widget.Toast;

import com.espe.controller.PolizaController;
import com.espe.databases.DataBaseHelper;
import com.espe.model.Poliza;
import com.espe.poliza.R;

import java.util.List;

public class Main extends AppCompatActivity {
    private static final int REQUEST_EDIT_POLIZA = 1;

    private EditText etNombre, etValor, etAccidentes, etEdad;
    private Spinner spModelo;
    private TextView tvResultado;
    private DataBaseHelper dbHelper;
    private ListView listView;
    private polizaAdapter adapter;
    private List<Poliza> polizaList;

    private Button btnCalcular;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Inicialización de vistas
        etNombre = findViewById(R.id.etNombre);
        etValor = findViewById(R.id.etValor);
        etAccidentes = findViewById(R.id.etAccidentes);
        etEdad = findViewById(R.id.etEdad);
        tvResultado = findViewById(R.id.tvResultado);
        btnCalcular = findViewById(R.id.btnCalcular);
        spModelo = findViewById(R.id.spModelo);
        listView = findViewById(R.id.listViewPolizas);

        // Configurar el Spinner
        if (spModelo != null) {
            ArrayAdapter<CharSequence> spinnerAdapter = ArrayAdapter.createFromResource(
                    this,
                    R.array.modelos_array, // Asegúrate de que está en strings.xml
                    android.R.layout.simple_spinner_item
            );
            spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            spModelo.setAdapter(spinnerAdapter);
        } else {
            Log.e("MainActivity", "El Spinner spModelo es null. Revisa tu layout activity_main.xml");
        }

        // Inicialización de la base de datos
        dbHelper = new DataBaseHelper(this);
        polizaList = dbHelper.getAllPolizas();
        adapter = new polizaAdapter(this, polizaList);
        listView.setAdapter(adapter);

        // Configurar el botón Calcular
        btnCalcular.setOnClickListener(v -> calcularYGuardarPoliza());

        // Configuración del botón de búsqueda
        EditText etBuscarNombre = findViewById(R.id.etBuscarNombre);
        Button btnBuscar = findViewById(R.id.btnBuscar);
        btnBuscar.setOnClickListener(v -> {
            String nombreBuscado = etBuscarNombre.getText().toString().trim();
            if (nombreBuscado.isEmpty()) {
                Toast.makeText(Main.this, "Ingrese un nombre para buscar", Toast.LENGTH_SHORT).show();
                return;
            }

            Poliza polizaEncontrada = dbHelper.getPolizaByNombre(nombreBuscado);
            if (polizaEncontrada != null) {
                mostrarDialogoPoliza(polizaEncontrada);
            } else {
                Toast.makeText(Main.this, "No se encontró ninguna póliza con ese nombre", Toast.LENGTH_SHORT).show();
            }
        });

        Log.d("MainActivity", "Aplicación iniciada correctamente.");
    }


    // Método para mostrar la información en un AlertDialog
    private void mostrarDialogoPoliza(Poliza poliza) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Detalles de la Póliza")
                .setMessage("Nombre: " + poliza.getNombre() + "\n"
                        + "Valor: $" + poliza.getValor() + "\n"
                        + "Accidentes: " + poliza.getAccidente() + "\n"
                        + "Modelo: " + poliza.getModelo() + "\n"
                        + "Edad: " + poliza.getEdad() + "\n"
                        + "Costo: $" + poliza.getCostoPoliza())
                .setPositiveButton("OK", null)
                .show();
    }



    private void calcularYGuardarPoliza() {
        String nombre = etNombre.getText().toString().trim();
        String valorStr = etValor.getText().toString().trim();
        String accidentesStr = etAccidentes.getText().toString().trim();
        String edadStr = etEdad.getText().toString().trim();

        if (nombre.isEmpty() || valorStr.isEmpty() || accidentesStr.isEmpty() || edadStr.isEmpty()) {
            Toast.makeText(this, "Por favor, completa todos los campos", Toast.LENGTH_SHORT).show();
            return;
        }

        double valor = Double.parseDouble(valorStr);
        int accidentes = Integer.parseInt(accidentesStr);
        char modelo = spModelo.getSelectedItem().toString().charAt(0);
        int edad = Integer.parseInt(edadStr);

        double costoPoliza = PolizaController.calcularCosto(nombre, valor, accidentes, modelo, edad);
        tvResultado.setText("Costo de la Póliza: $" + costoPoliza);

        boolean guardado = dbHelper.insertarPoliza(nombre, valor, accidentes, modelo, edad, costoPoliza);

        if (guardado) {
            Toast.makeText(this, "Póliza guardada correctamente", Toast.LENGTH_SHORT).show();
            limpiarCampos();
            cargarLista();
        } else {
            Toast.makeText(this, "Error al guardar la póliza", Toast.LENGTH_SHORT).show();
        }
    }

    private void limpiarCampos() {
        etNombre.setText("");
        etValor.setText("");
        etAccidentes.setText("");
        etEdad.setText("");
        tvResultado.setText("Costo de la Póliza:");
        spModelo.setSelection(0);
    }

    private void cargarLista() {
        Log.d("MainActivity", "Cargando lista de pólizas desde la BD...");

        // Obtener las pólizas actualizadas desde la base de datos
        List<Poliza> nuevasPolizas = dbHelper.getAllPolizas();

        if (adapter != null) {
            Log.d("MainActivity", "Actualizando lista en adapter...");
            polizaList.clear();  // Limpiar la lista actual
            polizaList.addAll(nuevasPolizas);  // Agregar los nuevos datos
            adapter.notifyDataSetChanged();  // Notificar cambios a la UI
        } else {
            Log.d("MainActivity", "Creando nuevo adaptador...");
            polizaList = nuevasPolizas;
            adapter = new polizaAdapter(this, polizaList);
            listView.setAdapter(adapter);
        }

        Log.d("MainActivity", "Lista actualizada con " + nuevasPolizas.size() + " elementos.");
    }




    private void editarPoliza(Poliza poliza) {
        Intent intent = new Intent(this, EditPolizaActivity.class);
        intent.putExtra("id", poliza.getId());
        intent.putExtra("nombre", poliza.getNombre());
        intent.putExtra("valor", poliza.getValor());
        intent.putExtra("accidentes", poliza.getAccidente());
        intent.putExtra("modelo", poliza.getModelo());
        intent.putExtra("edad", Integer.parseInt(poliza.getEdad()));
        startActivityForResult(intent, REQUEST_EDIT_POLIZA);
    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.d("MainActivity", "Volviendo a la pantalla principal, recargando lista...");
        cargarLista();  // Se asegura de que siempre se actualiza la lista al volver a la pantalla
    }







}
