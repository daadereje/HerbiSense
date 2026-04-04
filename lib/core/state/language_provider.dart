import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global language code provider: 'eng', 'amh', 'or'.
final languageProvider =
    StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('eng');

  void setLanguage(String code) {
    state = code;
  }
}
