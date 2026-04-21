import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immersive_session_journal/data/models/ambience.dart';
import 'package:immersive_session_journal/data/models/session_state.dart';
import 'package:immersive_session_journal/data/repositories/session_repository.dart';

final sessionRepositoryProvider = Provider((ref) => SessionRepository());

class SessionNotifier extends StateNotifier<SessionState?> {
  final StateNotifierProviderRef ref;
  Timer? _timer;

  SessionNotifier(this.ref) : super(null);

  Future<void> startSession(Ambience ambience) async {
    state = SessionState(
      ambience: ambience,
      isPlaying: true,
      elapsedSeconds: 0,
      startedAt: DateTime.now(),
    );

    _startTimer();
  }

  void playPause() {
    if (state == null) return;

    state = state!.copyWith(isPlaying: !state!.isPlaying);

    if (state!.isPlaying) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state != null && state!.isPlaying) {
        final newElapsed = state!.elapsedSeconds + 1;

        state = state!.copyWith(elapsedSeconds: newElapsed);

        // Check if session is complete
        if (state!.isSessionComplete) {
          _timer?.cancel();
          state = state!.copyWith(isPlaying: false);
        }

        // Save session state every 5 seconds
        if (newElapsed % 5 == 0) {
          _saveSessionState();
        }
      }
    });
  }

  void seekTo(int seconds) {
    if (state == null) return;
    state = state!.copyWith(elapsedSeconds: seconds);
  }

  Future<void> endSession() async {
    _timer?.cancel();
    await ref.read(sessionRepositoryProvider).clearSessionState();
    state = null;
  }

  Future<void> _saveSessionState() async {
    if (state != null) {
      await ref
          .read(sessionRepositoryProvider)
          .saveSessionState(
            state!.ambience.id,
            state!.elapsedSeconds,
            state!.isPlaying,
          );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState?>((
  ref,
) {
  return SessionNotifier(ref);
});
