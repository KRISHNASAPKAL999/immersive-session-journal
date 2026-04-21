import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immersive_session_journal/providers/journal_provider.dart';
import 'package:immersive_session_journal/theme/app_theme.dart';

class JournalScreen extends ConsumerStatefulWidget {
  final String ambienceId;
  final String ambienceTitle;

  const JournalScreen({
    required this.ambienceId,
    required this.ambienceTitle,
    super.key,
  });

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _textController = TextEditingController();
  String _selectedMood = 'Calm';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Reflection',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prompt
            Text(
              'What is gently present with you right now?',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 24),
            // Text input
            TextField(
              controller: _textController,
              maxLines: 8,
              minLines: 8,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerHigh,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            // Mood selector
            Text(
              'How do you feel?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['Calm', 'Grounded', 'Energized', 'Sleepy']
                  .map(
                    (mood) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMood = mood;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _selectedMood == mood
                              ? AppColors.primary.withOpacity(0.15)
                              : AppColors.surfaceContainerHigh,
                          border: Border.all(
                            color: _selectedMood == mood
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          mood,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: _selectedMood == mood
                                    ? AppColors.primary
                                    : AppColors.onSurface,
                              ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 48),
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_textController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please write something')),
                    );
                    return;
                  }

                  await ref
                      .read(journalNotifierProvider.notifier)
                      .saveEntry(
                        widget.ambienceId,
                        widget.ambienceTitle,
                        _textController.text,
                        _selectedMood,
                      );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reflection saved!')),
                    );
                    context.pushNamed('history');
                  }
                },
                child: const Text('Save Reflection'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
