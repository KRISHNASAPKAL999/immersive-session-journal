import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immersive_session_journal/data/models/journal_entry.dart';
import 'package:immersive_session_journal/data/repositories/journal_repository.dart';

final journalRepositoryProvider = Provider((ref) => JournalRepository());

final journalEntriesProvider = FutureProvider((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getAllEntries();
});

class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final JournalRepository _repository;

  JournalNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAllEntries());
  }

  Future<void> saveEntry(
    String ambienceId,
    String ambienceTitle,
    String journalText,
    String mood,
  ) async {
    try {
      await _repository.saveEntry(ambienceId, ambienceTitle, journalText, mood);
      // Refresh entries
      await _loadEntries();
    } catch (e) {
      print('Error saving entry: $e');
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      await _repository.deleteEntry(id);
      await _loadEntries();
    } catch (e) {
      print('Error deleting entry: $e');
    }
  }
}

final journalNotifierProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<List<JournalEntry>>>((
      ref,
    ) {
      final repo = ref.watch(journalRepositoryProvider);
      return JournalNotifier(repo);
    });
