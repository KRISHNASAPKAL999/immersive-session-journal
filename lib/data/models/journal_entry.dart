import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String ambienceId;

  @HiveField(2)
  late String ambienceTitle;

  @HiveField(3)
  late String journalText;

  @HiveField(4)
  late String mood; // Calm, Grounded, Energized, Sleepy

  @HiveField(5)
  late DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.ambienceId,
    required this.ambienceTitle,
    required this.journalText,
    required this.mood,
    required this.createdAt,
  });
}
