import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immersive_session_journal/data/models/session_state.dart';
import 'package:immersive_session_journal/providers/ambience_provider.dart';
import 'package:immersive_session_journal/providers/session_provider.dart';
import 'package:immersive_session_journal/theme/app_theme.dart';

class PlayerScreen extends ConsumerWidget {
  final String ambienceId;

  const PlayerScreen({required this.ambienceId, super.key});

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final ambienceAsync = ref.watch(ambienceByIdProvider(ambienceId));

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.pop();
        }
      },
      child: Scaffold(
        body: ambienceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (ambience) {
            if (ambience == null || session == null) {
              return Center(
                child: Text(
                  'Session not found',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            }

            final progress = session.elapsedSeconds / session.ambience.duration;

            return Stack(
              children: [
                // Background gradient with animation
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        AppColors.secondary.withOpacity(0.15),
                      ],
                    ),
                  ),
                  child: Center(
                    child: BreathingAnimation(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withOpacity(0.3),
                              AppColors.secondary.withOpacity(0.3),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Content
                SafeArea(
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainerHigh,
                                ),
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 28,
                                ),
                              ),
                            ),
                            Text(
                              'Session',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Container(width: 40),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Session info
                      Column(
                        children: [
                          Text(
                            session.ambience.title,
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // Player controls
                          Column(
                            children: [
                              // Play/Pause button
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primaryContainer,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.4),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      ref
                                          .read(sessionProvider.notifier)
                                          .playPause();
                                    },
                                    customBorder: const CircleBorder(),
                                    child: Icon(
                                      session.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 50,
                                      color: AppColors.surface,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 48),
                              // Seek bar
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  children: [
                                    SliderTheme(
                                      data: SliderThemeData(
                                        trackHeight: 4,
                                        thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 10,
                                        ),
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                              overlayRadius: 20,
                                            ),
                                      ),
                                      child: Slider(
                                        value: progress.clamp(0.0, 1.0),
                                        onChanged: (value) {
                                          final newSeconds =
                                              (value *
                                                      session.ambience.duration)
                                                  .toInt();
                                          ref
                                              .read(sessionProvider.notifier)
                                              .seekTo(newSeconds);
                                        },
                                        activeColor: AppColors.primary,
                                        inactiveColor: AppColors.surfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatTime(session.elapsedSeconds),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        Text(
                                          _formatTime(
                                            session.ambience.duration,
                                          ),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      // End Session button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              _showEndSessionDialog(context, ref, session);
                            },
                            child: const Text('End Session'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showEndSessionDialog(
    BuildContext context,
    WidgetRef ref,
    SessionState session,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(
          'End Session?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'You can save your reflection after the session.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(sessionProvider.notifier).endSession();
              context.pop();
              context.pushNamed(
                'journal',
                pathParameters: {
                  'ambienceId': session.ambience.id,
                  'ambienceTitle': Uri.encodeComponent(session.ambience.title),
                },
              );
            },
            child: const Text('End'),
          ),
        ],
      ),
    );
  }
}

class BreathingAnimation extends StatefulWidget {
  final Widget child;

  const BreathingAnimation({required this.child, super.key});

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
