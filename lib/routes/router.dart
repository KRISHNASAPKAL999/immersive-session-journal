import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immersive_session_journal/features/home/screens/home_screen.dart';
import 'package:immersive_session_journal/features/ambience/screens/details_screen.dart';
import 'package:immersive_session_journal/features/player/screens/player_screen.dart';
import 'package:immersive_session_journal/features/journal/screens/journal_screen.dart';
import 'package:immersive_session_journal/features/journal/screens/history_screen.dart';

enum AppRoute { home, details, player, journal, history }

final goRouterProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'ambience/:id',
            name: AppRoute.details.name,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return DetailsScreen(ambienceId: id);
            },
          ),
          GoRoute(
            path: 'player/:id',
            name: AppRoute.player.name,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PlayerScreen(ambienceId: id);
            },
          ),
          GoRoute(
            path: 'journal/:ambienceId/:ambienceTitle',
            name: AppRoute.journal.name,
            builder: (context, state) {
              final ambienceId = state.pathParameters['ambienceId']!;
              final ambienceTitle = state.pathParameters['ambienceTitle']!;
              return JournalScreen(
                ambienceId: ambienceId,
                ambienceTitle: Uri.decodeComponent(ambienceTitle),
              );
            },
          ),
          GoRoute(
            path: 'history',
            name: AppRoute.history.name,
            builder: (context, state) => const HistoryScreen(),
          ),
        ],
      ),
    ],
  );
});
