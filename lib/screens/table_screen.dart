import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tablas_primaria/screens/practice_screen.dart';
import 'package:tablas_primaria/theme/app_theme.dart';
import 'package:tablas_primaria/widgets/multiplication_row.dart';

/// Muestra la tabla completa de un número (×1 hasta ×12).
class TableScreen extends StatefulWidget {
  const TableScreen({super.key, required this.tableNumber});

  final int tableNumber;

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  int? _highlightedRow;

  Color get _color => AppTheme.colorForTable(widget.tableNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla del ${widget.tableNumber}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_color, _color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '${widget.tableNumber}',
                  style: GoogleFonts.fredoka(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Tabla de multiplicar',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: 12,
              itemBuilder: (context, index) {
                final multiplier = index + 1;
                return GestureDetector(
                  onTap: () => setState(() {
                    _highlightedRow = _highlightedRow == multiplier ? null : multiplier;
                  }),
                  child: MultiplicationRow(
                    table: widget.tableNumber,
                    multiplier: multiplier,
                    color: _color,
                    highlight: _highlightedRow == multiplier,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PracticeScreen(focusTable: widget.tableNumber),
          ),
        ),
        backgroundColor: _color,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.quiz_rounded),
        label: Text('Practicar', style: GoogleFonts.fredoka(fontSize: 16)),
      ),
    );
  }
}
