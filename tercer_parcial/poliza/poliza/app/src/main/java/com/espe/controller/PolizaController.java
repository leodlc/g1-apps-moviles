package com.espe.controller;

public class PolizaController {
    public static double calcularCosto(String nombre, double valor, int accidentes, char modelo, int edad) {
        // Cargo por valor
        double cargoxvalor = valor * 0.035;

        // Cargo por modelo
        double cargoxmodelo;
        switch (modelo) {
            case 'A':
                cargoxmodelo = valor * 0.011;
                break;
            case 'B':
                cargoxmodelo = valor * 0.012;
                break;
            case 'C':
                cargoxmodelo = valor * 0.015;
                break;
            default:
                cargoxmodelo = 0;
                break;
        }

        // Cargo por edad
        double cargoxedad = 0;
        if (edad >= 18 && edad <= 23) {
            cargoxedad = valor * 0.10;
        } else if (edad >= 25 && edad <= 35) {
            cargoxedad = valor * 0.07;
        } else if (edad > 55) {
            cargoxedad = valor * 0.12;
        }

        // Cargo por accidentes
        double cargoxacc = (accidentes <= 3) ? (accidentes * 17) : (accidentes * 21);

        // Costo total
        return cargoxvalor + cargoxmodelo + cargoxedad + cargoxacc;
    }
}
