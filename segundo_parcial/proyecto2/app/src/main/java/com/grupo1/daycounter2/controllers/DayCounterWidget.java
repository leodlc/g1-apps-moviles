package com.grupo1.daycounter2.controllers;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.widget.RemoteViews;

import com.grupo1.daycounter2.R;
import com.grupo1.daycounter2.models.DateCalculator;
import com.grupo1.daycounter2.views.MainActivity;

import java.util.Random;

public class DayCounterWidget extends AppWidgetProvider {

    private static int currentEventIndex = 0;

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        SharedPreferences prefs = context.getSharedPreferences("DayCounterPrefs", Context.MODE_PRIVATE);
        int eventCount = prefs.getInt("event_count", 0);

        for (int appWidgetId : appWidgetIds) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.app_widget_layout);

            if (eventCount > 0) {
                String title = prefs.getString("event_title_" + currentEventIndex, "Evento");
                String date = prefs.getString("event_date_" + currentEventIndex, "2025-01-01");

                int daysLeft = DateCalculator.calculateDaysLeft(date);
                int hoursLeft = DateCalculator.calculateHoursLeft(date);

                // Configurar textos
                views.setTextViewText(R.id.widget_event_title, title);
                views.setTextViewText(R.id.widget_event_days_number, String.valueOf(daysLeft));
                views.setTextViewText(R.id.widget_event_days_label, "Días");
                views.setTextViewText(R.id.widget_event_hours_number, String.valueOf(hoursLeft));
                views.setTextViewText(R.id.widget_event_hours_label, "Horas");
                views.setTextViewText(R.id.widget_event_date, date);

                // Color de fondo aleatorio
                String color = getRandomColor(context);
                views.setInt(R.id.widget_container, "setBackgroundColor", Color.parseColor(color));
            } else {
                views.setTextViewText(R.id.widget_event_title, "Sin eventos");
                views.setTextViewText(R.id.widget_event_days_number, "0");
                views.setTextViewText(R.id.widget_event_days_label, "Días");
                views.setTextViewText(R.id.widget_event_hours_number, "0");
                views.setTextViewText(R.id.widget_event_hours_label, "Horas");
                views.setTextViewText(R.id.widget_event_date, "");
                views.setInt(R.id.widget_container, "setBackgroundColor", Color.WHITE);
            }

            configureButtons(context, appWidgetManager, appWidgetId, views, eventCount);
            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }


    private void configureButtons(Context context, AppWidgetManager appWidgetManager, int appWidgetId, RemoteViews views, int eventCount) {
        // Botón "Anterior"
        Intent prevIntent = new Intent(context, DayCounterWidget.class);
        prevIntent.setAction("com.grupo1.daycounter2.PREV_EVENT");
        PendingIntent prevPendingIntent = PendingIntent.getBroadcast(context, 0, prevIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        views.setOnClickPendingIntent(R.id.widget_prev_event, prevPendingIntent);

        // Botón "Añadir"
        Intent addIntent = new Intent(context, MainActivity.class);
        PendingIntent addPendingIntent = PendingIntent.getActivity(context, 0, addIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        views.setOnClickPendingIntent(R.id.widget_add_event, addPendingIntent);

        // Botón "Siguiente"
        Intent nextIntent = new Intent(context, DayCounterWidget.class);
        nextIntent.setAction("com.grupo1.daycounter2.NEXT_EVENT");
        PendingIntent nextPendingIntent = PendingIntent.getBroadcast(context, 1, nextIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        views.setOnClickPendingIntent(R.id.widget_next_event, nextPendingIntent);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);

        SharedPreferences prefs = context.getSharedPreferences("DayCounterPrefs", Context.MODE_PRIVATE);
        int eventCount = prefs.getInt("event_count", 0);

        if ("com.grupo1.daycounter2.PREV_EVENT".equals(intent.getAction()) && eventCount > 0) {
            currentEventIndex = (currentEventIndex - 1 + eventCount) % eventCount;
        } else if ("com.grupo1.daycounter2.NEXT_EVENT".equals(intent.getAction()) && eventCount > 0) {
            currentEventIndex = (currentEventIndex + 1) % eventCount;
        }

        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
        onUpdate(context, appWidgetManager, appWidgetManager.getAppWidgetIds(new ComponentName(context, DayCounterWidget.class)));
    }

    private String getRandomColor(Context context) {
        String[] colors = context.getResources().getStringArray(R.array.widget_colors);
        Random random = new Random();
        return colors[random.nextInt(colors.length)];
    }
}
