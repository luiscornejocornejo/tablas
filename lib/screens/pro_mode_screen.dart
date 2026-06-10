import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tablas_primaria/services/pro_mode_service.dart';
import 'package:tablas_primaria/theme/app_theme.dart';

/// Modo Pro: preguntas difíciles, contador persistente y letras del WiFi cada 20 aciertos.
class ProModeScreen extends StatefulWidget {
  const ProModeScreen({super.key});

  @override
  State<ProModeScreen> createState() => _ProModeScreenState();
}

class _ProModeScreenState extends State<ProModeScreen>
    with SingleTickerProviderStateMixin {
  final _random = Random();
  final _answerController = TextEditingController();
  final _focusNode = FocusNode();
  final _proService = ProModeService.instance;

  late int _table;
  late int _multiplier;
  int _sessionScore = 0;
  int _sessionTotal = 0;
  int _streak = 0;
  bool? _lastAnswerCorrect;
  bool _showFeedback = false;
  bool _loading = true;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _proService.load();
    _generateQuestion();
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _answerController.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _generateQuestion() {
    _table = _random.nextInt(12) + 1;
    _multiplier = _random.nextInt(12) + 1;
    _answerController.clear();
    _showFeedback = false;
    _lastAnswerCorrect = null;
  }

  Future<void> _checkAnswer() async {
    final userAnswer = int.tryParse(_answerController.text.trim());
    if (userAnswer == null) return;

    final correct = userAnswer == _table * _multiplier;
    String? unlockedLetter;

    if (correct) {
      unlockedLetter = await _proService.recordCorrectAnswer();
    }

    if (!mounted) return;

    setState(() {
      _sessionTotal++;
      _lastAnswerCorrect = correct;
      _showFeedback = true;
      if (correct) {
        _sessionScore++;
        _streak++;
      } else {
        _streak = 0;
        _shakeController.forward(from: 0);
      }
    });

    if (unlockedLetter != null) {
      await _showLetterUnlockedDialog(unlockedLetter);
    }
  }

  Future<void> _showLetterUnlockedDialog(String letter) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '¡Letra desbloqueada!',
                style: GoogleFonts.fredoka(fontSize: 22),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Llegaste a ${_proService.correctCount} aciertos en Modo Pro.',
              style: GoogleFonts.nunito(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD93D),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Text(
                letter.toUpperCase(),
                style: GoogleFonts.fredoka(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Contraseña: ${_proService.maskedPassword}',
              style: GoogleFonts.fredoka(
                fontSize: 24,
                letterSpacing: 4,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('¡Genial!', style: GoogleFonts.fredoka(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    setState(_generateQuestion);
    _focusNode.requestFocus();
  }

  Color get _questionColor => AppTheme.colorForTable(_table);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Pro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _ProProgressCard(service: _proService),
              const SizedBox(height: 12),
              _SessionStats(
                sessionScore: _sessionScore,
                sessionTotal: _sessionTotal,
                streak: _streak,
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final shake = sin(_shakeController.value * pi * 8) * 8;
                  return Transform.translate(offset: Offset(shake, 0), child: child);
                },
                child: _ProQuestionCard(
                  table: _table,
                  multiplier: _multiplier,
                  color: _questionColor,
                  showFeedback: _showFeedback,
                  isCorrect: _lastAnswerCorrect,
                ),
              ),
              const SizedBox(height: 32),
              if (!_showFeedback) ...[
                TextField(
                  controller: _answerController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '?',
                    hintStyle: GoogleFonts.fredoka(fontSize: 36, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  onSubmitted: (_) => _checkAnswer(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF686DE0),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Comprobar', style: GoogleFonts.fredoka(fontSize: 20)),
                  ),
                ),
              ] else ...[
                _FeedbackBanner(
                  isCorrect: _lastAnswerCorrect ?? false,
                  correctAnswer: _table * _multiplier,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Siguiente', style: GoogleFonts.fredoka(fontSize: 20)),
                  ),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProProgressCard extends StatelessWidget {
  const _ProProgressCard({required this.service});

  final ProModeService service;

  @override
  Widget build(BuildContext context) {
    final progress = service.isPasswordComplete
        ? 1.0
        : service.progressToNextLetter / ProModeService.answersPerLetter;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF686DE0), Color(0xFF4834D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF686DE0).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wifi_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Premio WiFi',
                style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white),
              ),
              const Spacer(),
              Text(
                '${service.correctCount} aciertos',
                style: GoogleFonts.nunito(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            service.maskedPassword,
            style: GoogleFonts.fredoka(
              fontSize: 28,
              letterSpacing: 6,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (!service.isPasswordComplete) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.white24,
                color: const Color(0xFFFFD93D),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${service.progressToNextLetter}/${ProModeService.answersPerLetter} '
              'para la siguiente letra',
              style: GoogleFonts.nunito(fontSize: 13, color: Colors.white70),
            ),
          ] else
            Text(
              '¡Completaste la contraseña!',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: const Color(0xFFFFD93D),
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class _SessionStats extends StatelessWidget {
  const _SessionStats({
    required this.sessionScore,
    required this.sessionTotal,
    required this.streak,
  });

  final int sessionScore;
  final int sessionTotal;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _MiniStat(label: 'Sesión', value: '$sessionScore/$sessionTotal'),
        _MiniStat(label: 'Racha', value: '$streak'),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey.shade600)),
          Text(value, style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ProQuestionCard extends StatelessWidget {
  const _ProQuestionCard({
    required this.table,
    required this.multiplier,
    required this.color,
    required this.showFeedback,
    required this.isCorrect,
  });

  final int table;
  final int multiplier;
  final Color color;
  final bool showFeedback;
  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'MODO PRO',
              style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white, letterSpacing: 2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$table × $multiplier',
            style: GoogleFonts.fredoka(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          if (showFeedback && isCorrect == true) ...[
            const SizedBox(height: 16),
            const Text('🎉', style: TextStyle(fontSize: 40)),
          ],
        ],
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.isCorrect, required this.correctAnswer});

  final bool isCorrect;
  final int correctAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppTheme.success.withValues(alpha: 0.15)
            : AppTheme.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCorrect ? AppTheme.success : AppTheme.error, width: 2),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isCorrect ? AppTheme.success : AppTheme.error,
            size: 36,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isCorrect
                  ? '¡Excelente! Sumas un acierto al contador Pro.'
                  : 'La respuesta correcta es $correctAnswer.',
              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
