import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tablas_primaria/screens/all_tables_screen.dart';
import 'package:tablas_primaria/screens/practice_screen.dart';
import 'package:tablas_primaria/screens/pro_mode_screen.dart';
import 'package:tablas_primaria/screens/table_screen.dart';
import 'package:tablas_primaria/screens/word_problems_screen.dart';
import 'package:tablas_primaria/theme/app_theme.dart';
import 'package:tablas_primaria/widgets/table_card.dart';

/// Pantalla principal: elegir tabla, practicar o ver todas las tablas.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  children: [
                    const Text('✖️', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text(
                      '¡Aprende las Tablas!',
                      style: GoogleFonts.fredoka(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Elige una tabla del 1 al 12',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _ActionButton(
                      icon: Icons.school_rounded,
                      label: 'Modo Práctica',
                      color: AppTheme.secondary,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PracticeScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActionButton(
                      icon: Icons.workspace_premium_rounded,
                      label: 'Modo Pro',
                      subtitle: '20 aciertos = 1 letra del WiFi',
                      color: const Color(0xFF686DE0),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProModeScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActionButton(
                      icon: Icons.pets_rounded,
                      label: 'Problemas de la Vida Real',
                      subtitle: 'Granja, escuela y más',
                      color: const Color(0xFF6BCB77),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WordProblemsScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActionButton(
                      icon: Icons.grid_view_rounded,
                      label: 'Ver Todas las Tablas',
                      color: AppTheme.primary,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AllTablesScreen()),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Elige tu tabla',
                      style: GoogleFonts.fredoka(
                        fontSize: 22,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final number = index + 1;
                    return TableCard(
                      number: number,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TableScreen(tableNumber: number),
                        ),
                      ),
                    );
                  },
                  childCount: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.fredoka(fontSize: 17)),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
