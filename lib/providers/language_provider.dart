import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale('en', 'US'); // Default language
  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  // Load saved language from Hive
  Future<void> _loadSavedLanguage() async {
    var box = await Hive.openBox('settings');
    String? langCode = box.get('language');
    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

  // Set a new locale and save it in Hive
  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    var box = await Hive.openBox('settings');
    await box.put('language', newLocale.languageCode);
    notifyListeners();
  }
}
