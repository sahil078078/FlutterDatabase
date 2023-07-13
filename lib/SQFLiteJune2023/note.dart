const String tableNotes = "notes";

class NoteFields {
  static final List<String> values = [
    // Add all field
    id, isImportant, number, title,
    description, time,
  ];

  static const String id = "_id";
  static const String isImportant = "isImportant";
  static const String number = "number";
  static const String title = "title";
  static const String description = "description";
  static const String time = "time";
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createTime,
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createTime: createTime ?? this.createTime,
      );

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json[NoteFields.id],
        isImportant: json[NoteFields.isImportant] == 1 ? true : false,
        number: json[NoteFields.number],
        title: json[NoteFields.title],
        description: json[NoteFields.description],
        createTime: DateTime.parse(json[NoteFields.time]),
      );

  Map<String, dynamic> toJson() => {
        NoteFields.id: id,
        NoteFields.isImportant:
            isImportant ? 1 : 0, // Store 1 for true and 0 for false
        NoteFields.number: number,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.time: createTime.toIso8601String(),
      };
}
