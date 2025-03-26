import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:med_alert2/utils/custom_helper_functions.dart';

void main() {
  group('computeNextAlertTime', () {
    test('schedules for today if time is in the future', () {
      final now = DateTime(2025, 3, 24, 10, 0); // 10:00 AM
      final alertTime = const TimeOfDay(hour: 11, minute: 30); // 11:30 AM

      final result = computeNextAlertTime(alertTime, now);

      expect(result.day, now.day);
      expect(result.hour, 11);
      expect(result.minute, 30);
    });

    test('schedules for tomorrow if time is in the past', () {
      final now = DateTime(2025, 3, 24, 15, 0); // 3:00 PM
      final alertTime = const TimeOfDay(hour: 9, minute: 0); // 9:00 AM

      final result = computeNextAlertTime(alertTime, now);

      expect(result.day, now.day + 1);
      expect(result.hour, 9);
      expect(result.minute, 0);
    });

    test('schedules for tomorrow if alert time is exactly now minus one minute', () {
      final now = DateTime(2025, 3, 24, 9, 1);
      final alertTime = const TimeOfDay(hour: 9, minute: 0);

      final result = computeNextAlertTime(alertTime, now);

      expect(result.day, now.day + 1);
      expect(result.hour, 9);
      expect(result.minute, 0);
    });

    test('schedules for today if alert time is exactly now', () {
      final now = DateTime(2025, 3, 24, 9, 0);
      final alertTime = const TimeOfDay(hour: 9, minute: 0);

      final result = computeNextAlertTime(alertTime, now);

      expect(result.day, now.day);
      expect(result.hour, 9);
      expect(result.minute, 0);
    });
  });
}
