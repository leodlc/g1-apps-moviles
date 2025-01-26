package com.grupo1.daycounter2.views;

import android.app.AlertDialog;
import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.grupo1.daycounter2.R;
import com.grupo1.daycounter2.models.DateCalculator;
import com.grupo1.daycounter2.controllers.DayCounterWidget;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends AppCompatActivity {

    private LinearLayout eventListContainer;
    private ArrayList<Map<String, String>> events;
    private SharedPreferences sharedPreferences;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        eventListContainer = findViewById(R.id.event_list_container);
        ImageButton btnAddEvent = findViewById(R.id.btn_add_event);

        // Inicializar SharedPreferences
        sharedPreferences = getSharedPreferences("DayCounterPrefs", Context.MODE_PRIVATE);
        events = new ArrayList<>();

        // Cargar eventos desde SharedPreferences
        loadEvents();

        // Configurar el botón para abrir el diálogo de agregar eventos
        btnAddEvent.setOnClickListener(v -> showAddEventDialog());

        renderEvents();
    }

    private void showAddEventDialog() {
        View dialogView = getLayoutInflater().inflate(R.layout.dialog_add_event, null);

        EditText etEventName = dialogView.findViewById(R.id.et_event_name);
        DatePicker datePicker = dialogView.findViewById(R.id.date_picker);

        Calendar today = Calendar.getInstance();
        Calendar maxDate = Calendar.getInstance();
        maxDate.add(Calendar.YEAR, 10);

        datePicker.setMinDate(today.getTimeInMillis());
        datePicker.setMaxDate(maxDate.getTimeInMillis());

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setView(dialogView);
        builder.setCancelable(false);
        AlertDialog dialog = builder.create();

        dialogView.findViewById(R.id.btn_cancel).setOnClickListener(v -> dialog.dismiss());
        dialogView.findViewById(R.id.btn_save).setOnClickListener(v -> {
            String eventName = etEventName.getText().toString();
            int day = datePicker.getDayOfMonth();
            int month = datePicker.getMonth();
            int year = datePicker.getYear();

            if (eventName.isEmpty()) {
                etEventName.setError("Por favor, ingrese un nombre de evento.");
                return;
            }

            Calendar selectedDate = Calendar.getInstance();
            selectedDate.set(year, month, day);

            if (selectedDate.before(today)) {
                etEventName.setError("No se puede seleccionar una fecha anterior a hoy.");
                return;
            }

            String formattedDate = year + "-" + String.format("%02d", month + 1) + "-" + String.format("%02d", day);
            addEvent(eventName, formattedDate);
            renderEvents();
            saveEvents();
            notifyWidgetUpdate();

            dialog.dismiss();
        });

        dialog.show();
    }

    private void addEvent(String title, String date) {
        Map<String, String> event = new HashMap<>();
        event.put("title", title);
        event.put("date", date);
        events.add(event);
    }

    private void renderEvents() {
        eventListContainer.removeAllViews();

        for (int i = 0; i < events.size(); i++) {
            Map<String, String> event = events.get(i);

            View eventView = getLayoutInflater().inflate(R.layout.event_item, null);

            TextView tvTitle = eventView.findViewById(R.id.tv_event_title);
            TextView tvDate = eventView.findViewById(R.id.tv_event_date);
            TextView tvDays = eventView.findViewById(R.id.tv_event_days);

            tvTitle.setText(event.get("title"));
            tvDate.setText(event.get("date"));
            int daysRemaining = DateCalculator.calculateDaysLeft(event.get("date"));
            tvDays.setText(daysRemaining + " Días");

            switch (i % 3) {
                case 0:
                    eventView.setBackgroundColor(getResources().getColor(R.color.item_color_1));
                    break;
                case 1:
                    eventView.setBackgroundColor(getResources().getColor(R.color.item_color_2));
                    break;
                case 2:
                    eventView.setBackgroundColor(getResources().getColor(R.color.item_color_3));
                    break;
            }

            eventListContainer.addView(eventView);
        }
    }

    private void saveEvents() {
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putInt("event_count", events.size());

        for (int i = 0; i < events.size(); i++) {
            Map<String, String> event = events.get(i);
            editor.putString("event_title_" + i, event.get("title"));
            editor.putString("event_date_" + i, event.get("date"));
        }

        editor.apply();
    }

    private void loadEvents() {
        int eventCount = sharedPreferences.getInt("event_count", 0);

        for (int i = 0; i < eventCount; i++) {
            String title = sharedPreferences.getString("event_title_" + i, "");
            String date = sharedPreferences.getString("event_date_" + i, "");
            addEvent(title, date);
        }
    }

    private void notifyWidgetUpdate() {
        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(this);
        int[] appWidgetIds = appWidgetManager.getAppWidgetIds(new ComponentName(this, DayCounterWidget.class));

        Intent intent = new Intent(this, DayCounterWidget.class);
        intent.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds);

        sendBroadcast(intent);
    }
}
