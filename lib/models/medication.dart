import 'package:hive/hive.dart';

part 'medication.g.dart';

@HiveType(typeId: 2) // Unique ID for Medication adapter
class Medication extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String dosage;

  @HiveField(3)
  String? instructions; // Optional field

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    this.instructions,
  });
}
