import 'package:immersive_session_journal/data/models/ambience.dart';

class SessionState {
  final Ambience ambience;
  final bool isPlaying;
  final int elapsedSeconds;
  final DateTime startedAt;

  SessionState({
    required this.ambience,
    this.isPlaying = false,
    this.elapsedSeconds = 0,
    required this.startedAt,
  });

  SessionState copyWith({
    Ambience? ambience,
    bool? isPlaying,
    int? elapsedSeconds,
    DateTime? startedAt,
  }) {
    return SessionState(
      ambience: ambience ?? this.ambience,
      isPlaying: isPlaying ?? this.isPlaying,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  bool get isSessionComplete => elapsedSeconds >= ambience.duration;
}
