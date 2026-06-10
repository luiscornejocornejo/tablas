import 'dart:math';

import 'package:tablas_primaria/models/word_problem.dart';

typedef _Template = ({
  String emoji,
  String place,
  String groupUnit,
  String itemUnit,
});

/// Genera problemas narrados (granja, escuela, etc.) con tablas del 1 al 12.
class WordProblemGenerator {
  WordProblemGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const _templates = <_Template>[
    (emoji: '🐰', place: 'granja', groupUnit: 'jaulas', itemUnit: 'conejos'),
    (emoji: '🐔', place: 'granja', groupUnit: 'gallineros', itemUnit: 'gallinas'),
    (emoji: '🐄', place: 'campo', groupUnit: 'corrales', itemUnit: 'vacas'),
    (emoji: '📚', place: 'biblioteca', groupUnit: 'estantes', itemUnit: 'libros'),
    (emoji: '🍪', place: 'panadería', groupUnit: 'bandejas', itemUnit: 'galletas'),
    (emoji: '🌻', place: 'huerto', groupUnit: 'hileras', itemUnit: 'plantas'),
    (emoji: '🪑', place: 'aula', groupUnit: 'mesas', itemUnit: 'sillas'),
    (emoji: '✏️', place: 'escuela', groupUnit: 'cajas', itemUnit: 'lápices'),
    (emoji: '🚌', place: 'colegio', groupUnit: 'buses', itemUnit: 'asientos'),
    (emoji: '🎈', place: 'fiesta', groupUnit: 'ramilletes', itemUnit: 'globos'),
    (emoji: '🥚', place: 'granja', groupUnit: 'canastas', itemUnit: 'huevos'),
    (emoji: '🐟', place: 'mercado', groupUnit: 'peceras', itemUnit: 'peces'),
  ];

  WordProblem next() {
    final template = _templates[_random.nextInt(_templates.length)];
    final groups = _random.nextInt(12) + 1;
    final perGroup = _random.nextInt(12) + 1;

    final story =
        'En una ${template.place} hay $groups ${template.groupUnit}. '
        'En cada ${_singular(template.groupUnit)} hay $perGroup ${template.itemUnit}. '
        '¿Cuántos ${template.itemUnit} hay en total?';

    return WordProblem(
      story: story,
      groups: groups,
      perGroup: perGroup,
      groupLabel: template.groupUnit,
      itemLabel: template.itemUnit,
      emoji: template.emoji,
    );
  }

  String _singular(String word) {
    if (word.endsWith('es') && word.length > 3) {
      return word.substring(0, word.length - 2);
    }
    if (word.endsWith('s')) {
      return word.substring(0, word.length - 1);
    }
    return word;
  }
}
