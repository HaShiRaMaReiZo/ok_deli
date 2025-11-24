import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreference {
  static const String _languageKey = 'selected_language';

  /// Get the saved language code (e.g., 'en', 'my')
  /// Returns null if no language is saved (will use device default)
  static Future<String?> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_languageKey);
    } catch (e) {
      return null;
    }
  }

  /// Save the selected language code
  static Future<bool> setLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      return false;
    }
  }

  /// Clear the saved language (will use device default)
  static Future<bool> clearLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_languageKey);
    } catch (e) {
      return false;
    }
  }
}
