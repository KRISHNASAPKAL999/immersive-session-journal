import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immersive_session_journal/providers/journal_provider.dart';
import 'package:immersive_session_journal/theme/app_theme.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
        return '😌';
      case 'grounded':
        return '🌍';
      case 'energized':
        return '⚡';
      case 'sleepy':
        return '😴';
      default:
        return '✨';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerHigh,
            ),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        title: Text(
          'Journal History',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 64,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No reflections yet',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Start a session to begin journaling',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Home'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final formattedDate = DateFormat(
                'MMM d, yyyy • h:mm a',
              ).format(entry.createdAt);
              final preview = entry.journalText
                  .split('\n')[0]
                  .replaceAll(RegExp(r'\s+'), ' ');

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    _showEntryDetail(context, entry, formattedDate);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.surfaceContainerHigh,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.ambienceTitle,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _getMoodIcon(entry.mood),
                              style: const TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          preview,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEntryDetail(
    BuildContext context,
    dynamic entry,
    String formattedDate,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.ambienceTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  _getMoodIcon(entry.mood),
                  style: const TextStyle(fontSize: 28),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(formattedDate, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            entry.journalText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
