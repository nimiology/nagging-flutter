import 'user.dart';

class Nag {
  final int id;
  final User owner;
  final String content;
  final DateTime createdAt;
  final Nag? reply;

  Nag({
    required this.id,
    required this.owner,
    required this.content,
    required this.createdAt,
    this.reply,
  });
}
