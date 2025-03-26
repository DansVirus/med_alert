import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:med_alert2/providers/alert_provider.dart';
import 'package:med_alert2/models/alert.dart';
import 'package:med_alert2/models/medication.dart';
import 'package:med_alert2/utils/custom_helper_functions.dart';

int scheduleCallCount = 0;

/// 🧪 Mock provider that avoids platform calls and real initialization
class MockAlertProvider extends AlertProvider {
  MockAlertProvider() : super(initialize: false);

  Future<void> _initializeHive() async {
    testAlertBox = await Hive.openBox<Alert>('alerts');
    testAlarmTimeBox = await Hive.openBox<String>('alarm_times');
    testAlertList = alertBox.values.toList();
    notifyListeners();

    // Simulate rescheduling alerts
    for (var alert in getAlertList) {
      await scheduleAlarm(alert);
    }

    print("🧪 Mock _initializeHive without scheduling alarms");
  }

  @override
  Future<void> scheduleAlarm(Alert alert) async {
    scheduleCallCount++;

    final now = DateTime.now();
    final alertDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      alert.time.hour,
      alert.time.minute,
    );
    final alarmId = alertDateTime.millisecondsSinceEpoch % 10000;

    final formatted = formatTimeOfDay(alert.time);
    alarmTimeBox.put(alarmId, formatted);

    print("🧪 Mock scheduleAlarm: saved $formatted to alarmTimeBox[$alarmId]");
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AlertProvider Tests', () {
    late MockAlertProvider provider;

    void safeRegisterAdapters() {
      try {
        Hive.registerAdapter(AlertAdapter());
      } catch (_) {}
      try {
        Hive.registerAdapter(MedicationAdapter());
      } catch (_) {}
      try {
        Hive.registerAdapter(TimeOfDayAdapter());
      } catch (_) {}
    }

    setUp(() async {
      await setUpTestHive();
      safeRegisterAdapters();

      scheduleCallCount = 0;

      provider = MockAlertProvider();
      await provider._initializeHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('addAlert should add to list and Hive box', () async {
      final alert = Alert(
        time: const TimeOfDay(hour: 9, minute: 30),
        medicationList: [],
      );

      await provider.addAlert(alert);

      expect(provider.getAlertList.length, 1);
      expect(provider.getAlertList[0].time, const TimeOfDay(hour: 9, minute: 30));

      final stored = provider.alertBox.getAt(0);
      expect(stored?.time.hour, 9);
      expect(stored?.time.minute, 30);

      expect(scheduleCallCount, 1);
      expect(provider.runtimeType, MockAlertProvider);
    });

    test('getAlertByTime should return matching alert', () async {
      final alert = Alert(
        time: const TimeOfDay(hour: 7, minute: 45),
        medicationList: [],
      );

      await provider.addAlert(alert);

      final found = provider.getAlertByTime(const TimeOfDay(hour: 7, minute: 45));
      expect(found, isNotNull);
      expect(scheduleCallCount, 1);
    });

    test('deleteAlert should remove from list and Hive', () async {
      final alert = Alert(
        time: const TimeOfDay(hour: 8, minute: 0),
        medicationList: [],
      );

      await provider.addAlert(alert);
      expect(provider.getAlertList.length, 1);

      await provider.deleteAlert(alert.time);
      expect(provider.getAlertList.length, 0);
      expect(provider.alertBox.values.length, 0);
    });

    test('should allow adding duplicate alerts (same time)', () async {
      final alert1 = Alert(
        time: const TimeOfDay(hour: 10, minute: 0),
        medicationList: [],
      );
      final alert2 = Alert(
        time: const TimeOfDay(hour: 10, minute: 0),
        medicationList: [],
      );

      await provider.addAlert(alert1);
      await provider.addAlert(alert2);

      expect(provider.getAlertList.length, 2);
      expect(scheduleCallCount, 2);
    });

    test('should store formatted time in alarmTimeBox when alert is added', () async {
      final alert = Alert(
        time: const TimeOfDay(hour: 6, minute: 45),
        medicationList: [],
      );

      await provider.addAlert(alert);

      expect(provider.alarmTimeBox.isNotEmpty, true);

      final savedValue = provider.alarmTimeBox.values.first;
      expect(savedValue, '06:45');
    });

    test('should reschedule alerts after app restart', () async {
      scheduleCallCount = 0;

      final alert1 = Alert(
        time: const TimeOfDay(hour: 6, minute: 30),
        medicationList: [],
      );
      final alert2 = Alert(
        time: const TimeOfDay(hour: 20, minute: 15),
        medicationList: [],
      );

      // Simulate previously saved alerts
      await provider.alertBox.addAll([alert1, alert2]);

      final restartedProvider = MockAlertProvider();
      await restartedProvider._initializeHive();

      expect(restartedProvider.getAlertList.length, 2);
      expect(scheduleCallCount, 2);
    });
  });
}
