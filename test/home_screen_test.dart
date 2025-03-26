import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:med_alert2/screens/home_screen.dart';
import 'package:med_alert2/screens/set_alert_screen.dart';
import 'package:med_alert2/models/alert.dart';
import 'package:med_alert2/providers/alert_provider.dart';

class FakeAlertProvider extends AlertProvider {
  FakeAlertProvider() : super(initialize: false);

  @override
  List<Alert> get getAlertList => [];

  @override
  Future<void> addAlert(Alert alert) async {}

  @override
  Future<void> deleteAlert(TimeOfDay time) async {}

  @override
  Future<void> scheduleAlarm(Alert alert) async {}
}

class TestAssetBundle extends CachingAssetBundle {
  final Map<String, String> fakeAssets;

  TestAssetBundle(this.fakeAssets);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (fakeAssets.containsKey(key)) {
      return fakeAssets[key]!;
    }
    throw FlutterError('Unable to load asset: $key');
  }

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError();
  }
}

Widget createTestableWidget(Widget child) {
  return Provider<AlertProvider>.value(
    value: FakeAlertProvider(),
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      home: DefaultAssetBundle(
        bundle: TestAssetBundle({
          'assets/lang/en.json': jsonEncode({
            'fab_label': 'Add Alert',
            'fab_hint': 'Tap to create a new alert',
            'no_alerts_message': "No alert added yet. Tap the '+' button to get started!",
          }),
        }),
        child: child,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Displays no alert message when list is empty', (tester) async {
    await tester.pumpWidget(createTestableWidget(const HomeScreen()));
    await tester.pumpAndSettle();

    expect(
      find.text("No alert added yet. Tap the '+' button to get started!"),
      findsOneWidget,
    );
  });

  testWidgets('FAB navigates to SetAlertScreen', (tester) async {
    await tester.pumpWidget(createTestableWidget(const HomeScreen()));
    await tester.pumpAndSettle();

    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget, reason: 'FAB should be present');

    await tester.tap(fab);
    await tester.pumpAndSettle();

    expect(find.byType(SetAlertScreen), findsOneWidget, reason: 'Should navigate to SetAlertScreen');
  });
}
