import 'package:uuid/uuid.dart';

class Subnote {
  final String id;
  final String noteId; // parent note ID
  final String text;
  final bool isDone;
  final DateTime createdAt;

  Subnote({
    String? id,
    required this.noteId,
    required this.text,
    this.isDone = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Subnote copyWith({
    String? text,
    bool? isDone,
  }) {
    return Subnote(
      id: id,
      noteId: noteId,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noteId': noteId,
      'text': text,
      'isDone': isDone ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Subnote.fromMap(Map<String, dynamic> map) {
    return Subnote(
      id: map['id'],
      noteId: map['noteId'],
      text: map['text'],
      isDone: map['isDone'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
