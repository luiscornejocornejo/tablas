import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tablas_primaria/theme/app_theme.dart';

/// Tarjeta táctil grande para elegir una tabla (1-12).
class TableCard extends StatelessWidget {
  const TableCard({
    super.key,
    required this.number,
    required this.onTap,
  });

  final int number;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.colorForTable(number);

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: color.withValues(alpha: 0.5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$number',
                style: GoogleFonts.fredoka(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
              ),
              Text(
                '×',
                style: GoogleFonts.fredoka(
                  fontSize: 20,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
