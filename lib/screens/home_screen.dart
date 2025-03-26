import 'package:flutter/material.dart';
import 'package:med_alert2/screens/set_alert_screen.dart';
import 'package:med_alert2/utils/custom_helper_functions.dart';
import 'package:med_alert2/widgets/accessible_ext.dart';
import 'package:med_alert2/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localization.dart';
import '../providers/alert_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Offset _magnifierOffset = Offset.zero;
  bool _isMagnifierActive = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(context),
        body: Consumer<AlertProvider>(
          builder: (ctx, reminderProvider, _) {
            // Sort alerts by time before displaying them
            final sortedAlertList = List.of(reminderProvider.getAlertList)
              ..sort((a, b) => compareTimeOfDay(a.time, b.time));
      
            if (sortedAlertList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('no_alert'),
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              );
            }
            return GestureDetector(
              onLongPressStart: (details) {
                setState(() {
                  _magnifierOffset = details.localPosition;
                  _isMagnifierActive = true;
                });
              },
              onLongPressMoveUpdate: (details) {
                setState(() {
                  _magnifierOffset = details.localPosition;
                });
              },
              onLongPressEnd: (details) {
                setState(() {
                  _isMagnifierActive = false;
                });
              },
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: sortedAlertList.length,
                    itemBuilder: (ctx, index) {
                      final group = sortedAlertList[index];
                      return Dismissible(
                        key: ValueKey(group.time),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.translate('delete_reminder_title'),
                                  ),
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .translate('delete_reminder_message')
                                        .replaceAll(
                                          '{time}',
                                          formatTimeOfDay(group.time),
                                        ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.translate('cancel'),
                                      ),
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                    ),
                                    TextButton(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.translate('delete'),
                                      ),
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                    ),
                                  ],
                                ),
                          );
                        },
                        onDismissed: (direction) {
                          final removedGroup = group;
                          reminderProvider.deleteAlert(group.time);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!
                                    .translate('reminder_removed')
                                    .replaceAll(
                                      '{time}',
                                      formatTimeOfDay(group.time),
                                    ),
                              ),
                              action: SnackBarAction(
                                label: AppLocalizations.of(
                                  context,
                                )!.translate('undo'),
                                onPressed: () {
                                  reminderProvider.addAlert(removedGroup);
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          margin: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            border: Border.all(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              AppLocalizations.of(context)!
                                  .translate('reminder_at')
                                  .replaceAll(
                                    '{time}',
                                    formatTimeOfDay(group.time),
                                  ),
                              style: TextStyle(color: Colors.black),
                            ),
                            children:
                                group.medicationList.map((medication) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade700,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue.shade100,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        medication.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate('dosage')
                                                .replaceAll(
                                                  '{dosage}',
                                                  medication.dosage,
                                                ),
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate('instructions')
                                                .replaceAll(
                                                  '{instructions}',
                                                  medication.instructions ?? '',
                                                ),
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ).accessible(
                            hint: AppLocalizations.of(context)!
                                .translate('alert_tile_hint'),
                          ),
                        ),
                      );
                    },
                  ),
                  //Todo: Finger to bottom left of the border.
                  if (_isMagnifierActive)
                    Positioned(
                      left: _magnifierOffset.dx - 160,
                      top: _magnifierOffset.dy - 100,
                      child: RawMagnifier(
                        decoration: MagnifierDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.red, width: 3),
                          ),
                        ),
                        focalPointOffset: Offset.zero,
                        size: Size(160, 100),
                        magnificationScale: 1.7,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Semantics(
            label: AppLocalizations.of(context)!
                .translate('fab_label'),
            hint: AppLocalizations.of(context)!
                .translate('fab_hint'),
            excludeSemantics: true,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetAlertScreen()),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );
  }
}
