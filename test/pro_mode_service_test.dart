import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tablas_primaria/services/pro_mode_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ProModeService.instance.resetForTesting();
  });

  test('desbloquea una letra cada 20 aciertos', () async {
    final service = ProModeService.instance;

    String? unlocked;
    for (var i = 0; i < 20; i++) {
      unlocked = await service.recordCorrectAnswer();
    }

    expect(unlocked, 'c');
    expect(service.unlockedLetterCount, 1);
    expect(service.maskedPassword, 'c${'•' * (ProModeService.wifiPassword.length - 1)}');
  });
}
