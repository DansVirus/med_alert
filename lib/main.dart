import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:med_alert2/models/alert.dart';
import 'package:med_alert2/providers/language_provider.dart';
import 'package:med_alert2/providers/theme_provider.dart';
import 'package:med_alert2/utils/themes/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:med_alert2/utils/notification_helper.dart';
import 'package:med_alert2/providers/alert_provider.dart';
import 'package:med_alert2/screens/home_screen.dart';

import 'l10n/app_localization.dart';
import 'models/medication.dart';

@pragma('vm:entry-point')
void alarmCallback(int id) async {

  // ✅ Get the app's document directory
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path); // ✅ Provide Hive storage path

  var box = await Hive.openBox<String>('alarm_times');

  // ✅ Retrieve stored alert time
  String alertTime = box.get(id) ?? 'unknown time';

  // ✅ Show the notification
  await showNotification(alertTime);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  Hive.registerAdapter(AlertAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(MedicationAdapter());

  await Hive.openBox('settings'); // General settings storage
  await Hive.openBox<Alert>('alerts'); // ✅ Alert storage box
  await Hive.openBox<String>('alarm_times'); // ✅ Alarm time storage box

  // ✅ Initialize Notifications
  await initializeNotifications();

  // ✅ Initialize Android Alarm Manager
  await AndroidAlarmManager.initialize();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()), // Language Provider
        ChangeNotifierProvider(create: (context) => AlertProvider()), // Add more providers here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<LanguageProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: KAppTheme.blueTheme,
          // Use your custom light theme
          darkTheme: KAppTheme.blueDarkTheme,
          // Use your custom dark theme
          themeMode: themeProvider.themeMode,
          // Dynamically switch between light & dark
          supportedLocales: [
            Locale('en', 'US'),
            Locale('de', 'DE'),
            Locale('el', 'GR'),
            Locale('zh', 'CN'),
            Locale('fr', 'FR'),
            Locale('es', 'ES'),
            Locale('hi', 'IN'),
            Locale('pt', 'PT'),
            Locale('it', 'IT'),
            Locale('ja', 'JP'),
            Locale('ko', 'KR'),
            Locale('ar', 'SA'),
            Locale('tr', 'TR'),
            Locale('pl', 'PL'),
            Locale('he', 'IL'),
          ],
          locale: provider.locale, // Set the app's locale
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HomeScreen(),
        );
      },
    );
  }
}
