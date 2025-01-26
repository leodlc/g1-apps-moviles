package com.grupo1.daycounter2.controllers;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;

import com.grupo1.daycounter2.R;
import com.grupo1.daycounter2.views.MainActivity;
import com.grupo1.daycounter2.models.DateCalculator;

public class DayCounterWidget extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        SharedPreferences prefs = context.getSharedPreferences("DayCounterPrefs", Context.MODE_PRIVATE);

        int eventCount = prefs.getInt("event_count", 0);
        StringBuilder widgetText = new StringBuilder();

        for (int i = 0; i < eventCount; i++) {
            String title = prefs.getString("event_title_" + i, "Evento");
            String date = prefs.getString("event_date_" + i, "2025-01-01");
            int daysLeft = calculateDaysLeft(date);

            widgetText.append(title).append(": ").append(daysLeft).append(" días\n");
        }

        for (int appWidgetId : appWidgetIds) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.app_widget_layout);
            views.setTextViewText(R.id.widget_text, widgetText.toString().trim());

            Intent intent = new Intent(context, MainActivity.class);
            PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
            views.setOnClickPendingIntent(R.id.widget_text, pendingIntent);

            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }

    private int calculateDaysLeft(String targetDate) {
        return DateCalculator.calculateDaysLeft(targetDate);
    }
}
