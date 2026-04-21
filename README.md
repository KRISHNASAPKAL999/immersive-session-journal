# Immersive Session Journal

A calming, minimal meditation and relaxation app built with Flutter. Explore ambiences, start immersive sessions, and journal your reflections—all designed with clean architecture and thoughtful UX in mind.

## Features

- **Ambience Library**: Browse a curated collection of 6 ambiences with intelligent search and filtering
- **Smart Filtering**: Search by keyword and filter by mood (Focus, Calm, Sleep, Reset)
- **Player Screen**: Full-screen immersive session with breathing animation, seek bar, and session timer
- **Mini Player**: Persistent floating player that appears when navigating away
- **Journal Reflection**: Post-session journaling with mood selection and text input
- **History**: View all saved reflections with date, ambience, mood, and preview
- **Persistence**: All journal entries and session state stored locally with Hive

## Project Structure

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart                 # Material 3 theme with design tokens
├── data/
│   ├── models/
│   │   ├── ambience.dart
│   │   ├── journal_entry.dart         # Hive-annotated model
│   │   └── session_state.dart
│   └── repositories/
│       ├── ambience_repository.dart
│       ├── journal_repository.dart
│       └── session_repository.dart
├── providers/
│   ├── ambience_provider.dart         # Riverpod providers
│   ├── session_provider.dart
│   └── journal_provider.dart
├── routes/
│   └── router.dart                    # GoRouter configuration
├── features/
│   ├── home/screens/home_screen.dart
│   ├── ambience/screens/details_screen.dart
│   ├── player/screens/player_screen.dart
│   └── journal/screens/
│       ├── journal_screen.dart
│       └── history_screen.dart
├── shared/widgets/
│   ├── ambience_card.dart
│   └── mini_player.dart
└── assets/ambiences.json
```

## Architecture

### State Management: Riverpod
- Type-safe reactive state with compile-time guarantees
- Provider composition for complex filters (search + tag)
- FutureProvider for async data loading with built-in error states
- StateNotifierProvider for session timer management

### Persistence: Hive
- TypeSafe models with code generation
- Zero-config setup for journal entries
- Session state recovery on app restart

### Data Flow
```
UI Widget → Provider (State) → Repository → Data Source (JSON/Hive)
```

### Navigation: GoRouter
- Type-safe named routes with path parameters
- Deep linking support
- Nested routes for home > ambience > player flow

## Code Quality

✅ **No giant files**: Modular structure with focused responsibilities
✅ **Reusable widgets**: AmbienceCard, MiniPlayer are composable
✅ **Loading/error states**: All async operations handle three states
✅ **Clean separation**: Data, state, and UI completely decoupled
✅ **Responsive design**: Works on phones (small to large)

## How to Run

### Prerequisites
- Flutter 3.9.2+
- Dart 3.9.2+

### Setup
```bash
cd immersive_session_journal
flutter pub get
dart run build_runner build  # Generate Hive adapters
flutter run
```

### Build APK
```bash
flutter build apk --release
```

## Key Packages

| Package | Purpose |
|---------|---------|
| `riverpod` | Type-safe reactive state management |
| `hive_flutter` | NoSQL local persistence, zero-config |
| `go_router` | Navigation with deep linking |
| `audio_players` | Audio playback (ready for future audio assets) |
| `intl` | Date/time formatting |
| `uuid` | Unique ID generation for entries |

## Bonus Feature: Session State Persistence

When the user exits the player while a session is active:
- Current session state is saved to Hive every 5 seconds
- Mini player appears on home/details screens
- Tapping mini player resumes the session
- On app restart, if a session was interrupted, its state is recovered

## Tradeoffs & Future Work (2+ days)

1. **Real Audio Playback** - Load MP3s from assets, manage audio lifecycle
2. **Haptic Feedback** - Vibration on button press and session completion
3. **Accessibility** - Larger text options, semantic labels, high contrast mode
4. **Advanced Features** - Favorites, feature-based filtering, session analytics
5. **Polish** - Hero animations, skeleton loaders, waveform visualization

## Design System

Implements "The Ethereal Sanctuary":
- **Dark mode** optimized for evening use
- **Colors**: Botanical green (#adcfad), atmospheric blue (#92b4cc)
- **Typography**: Manrope for warm, geometric feel
- **Spacing**: 24px base unit for generous breathing room
- **Shadows**: Diffused ambient shadows (40-60px blur, 4-8% opacity)
- **Corners**: Soft 12-24px border radius throughout

---

**Built for calm, focused moments ✨**
