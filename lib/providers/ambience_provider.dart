import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immersive_session_journal/data/models/ambience.dart';
import 'package:immersive_session_journal/data/repositories/ambience_repository.dart';

final ambienceRepositoryProvider = Provider((ref) => AmbienceRepository());

final allAmbiencesProvider = FutureProvider((ref) async {
  final repo = ref.watch(ambienceRepositoryProvider);
  return repo.fetchAllAmbiences();
});

final searchQueryProvider = StateProvider((ref) => '');
final selectedTagProvider = StateProvider<String?>((ref) => null);

final filteredAmbiencesProvider = FutureProvider((ref) async {
  final ambiences = await ref.watch(allAmbiencesProvider.future);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedTag = ref.watch(selectedTagProvider);
  final repo = ref.watch(ambienceRepositoryProvider);

  var filtered = ambiences;

  if (selectedTag != null) {
    filtered = repo.filterByTag(filtered, selectedTag);
  }

  if (searchQuery.isNotEmpty) {
    filtered = repo.searchAmbiences(filtered, searchQuery);
  }

  return filtered;
});

final ambienceByIdProvider = FutureProvider.family<Ambience?, String>((
  ref,
  id,
) async {
  final repo = ref.watch(ambienceRepositoryProvider);
  return repo.getAmbienceById(id);
});
