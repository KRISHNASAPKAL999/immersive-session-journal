import 'package:hive/hive.dart';
import 'package:immersive_session_journal/data/models/journal_entry.dart';
import 'package:uuid/uuid.dart';

class JournalRepository {
  static const String _boxName = 'journal_entries';

  Future<void> saveEntry(
    String ambienceId,
    String ambienceTitle,
    String journalText,
    String mood,
  ) async {
    final box = Hive.box<JournalEntry>(_boxName);
    final entry = JournalEntry(
      id: const Uuid().v4(),
      ambienceId: ambienceId,
      ambienceTitle: ambienceTitle,
      journalText: journalText,
      mood: mood,
      createdAt: DateTime.now(),
    );
    await box.add(entry);
  }

  Future<List<JournalEntry>> getAllEntries() async {
    final box = Hive.box<JournalEntry>(_boxName);
    final entries = box.values.toList();
    // Sort by date descending
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<void> deleteEntry(String id) async {
    final box = Hive.box<JournalEntry>(_boxName);
    final index = box.values.toList().indexWhere((entry) => entry.id == id);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  Future<int> getEntryCount() async {
    final box = Hive.box<JournalEntry>(_boxName);
    return box.length;
  }
}
