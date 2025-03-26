import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Get an instance of AppLocalizations
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  late Map<String, String> _localizedStrings;

  // Load language JSON file from assets
  Future<void> load() async {
    String jsonString =
    await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  // Get translation for a given key
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // LocalizationsDelegate to load the appropriate language file
  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();
}

// Localizations Delegate
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'de', 'el', 'zh', 'fr', 'es', 'hi', 'pt', 'it', 'ja', 'ko', 'ar', 'tr', 'pl', 'he',].contains(locale.languageCode); // Supported languages
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
