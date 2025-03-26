import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Helper function to format time of day.
String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat.Hm().format(dt); // Formats time as "HH:mm" (24-hour format)
}

// Helper function to compare TimeOfDay objects
int compareTimeOfDay(TimeOfDay a, TimeOfDay b) {
  if (a.hour == b.hour) {
    return a.minute.compareTo(b.minute);
  }
  return a.hour.compareTo(b.hour);
}

//test
DateTime computeNextAlertTime(TimeOfDay alertTime, DateTime now) {
  DateTime scheduled = DateTime(now.year, now.month, now.day, alertTime.hour, alertTime.minute);
  return scheduled.isBefore(now) ? scheduled.add(const Duration(days: 1)) : scheduled;
}

