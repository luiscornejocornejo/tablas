import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tablas_primaria/theme/app_theme.dart';

/// Modo práctica: preguntas aleatorias con retroalimentación visual.
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key, this.focusTable});

  /// Si se define, las preguntas solo usan esta tabla.
  final int? focusTable;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with SingleTickerProviderStateMixin {
  final _random = Random();
  final _answerController = TextEditingController();
  final _focusNode = FocusNode();

  late int _table;
  late int _multiplier;
  int _score = 0;
  int _streak = 0;
  int _total = 0;
  bool? _lastAnswerCorrect;
  bool _showFeedback = false;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _generateQuestion();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _generateQuestion() {
    if (widget.focusTable != null) {
      _table = widget.focusTable!;
      _multiplier = _random.nextInt(12) + 1;
    } else {
      _table = _random.nextInt(12) + 1;
      _multiplier = _random.nextInt(12) + 1;
    }
    _answerController.clear();
    _showFeedback = false;
    _lastAnswerCorrect = null;
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_answerController.text.trim());
    if (userAnswer == null) return;

    final correct = userAnswer == _table * _multiplier;
    setState(() {
      _total++;
      _lastAnswerCorrect = correct;
      _showFeedback = true;
      if (correct) {
        _score++;
        _streak++;
      } else {
        _streak = 0;
        _shakeController.forward(from: 0);
      }
    });
  }

  void _nextQuestion() {
    setState(_generateQuestion);
    _focusNode.requestFocus();
  }

  Color get _questionColor => AppTheme.colorForTable(_table);

  @override
  Widget build(BuildContext context) {
    final title = widget.focusTable != null
        ? 'Practicar tabla del ${widget.focusTable}'
        : 'Modo Práctica';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
              _ScoreBar(score: _score, total: _total, streak: _streak),
              const Spacer(),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final shake = sin(_shakeController.value * pi * 8) * 8;
                  return Transform.translate(
                    offset: Offset(shake, 0),
                    child: child,
                  );
                },
                child: _QuestionCard(
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
                    hintStyle: GoogleFonts.fredoka(
                      fontSize: 36,
                      color: Colors.grey.shade400,
                    ),
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
                      backgroundColor: _questionColor,
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

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.score,
    required this.total,
    required this.streak,
  });

  final int score;
  final int total;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatChip(
          icon: Icons.star_rounded,
          label: 'Aciertos',
          value: '$score/$total',
          color: AppTheme.secondary,
        ),
        _StatChip(
          icon: Icons.local_fire_department_rounded,
          label: 'Racha',
          value: '$streak',
          color: const Color(0xFFFF9F43),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey.shade600)),
              Text(
                value,
                style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
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
          Text(
            '¿Cuánto es?',
            style: GoogleFonts.nunito(fontSize: 18, color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 16),
          Text(
            '$table × $multiplier',
            style: GoogleFonts.fredoka(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
  const _FeedbackBanner({
    required this.isCorrect,
    required this.correctAnswer,
  });

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
        border: Border.all(
          color: isCorrect ? AppTheme.success : AppTheme.error,
          width: 2,
        ),
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
                  ? '¡Muy bien! ¡Sigue así!'
                  : 'La respuesta correcta es $correctAnswer. ¡Inténtalo otra vez!',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3436),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
