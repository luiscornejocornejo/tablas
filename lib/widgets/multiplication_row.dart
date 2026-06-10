import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fila individual de una multiplicación: "7 × 3 = 21".
class MultiplicationRow extends StatelessWidget {
  const MultiplicationRow({
    super.key,
    required this.table,
    required this.multiplier,
    required this.color,
    this.highlight = false,
    this.animate = false,
  });

  final int table;
  final int multiplier;
  final Color color;
  final bool highlight;
  final bool animate;

  int get result => table * multiplier;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: highlight ? color.withValues(alpha: 0.25) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? color : Colors.grey.shade200,
          width: highlight ? 2.5 : 1,
        ),
        boxShadow: highlight
            ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPart('$table', color, 28),
          _buildPart(' × ', Colors.grey.shade600, 24),
          _buildPart('$multiplier', color, 28),
          _buildPart(' = ', Colors.grey.shade600, 24),
          _buildPart('$result', color, 32, bold: true),
        ],
      ),
    );
  }

  Widget _buildPart(String text, Color textColor, double size, {bool bold = false}) {
    return Text(
      text,
      style: GoogleFonts.fredoka(
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        color: textColor,
      ),
    );
  }
}
