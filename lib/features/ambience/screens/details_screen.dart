import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immersive_session_journal/providers/ambience_provider.dart';
import 'package:immersive_session_journal/providers/session_provider.dart';
import 'package:immersive_session_journal/shared/widgets/mini_player.dart';
import 'package:immersive_session_journal/theme/app_theme.dart';

class DetailsScreen extends ConsumerWidget {
  final String ambienceId;

  const DetailsScreen({required this.ambienceId, super.key});

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (secs == 0) return '${minutes}m';
    return '${minutes}m ${secs}s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ambienceAsync = ref.watch(ambienceByIdProvider(ambienceId));
    final session = ref.watch(sessionProvider);

    return Scaffold(
      body: ambienceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (ambience) {
          if (ambience == null) {
            return Center(
              child: Text(
                'Ambience not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          }

          return Stack(
            children: [
              /// 🔥 ONLY CHANGE 1: Add bottom padding
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.4),
                            AppColors.secondary.withOpacity(0.4),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background image
                          Image.network(
                            ambience.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container();
                            },
                          ),
                          // Overlay gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.2),
                                  Colors.black.withOpacity(0.4),
                                ],
                              ),
                            ),
                          ),
                          // Back button
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: GestureDetector(
                                onTap: () => context.pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surface.withOpacity(0.5),
                                  ),
                                  child: const Icon(Icons.arrow_back, size: 24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content (unchanged)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  ambience.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineLarge,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.primary.withOpacity(0.2),
                                ),
                                child: Text(
                                  ambience.tag,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: AppColors.onSurfaceVariant,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDuration(ambience.duration),
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Text(
                            ambience.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 32),

                          Text(
                            'Features',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ambience.features
                                .map(
                                  (feature) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.surfaceContainerHigh,
                                    ),
                                    child: Text(
                                      feature,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔥 ONLY CHANGE 2: SafeArea + better bottom spacing
              Positioned(
                bottom: session != null ? 110 : 24,
                left: 24,
                right: 24,
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(sessionProvider.notifier)
                            .startSession(ambience);
                        context.pushNamed(
                          'player',
                          pathParameters: {'id': ambience.id},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Start Session'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),

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
}
