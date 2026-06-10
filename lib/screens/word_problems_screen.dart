import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tablas_primaria/data/word_problem_generator.dart';
import 'package:tablas_primaria/models/word_problem.dart';
import 'package:tablas_primaria/theme/app_theme.dart';

/// Módulo de problemas narrados: granja, escuela, etc. (multiplicación 1-12).
class WordProblemsScreen extends StatefulWidget {
  const WordProblemsScreen({super.key});

  @override
  State<WordProblemsScreen> createState() => _WordProblemsScreenState();
}

class _WordProblemsScreenState extends State<WordProblemsScreen>
    with SingleTickerProviderStateMixin {
  final _generator = WordProblemGenerator();
  final _answerController = TextEditingController();
  final _focusNode = FocusNode();

  late WordProblem _problem;
  int _score = 0;
  int _total = 0;
  int _streak = 0;
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
    _problem = _generator.next();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _nextProblem() {
    setState(() {
      _problem = _generator.next();
      _answerController.clear();
      _showFeedback = false;
      _lastAnswerCorrect = null;
    });
    _focusNode.requestFocus();
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_answerController.text.trim());
    if (userAnswer == null) return;

    final correct = userAnswer == _problem.answer;
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

  Color get _accentColor => AppTheme.colorForTable(_problem.groups);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problemas de la Vida Real'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatBadge(
                    icon: Icons.star_rounded,
                    label: 'Aciertos',
                    value: '$_score/$_total',
                    color: AppTheme.secondary,
                  ),
                  _StatBadge(
                    icon: Icons.local_fire_department_rounded,
                    label: 'Racha',
                    value: '$_streak',
                    color: const Color(0xFFFF9F43),
                  ),
                ],
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final shake = sin(_shakeController.value * pi * 8) * 8;
                  return Transform.translate(offset: Offset(shake, 0), child: child);
                },
                child: _StoryCard(problem: _problem, color: _accentColor),
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
                    hintText: 'Tu respuesta',
                    hintStyle: GoogleFonts.nunito(fontSize: 18, color: Colors.grey.shade400),
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
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Comprobar', style: GoogleFonts.fredoka(fontSize: 20)),
                  ),
                ),
              ] else ...[
                _ResultBanner(
                  isCorrect: _lastAnswerCorrect ?? false,
                  problem: _problem,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextProblem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Otro problema', style: GoogleFonts.fredoka(fontSize: 20)),
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

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.problem, required this.color});

  final WordProblem problem;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Text(problem.emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            problem.story,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: const Color(0xFF2D3436),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
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
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
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

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({required this.isCorrect, required this.problem});

  final bool isCorrect;
  final WordProblem problem;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isCorrect ? AppTheme.success : AppTheme.error,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCorrect ? '¡Correcto! ¡Muy bien pensado!' : 'Casi... ¡Sigue intentando!',
                  style: GoogleFonts.fredoka(fontSize: 18),
                ),
              ),
            ],
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 8),
            Text(
              'Respuesta: ${problem.answer} (${problem.hint})',
              style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}
