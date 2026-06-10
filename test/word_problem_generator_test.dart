import 'package:flutter_test/flutter_test.dart';
import 'package:tablas_primaria/data/word_problem_generator.dart';

void main() {
  test('genera problemas con respuesta correcta entre 1 y 144', () {
    final generator = WordProblemGenerator();
    for (var i = 0; i < 20; i++) {
      final problem = generator.next();
      expect(problem.groups, inInclusiveRange(1, 12));
      expect(problem.perGroup, inInclusiveRange(1, 12));
      expect(problem.answer, problem.groups * problem.perGroup);
      expect(problem.story, isNotEmpty);
    }
  });
}
