import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immersive_session_journal/providers/ambience_provider.dart';
import 'package:immersive_session_journal/providers/session_provider.dart';
import 'package:immersive_session_journal/shared/widgets/ambience_card.dart';
import 'package:immersive_session_journal/shared/widgets/mini_player.dart';
import 'package:immersive_session_journal/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAmbiences = ref.watch(filteredAmbiencesProvider);
    final session = ref.watch(sessionProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pushNamed('history');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Find your perfect ambience',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.surfaceContainerHigh,
                          ),
                          child: const Icon(Icons.history, size: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
                decoration: InputDecoration(
                  hintText: 'Search ambiences...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tag filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: ['Focus', 'Calm', 'Sleep', 'Reset']
                    .map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Consumer(
                          builder: (context, ref2, _) {
                            final selectedTag = ref2.watch(selectedTagProvider);
                            final isSelected = selectedTag == tag;

                            return FilterChip(
                              label: Text(tag),
                              selected: isSelected,
                              onSelected: (selected) {
                                ref2.read(selectedTagProvider.notifier).state =
                                    selected ? tag : null;
                              },
                              backgroundColor: AppColors.surfaceContainerHigh,
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.onSurface,
                              ),
                              side: BorderSide.none,
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Ambiences list
            Expanded(
              child: filteredAmbiences.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (ambiences) {
                  if (ambiences.isEmpty) {
                    return _buildEmptyState(context, ref);
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: ambiences.length,
                    itemBuilder: (context, index) {
                      final ambience = ambiences[index];
                      return AmbienceCard(
                        ambience: ambience,
                        onTap: () {
                          context.pushNamed(
                            'details',
                            pathParameters: {'id': ambience.id},
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Mini player
      bottomNavigationBar: session != null
          ? MiniPlayer(
              onTap: () {
                context.pushNamed(
                  'player',
                  pathParameters: {'id': session.ambience.id},
                );
              },
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 24),
            Text(
              'No ambiences found',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(searchQueryProvider.notifier).state = '';
                ref.read(selectedTagProvider.notifier).state = null;
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
