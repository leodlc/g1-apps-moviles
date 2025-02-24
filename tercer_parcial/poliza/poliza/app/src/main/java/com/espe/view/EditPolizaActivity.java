package com.espe.view;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

import com.espe.controller.PolizaController;
import com.espe.databases.DataBaseHelper;
import com.espe.model.Poliza;
import com.espe.poliza.R;

public class EditPolizaActivity extends AppCompatActivity {
    private EditText etNombre, etValor, etAccidentes, etEdad;
    private Spinner spModelo;
    private Button btnActualizar;
    private DataBaseHelper dbHelper;
    private int polizaId;
    private String modeloSeleccionado;
    private static final String TAG = "EditPolizaActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_poliza);

        etNombre = findViewById(R.id.etNombre);
        etValor = findViewById(R.id.etValor);
        etAccidentes = findViewById(R.id.etAccidentes);
        spModelo = findViewById(R.id.spModelo);
        etEdad = findViewById(R.id.etEdad);
        btnActualizar = findViewById(R.id.btnActualizar);
        dbHelper = new DataBaseHelper(this);

        // Cargar modelos en el Spinner
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.modelos_array, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spModelo.setAdapter(adapter);

        // Obtener datos enviados por la actividad anterior
        Intent intent = getIntent();
        polizaId = intent.getIntExtra("id", -1);
        etNombre.setText(intent.getStringExtra("nombre"));
        etValor.setText(String.valueOf(intent.getDoubleExtra("valor", 0)));
        etAccidentes.setText(String.valueOf(intent.getIntExtra("accidentes", 0)));
        etEdad.setText(String.valueOf(intent.getIntExtra("edad", 0)));

        // Obtener el modelo desde el intent
        modeloSeleccionado = intent.getStringExtra("modelo");
        if (modeloSeleccionado == null || modeloSeleccionado.isEmpty()) {
            modeloSeleccionado = "A"; // Valor por defecto
        }

        int spinnerPosition = adapter.getPosition(modeloSeleccionado);
        if (spinnerPosition >= 0) {
            spModelo.setSelection(spinnerPosition);
        }

        Log.d(TAG, "Poliza cargada: ID=" + polizaId + ", Nombre=" + etNombre.getText().toString() + ", Modelo=" + modeloSeleccionado);

        btnActualizar.setOnClickListener(v -> actualizarPoliza());
    }

    private void actualizarPoliza() {
        if (polizaId == -1) {
            Log.e(TAG, "Error: ID inválido");
            Toast.makeText(this, "Error: ID inválido", Toast.LENGTH_SHORT).show();
            return;
        }

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
        int edad = Integer.parseInt(edadStr);
        String modelo = (spModelo.getSelectedItem() != null) ? spModelo.getSelectedItem().toString() : modeloSeleccionado;

        double nuevoCosto = PolizaController.calcularCosto(nombre, valor, accidentes, modelo.charAt(0), edad);
        Poliza poliza = new Poliza(polizaId, nombre, valor, accidentes, modelo, String.valueOf(edad), nuevoCosto);

        Log.d(TAG, "Intentando actualizar póliza: ID=" + polizaId + ", Nombre=" + nombre + ", Modelo=" + modelo + ", Costo=" + nuevoCosto);

        boolean actualizado = dbHelper.updatePoliza(polizaId, poliza);

        if (actualizado) {
            Log.d(TAG, "Póliza actualizada correctamente en la base de datos");
            Toast.makeText(this, "Póliza actualizada correctamente", Toast.LENGTH_SHORT).show();

            Intent resultIntent = new Intent();
            resultIntent.putExtra("actualizado", true);
            setResult(RESULT_OK, resultIntent);
            finish();
        } else {
            Log.e(TAG, "Error al actualizar la póliza");
            Toast.makeText(this, "Error al actualizar la póliza", Toast.LENGTH_SHORT).show();
        }
    }
}
