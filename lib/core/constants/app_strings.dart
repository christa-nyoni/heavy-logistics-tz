import 'package:flutter/foundation.dart';

enum AppLanguage { english, swahili }

class LanguageProvider extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.english;

  AppLanguage get currentLanguage => _currentLanguage;
  bool get isSwahili => _currentLanguage == AppLanguage.swahili;

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == AppLanguage.english 
        ? AppLanguage.swahili 
        : AppLanguage.english;
    notifyListeners();
  }

  String translate(String enText, String swText) {
    return _currentLanguage == AppLanguage.english ? enText : swText;
  }
}