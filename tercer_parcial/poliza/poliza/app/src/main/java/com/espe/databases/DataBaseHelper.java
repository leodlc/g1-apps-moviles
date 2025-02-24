package com.espe.databases;

import android.content.Context;
import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import androidx.annotation.Nullable;
import com.espe.model.Poliza;
import java.util.ArrayList;
import java.util.List;

public class DataBaseHelper extends SQLiteOpenHelper {
    private static final String DATABASE_NAME = "poliza.db";
    private static final int DATABASE_VERSION = 1;

    private static final String TABLE_NAME = "polizas";
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_NOMBRE = "nombre";
    private static final String COLUMN_VALOR = "valor";
    private static final String COLUMN_ACCIDENTES = "accidentes";
    private static final String COLUMN_MODELO = "modelo";
    private static final String COLUMN_EDAD = "edad";
    private static final String COLUMN_COSTO = "costo_poliza";

    private static final String TABLE_CREATE =
            "CREATE TABLE " + TABLE_NAME + " ( " +
                    COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    COLUMN_NOMBRE + " TEXT NOT NULL, " +
                    COLUMN_VALOR + " REAL NOT NULL, " +
                    COLUMN_ACCIDENTES + " INTEGER NOT NULL, " +
                    COLUMN_MODELO + " TEXT NOT NULL, " +
                    COLUMN_EDAD + " INTEGER NOT NULL, " +
                    COLUMN_COSTO + " REAL NOT NULL ) ";

    public DataBaseHelper(@Nullable Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(TABLE_CREATE);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
        onCreate(db);
    }

    // Insertar póliza
    public Boolean insertarPoliza(String nombre, double valorAuto, int accidentes, int modelo, int edad, double costoPoliza) {
        SQLiteDatabase sqLiteDatabase = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_NOMBRE, nombre);
        values.put(COLUMN_VALOR, valorAuto);
        values.put(COLUMN_ACCIDENTES, accidentes);
        values.put(COLUMN_MODELO, modelo);
        values.put(COLUMN_EDAD, edad);
        values.put(COLUMN_COSTO, costoPoliza);

        long resultado = sqLiteDatabase.insert(TABLE_NAME, null, values);
        sqLiteDatabase.close(); // CERRAR BD DESPUÉS DE INSERTAR

        return resultado != -1;
    }

    // Obtener todas las pólizas
    public List<Poliza> getAllPolizas() {
        List<Poliza> polizas = new ArrayList<>();
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_NAME, null);

        if (cursor.moveToFirst()) {
            do {
                polizas.add(new Poliza(
                        cursor.getInt(0),   // ID
                        cursor.getString(1), // Nombre
                        cursor.getDouble(2), // Valor
                        cursor.getInt(3),    // Accidentes
                        cursor.getString(4), // Modelo
                        cursor.getString(5), // Edad
                        cursor.getDouble(6)  // Costo
                ));
            } while (cursor.moveToNext());
        }
        cursor.close();
        db.close();
        return polizas;
    }


    // Actualizar póliza
    public boolean updatePoliza(int id, Poliza poliza) {
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();

        values.put(COLUMN_NOMBRE, poliza.getNombre());
        values.put(COLUMN_VALOR, poliza.getValor());
        values.put(COLUMN_ACCIDENTES, poliza.getAccidente());
        values.put(COLUMN_MODELO, poliza.getModelo());
        values.put(COLUMN_EDAD, poliza.getEdad());
        values.put(COLUMN_COSTO, poliza.getCostoPoliza()); // Asegurar que el costo se actualiza

        Log.d("DataBaseHelper", "Actualizando póliza en DB: ID=" + id + ", Nombre=" + poliza.getNombre() + ", Modelo=" + poliza.getModelo());

        // Log para depuración
        System.out.println("Actualizando póliza ID: " + id + " con nombre: " + poliza.getNombre());
        System.out.println("Actualizando póliza ID: " + id + " con valor: " + poliza.getValor());
        System.out.println("Actualizando póliza ID: " + id + " con accidentes: " + poliza.getAccidente());
        System.out.println("Actualizando póliza ID: " + id + " con modelo: " + poliza.getModelo());
        System.out.println("Actualizando póliza ID: " + id + " con edad: " + poliza.getEdad());
        System.out.println("Actualizando póliza ID: " + id + " con costo: " + poliza.getCostoPoliza());

        int rows = db.update(TABLE_NAME, values, COLUMN_ID + "=?", new String[]{String.valueOf(id)});
        db.close();

        if (rows > 0) {
            Log.d("DataBaseHelper", "Actualización exitosa en la BD");
        } else {
            Log.e("DataBaseHelper", "Error: La actualización no afectó ninguna fila");
        }

        return rows > 0;
    }



    // Eliminar póliza
    public boolean deletePoliza(int id) {
        SQLiteDatabase db = this.getWritableDatabase();
        int rows = db.delete(TABLE_NAME, COLUMN_ID + "=?", new String[]{String.valueOf(id)});
        db.close();
        return rows > 0;
    }
    // Obtener póliza por ID
    public Poliza getPolizaById(int id) {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_NAME + " WHERE " + COLUMN_ID + "=?", new String[]{String.valueOf(id)});

        if (cursor.moveToFirst()) {
            Poliza poliza = new Poliza(
                    cursor.getInt(0),   // ID
                    cursor.getString(1), // Nombre
                    cursor.getDouble(2), // Valor
                    cursor.getInt(3),    // Accidentes
                    cursor.getString(4), // Modelo
                    cursor.getString(5), // Edad
                    cursor.getDouble(6)  // Costo
            );
            cursor.close();
            db.close();
            return poliza;
        }

        cursor.close();
        db.close();
        return null; // No se encontró la póliza
    }

    // Obtener póliza por nombre
    public Poliza getPolizaByNombre(String nombre) {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_NAME + " WHERE " + COLUMN_NOMBRE + "=?", new String[]{nombre});

        if (cursor.moveToFirst()) {
            Poliza poliza = new Poliza(
                    cursor.getInt(0),   // ID
                    cursor.getString(1), // Nombre
                    cursor.getDouble(2), // Valor
                    cursor.getInt(3),    // Accidentes
                    cursor.getString(4), // Modelo
                    cursor.getString(5), // Edad
                    cursor.getDouble(6)  // Costo
            );
            cursor.close();
            db.close();
            return poliza;
        }

        cursor.close();
        db.close();
        return null; // No se encontró la póliza
    }



}
