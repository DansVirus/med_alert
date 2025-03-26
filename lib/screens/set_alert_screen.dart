import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:med_alert2/models/medication.dart';
import 'package:med_alert2/models/alert.dart';
import 'package:med_alert2/providers/alert_provider.dart';
import '../l10n/app_localization.dart';
import 'add_medication_screen.dart';

class SetAlertScreen extends StatefulWidget {
  const SetAlertScreen({super.key});

  @override
  State<SetAlertScreen> createState() => _SetAlertScreenState();
}

class _SetAlertScreenState extends State<SetAlertScreen> {
  int _currentStep = 0;
  TimeOfDay? _selectedTime;
  List<Medication> _medications = [];

  void _stepContinue() {
    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      }
    });
  }

  void _stepCancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _stepTap(int index) {
    setState(() {
      _currentStep = index;
    });
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _addMedication() async {
    final newMedication = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicationScreen(),
      ),
    );

    if (newMedication != null) {
      setState(() {
        _medications.add(newMedication);
      });
    }
  }

  void _removeMedication(int index) {
    setState(() {
      _medications.removeAt(index);
    });
  }

  void _saveAlert() {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate('select_time_error'))),
      );
      return;
    }

    if (_medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate('add_medication_error'))),
      );
      return;
    }

    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final newAlert = Alert(time: _selectedTime!, medicationList: _medications);
    alertProvider.addAlert(newAlert);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.translate('alert_scheduled_success'))),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.translate('set_alarm'), style: TextStyle(fontSize: 24))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepCancel: _stepCancel,
          onStepContinue: _currentStep < 2 ? _stepContinue : null,
          onStepTapped: _stepTap,
          controlsBuilder: (context, details) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_currentStep == 0)
                  ElevatedButton(
                    onPressed: _pickTime,
                    child: Text(
                      _selectedTime == null
                          ? AppLocalizations.of(context)!.translate('select_time')
                          : '${AppLocalizations.of(context)!.translate('selected_time')}: ${_selectedTime!.format(context)}',
                    ),
                  ),
                const SizedBox(height: 10),
                if (_currentStep == 2)
                  ElevatedButton(
                    onPressed: _saveAlert,
                    child: Text(AppLocalizations.of(context)!.translate('confirm_save_alert')),
                  )
                else
                  Row(
                    children: [
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: Text(AppLocalizations.of(context)!.translate('back')),
                        ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(AppLocalizations.of(context)!.translate('next')),
                      ),
                    ],
                  ),
              ],
            );
          },
          steps: [
            Step(
              title: Text(AppLocalizations.of(context)!.translate('pick_time')),
              content: Column(
                children: [
                ],
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: Text(AppLocalizations.of(context)!.translate('add_medications')),
              content: Column(
                children: [
                  ElevatedButton(
                    onPressed: _addMedication,
                    child: Text(AppLocalizations.of(context)!.translate('add_medication')),
                  ),
                  const SizedBox(height: 10),
                  _medications.isEmpty
                      ? Text(AppLocalizations.of(context)!.translate('no_medications_added'))
                      : Column(
                    children: _medications
                        .asMap()
                        .entries
                        .map((entry) => Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(entry.value.name,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(entry.value.dosage),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeMedication(entry.key),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: Text(AppLocalizations.of(context)!.translate('review_confirm')),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.translate('scheduled_alert'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  if (_selectedTime != null)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[500],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        '⏰ ${_selectedTime!.format(context)}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  const SizedBox(height: 15),
                  Text(AppLocalizations.of(context)!.translate('medications'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  if (_medications.isEmpty)
                    Text(AppLocalizations.of(context)!.translate('no_medications_added'),
                        style: const TextStyle(color: Colors.grey)),
                  ..._medications.map((med) => Card(
                    color: Colors.blue[500],
                    elevation: 2,
                    child: ListTile(
                      title: Text('${med.dosage} ${med.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )),
                  const SizedBox(height: 20),
                ],
              ),
              isActive: _currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }
}
