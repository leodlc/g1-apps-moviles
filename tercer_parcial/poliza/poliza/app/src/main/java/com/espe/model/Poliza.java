package com.espe.model;

public class Poliza {
    private int id;  // Agregar ID
    private String nombre;
    private double valor;
    private int accidente;
    private String modelo;
    private String edad;
    private double costoPoliza;

    public Poliza(int id, String nombre, double valor, int accidente, String modelo, String edad, double costoPoliza) {
        this.id = id;
        this.nombre = nombre;
        this.valor = valor;
        this.accidente = accidente;
        this.modelo = modelo;
        this.edad = edad;
        this.costoPoliza = costoPoliza;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public double getValor() { return valor; }
    public void setValor(double valor) { this.valor = valor; }

    public int getAccidente() { return accidente; }
    public void setAccidente(int accidente) { this.accidente = accidente; }

    public String getModelo() { return modelo; }
    public void setModelo(String modelo) { this.modelo = modelo; }

    public String getEdad() { return edad; }
    public void setEdad(String edad) { this.edad = edad; }

    public double getCostoPoliza() { return costoPoliza; }
    public void setCostoPoliza(double costoPoliza) { this.costoPoliza = costoPoliza; }
}
