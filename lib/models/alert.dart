import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'medication.dart';

part 'alert.g.dart';

@HiveType(typeId: 0)
class Alert extends HiveObject {
  @HiveField(0)
  TimeOfDay time; // Now works with Hive via the custom adapter

  @HiveField(1)
  List<Medication> medicationList; // Now works with MedicationAdapter

  Alert({required this.time, required this.medicationList});
}
