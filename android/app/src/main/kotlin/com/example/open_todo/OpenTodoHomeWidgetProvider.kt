package com.example.open_todo

import android.appwidget.AppWidgetManager
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class OpenTodoHomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        val pendingCount = widgetData.getInt("pending_count", 0)
        val titles = widgetData.getString("todo_titles", "") ?: ""

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.open_todo_widget).apply {
                setTextViewText(R.id.widget_title, "Open Todo")
                setTextViewText(
                    R.id.widget_pending_count,
                    if (pendingCount == 1) "1 task left" else "$pendingCount tasks left",
                )
                setTextViewText(
                    R.id.widget_todo_list,
                    titles.ifBlank { "All caught up ✓" },
                )
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}