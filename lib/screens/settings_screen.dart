import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localization.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var languageProvider = Provider.of<LanguageProvider>(context);

    // List of supported locales
    final supportedLocales = [
      Locale('en'), // English
      Locale('de'), // German
      Locale('el'), // Greek
      Locale('zh'), // Chinese
      Locale('fr'), // French
      Locale('es'), // Spanish
      Locale('hi'), // Hindi
      Locale('pt'), // Portuguese
      Locale('it'), // Italian
      Locale('ja'), // Japanese
      Locale('ko'), // Korean
      Locale('ar'), // Arabic (RTL)
      Locale('tr'), // Turkish
      Locale('pl'), // Polish
      Locale('he'), // Hebrew (RTL)
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.translate('settings'),
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 1.5, height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.translate('language'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade600, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Locale>(
                    value: supportedLocales.contains(languageProvider.locale)
                        ? languageProvider.locale
                        : Locale('en'),
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        languageProvider.setLocale(newLocale);
                      }
                    },
                    items: supportedLocales.map((locale) {
                      return DropdownMenuItem(
                        value: locale,
                        child: Text(_getLanguageName(locale.languageCode), style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1.5, height: 20),

            // Dark Mode Toggle
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('dark_mode'),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1.5, height: 20),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'el':
        return 'Ελληνικά';
      case 'zh':
        return '中文';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      case 'hi':
        return 'हिन्दी';
      case 'pt':
        return 'Português';
      case 'it':
        return 'Italiano';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'ar':
        return 'العربية';
      case 'tr':
        return 'Türkçe';
      case 'pl':
        return 'Polski';
      case 'he':
        return 'עברית';
      default:
        return 'Unknown';
    }
  }
}
