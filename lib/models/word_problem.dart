/// Problema de multiplicación planteado como situación cotidiana.
class WordProblem {
  const WordProblem({
    required this.story,
    required this.groups,
    required this.perGroup,
    required this.groupLabel,
    required this.itemLabel,
    required this.emoji,
  });

  final String story;
  final int groups;
  final int perGroup;
  final String groupLabel;
  final String itemLabel;
  final String emoji;

  int get answer => groups * perGroup;

  String get hint => '$groups × $perGroup = $answer';
}
