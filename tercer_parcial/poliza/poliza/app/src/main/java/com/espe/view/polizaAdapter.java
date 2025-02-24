package com.espe.view;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import com.espe.databases.DataBaseHelper;
import com.espe.model.Poliza;
import com.espe.poliza.R;

import java.util.List;

public class polizaAdapter extends BaseAdapter {
    private Context context;
    private List<Poliza> polizas;
    private DataBaseHelper dbHelper;

    public polizaAdapter(Context context, List<Poliza> polizas) {
        this.context = context;
        this.polizas = polizas;
        this.dbHelper = new DataBaseHelper(context);
    }

    @Override
    public int getCount() {
        return polizas.size();
    }

    @Override
    public Object getItem(int position) {
        return polizas.get(position);
    }

    @Override
    public long getItemId(int position) {
        return polizas.get(position).getId();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.list_item, parent, false);
        }

        TextView tvNombre = convertView.findViewById(R.id.tvNombre);
        TextView tvCosto = convertView.findViewById(R.id.tvCosto);
        ImageButton btnEditar = convertView.findViewById(R.id.btnEditar);
        ImageButton btnEliminar = convertView.findViewById(R.id.btnEliminar);

        Poliza poliza = polizas.get(position);
        tvNombre.setText(poliza.getNombre());
        tvCosto.setText("Costo: $" + poliza.getCostoPoliza());

        btnEditar.setOnClickListener(v -> editarPoliza(poliza));

        btnEliminar.setOnClickListener(v -> confirmarEliminacion(poliza, position));

        return convertView;
    }

    private void editarPoliza(Poliza poliza) {
        Intent intent = new Intent(context, EditPolizaActivity.class);
        intent.putExtra("id", poliza.getId());
        intent.putExtra("nombre", poliza.getNombre());
        intent.putExtra("valor", poliza.getValor());
        intent.putExtra("accidentes", poliza.getAccidente());
        intent.putExtra("modelo", poliza.getModelo());

        try {
            int edad = Integer.parseInt(poliza.getEdad());
            intent.putExtra("edad", edad);
        } catch (NumberFormatException e) {
            intent.putExtra("edad", 0); // Valor predeterminado si hay error
        }

        context.startActivity(intent);
    }

    private void confirmarEliminacion(Poliza poliza, int position) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle("Eliminar Póliza")
                .setMessage("¿Deseas eliminar la póliza de " + poliza.getNombre() + "?")
                .setPositiveButton("Sí", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        eliminarPoliza(poliza, position);
                    }
                })
                .setNegativeButton("No", null)
                .show();
    }

    private void eliminarPoliza(Poliza poliza, int position) {
        if (dbHelper.deletePoliza(poliza.getId())) {
            polizas.remove(position);
            notifyDataSetChanged();
            Toast.makeText(context, "Póliza eliminada", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(context, "Error al eliminar póliza", Toast.LENGTH_SHORT).show();
        }
    }
    public void actualizarLista(List<Poliza> nuevaLista) {
        polizas.clear();
        polizas.addAll(nuevaLista);
        notifyDataSetChanged();
    }

}
