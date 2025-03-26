import 'package:flutter/material.dart';
import 'package:med_alert2/models/medication.dart';
import '../l10n/app_localization.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('add_medication')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Medication Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('medication_name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate('medication_name_error');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dosage Label (Updated Key)
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('dosage_label'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate('dosage_error');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Instructions (Optional)
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('instructions_optional'),
                ),
              ),
              const SizedBox(height: 20),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create a medication object
                    final medication = Medication(
                        id: UniqueKey().toString(),
                        name: _nameController.text,
                        dosage: _dosageController.text,
                        instructions: _instructionsController.text
                    );

                    // Return the medication to the previous screen
                    Navigator.pop(context, medication);
                  }
                },
                child: Text(AppLocalizations.of(context)!.translate('save_medication')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
