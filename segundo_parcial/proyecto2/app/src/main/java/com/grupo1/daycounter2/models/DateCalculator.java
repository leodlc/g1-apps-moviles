package com.grupo1.daycounter2.models;

import android.content.Context;
import android.content.SharedPreferences;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DateCalculator {
    private static final String PREF_NAME = "DayCounterPrefs";
    private static final String KEY_DAYS_REMAINING = "days_remaining";

    public static int calculateDaysLeft(String targetDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        try {
            Date target = sdf.parse(targetDate);
            Date today = Calendar.getInstance().getTime();
            long diff = target.getTime() - today.getTime();
            return (int) (diff / (1000 * 60 * 60 * 24)); // Días completos restantes
        } catch (Exception e) {
            e.printStackTrace();
            return -1; // En caso de error
        }
    }

    public static int calculateHoursLeft(String targetDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        try {
            // Obtener la fecha objetivo y la fecha actual
            Date target = sdf.parse(targetDate);
            Date today = Calendar.getInstance().getTime();

            // Calcular la diferencia en milisegundos
            long diff = target.getTime() - today.getTime();

            // Calcular las horas restantes
            return (int) (diff / (1000 * 60 * 60)) % 24; // Horas restantes, excluyendo días completos
        } catch (Exception e) {
            e.printStackTrace();
            return -1; // En caso de error
        }
    }

    public static void saveDaysRemaining(Context context, int days) {
        SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        prefs.edit().putInt(KEY_DAYS_REMAINING, days).apply();
    }

    public static int getDaysRemaining(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        return prefs.getInt(KEY_DAYS_REMAINING, 0);
    }
}
