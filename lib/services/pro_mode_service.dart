import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gestiona el progreso del Modo Pro: aciertos acumulados y letras del premio WiFi.
class ProModeService {
  ProModeService._();
  static final ProModeService instance = ProModeService._();

  static const String _keyCorrectCount = 'pro_mode_correct_count';
  static const String wifiPassword = 'casadepapel';
  static const int answersPerLetter = 20;

  int _correctCount = 0;
  bool _loaded = false;

  int get correctCount => _correctCount;
  int get unlockedLetterCount =>
      (_correctCount ~/ answersPerLetter).clamp(0, wifiPassword.length);
  int get progressToNextLetter => _correctCount % answersPerLetter;
  int get answersUntilNextLetter =>
      isPasswordComplete ? 0 : answersPerLetter - progressToNextLetter;
  bool get isPasswordComplete => unlockedLetterCount >= wifiPassword.length;

  /// Muestra letras desbloqueadas y oculta el resto con puntos.
  String get maskedPassword {
    final buffer = StringBuffer();
    for (var i = 0; i < wifiPassword.length; i++) {
      buffer.write(i < unlockedLetterCount ? wifiPassword[i] : '•');
    }
    return buffer.toString();
  }

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _correctCount = prefs.getInt(_keyCorrectCount) ?? 0;
    _loaded = true;
  }

  /// Registra un acierto. Devuelve la letra recién desbloqueada, si hubo.
  Future<String?> recordCorrectAnswer() async {
    final previousUnlocked = unlockedLetterCount;
    _correctCount++;
    await _persist();
    if (unlockedLetterCount > previousUnlocked) {
      return wifiPassword[unlockedLetterCount - 1];
    }
    return null;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCorrectCount, _correctCount);
  }

  @visibleForTesting
  Future<void> resetForTesting() async {
    _correctCount = 0;
    _loaded = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCorrectCount);
    await load();
  }
}
