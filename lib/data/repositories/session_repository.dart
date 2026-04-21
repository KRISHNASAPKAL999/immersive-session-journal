import 'package:hive/hive.dart';

class SessionRepository {
  static const String _boxName = 'session_state';

  Future<void> saveSessionState(
    String ambienceId,
    int elapsedSeconds,
    bool isPlaying,
  ) async {
    final box = Hive.box(_boxName);
    await box.putAll({
      'ambienceId': ambienceId,
      'elapsedSeconds': elapsedSeconds,
      'isPlaying': isPlaying,
      'savedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> getSessionState() async {
    final box = Hive.box(_boxName);
    if (box.isEmpty) return null;

    return {
      'ambienceId': box.get('ambienceId'),
      'elapsedSeconds': box.get('elapsedSeconds'),
      'isPlaying': box.get('isPlaying'),
      'savedAt': box.get('savedAt'),
    };
  }

  Future<void> clearSessionState() async {
    final box = Hive.box(_boxName);
    await box.clear();
  }
}
