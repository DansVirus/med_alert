import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import 'package:med_alert2/models/alert.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import '../utils/custom_helper_functions.dart';

class AlertProvider with ChangeNotifier {
  List<Alert> _alertList = [];
  late Box<Alert> _alertBox;
  late Box<String> _alarmTimeBox;

  //test
  Box<Alert> get alertBox => _alertBox;
  Box<String> get alarmTimeBox => _alarmTimeBox;

  //test
  AlertProvider({bool initialize = true}) {
    if (initialize) _initializeHive();
  }


  Future<void> _initializeHive() async {
    _alertBox = await Hive.openBox<Alert>('alerts');
    _alarmTimeBox = await Hive.openBox<String>('alarm_times');

    _alertList = _alertBox.values.toList();
    notifyListeners();

    // ✅ Re-schedule all saved alarms on app restart
    for (var alert in _alertList) {
      scheduleAlarm(alert);
    }
  }

  List<Alert> get getAlertList => _alertList;

  Alert? getAlertByTime(TimeOfDay time) {
    return _alertList.firstWhereOrNull(
          (alert) => alert.time.hour == time.hour && alert.time.minute == time.minute,
    );
  }

  Future<void> addAlert(Alert alert) async {
    _alertList.add(alert);
    await _alertBox.add(alert); // Save to Hive
    await scheduleAlarm(alert);
    print("✅ Alert added at: ${alert.time.hour}:${alert.time.minute}");
    notifyListeners();
  }

  Future<void> deleteAlert(TimeOfDay alertTime) async {
    final index = _alertList.indexWhere((alert) => alert.time == alertTime);
    if (index != -1) {
      await _alertBox.deleteAt(index);
      await _alarmTimeBox.delete(_alertList[index].hashCode);
      _alertList.removeAt(index);
      print("🗑 Alert deleted at: ${alertTime.hour}:${alertTime.minute}");
      notifyListeners();
    }
  }

  @protected
  Future<void> scheduleAlarm(Alert alert) async {
    print("🔹 Scheduling alarm for ${alert.time.hour}:${alert.time.minute}");

    DateTime now = DateTime.now();
    DateTime alertTime = DateTime(
      now.year,
      now.month,
      now.day,
      alert.time.hour,
      alert.time.minute,
    );

    if (alertTime.isBefore(now)) {
      alertTime = alertTime.add(const Duration(days: 1));
    }

    print("🔹 Adjusted alert time: $alertTime");

    if (await Permission.scheduleExactAlarm.request().isGranted) {
      print("✅ Permission granted, scheduling alarm...");

      int alarmId = alertTime.millisecondsSinceEpoch % 10000;

      // ✅ Store the formatted alert time in `alarmTimeBox`
      _alarmTimeBox.put(alarmId, formatTimeOfDay(alert.time));

      bool result = await AndroidAlarmManager.oneShotAt(
        alertTime,
        alarmId,
        alarmCallback,
        exact: true,
        wakeup: true,
      );

      print(result ? "✅ Alarm successfully scheduled" : "❌ Failed to schedule alarm");
    } else {
      print("❌ SCHEDULE_EXACT_ALARM permission denied.");
    }
  }
  //test
  @visibleForTesting
  set testAlertBox(Box<Alert> box) => _alertBox = box;

  @visibleForTesting
  set testAlarmTimeBox(Box<String> box) => _alarmTimeBox = box;

  @visibleForTesting
  set testAlertList(List<Alert> list) => _alertList = list;

}
