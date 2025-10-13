import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('pt', 'BR');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.supportedLocales.contains(locale)) return;
    
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('pt', 'BR');
    notifyListeners();
  }
}

class L10n {
  static final supportedLocales = [
    const Locale('pt', 'BR'),
    const Locale('en', 'US'),
  ];

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'pt':
        return 'Português';
      case 'en':
        return 'English';
      default:
        return 'Português';
    }
  }
}

