import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/models/chapter_content.dart';
import 'package:walks/domain/repositories/catalog.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';
import 'package:walks/domain/repositories/progress_repository.dart';
import 'package:walks/ui/core/catalog_image.dart';
import 'package:walks/ui/core/routes.dart';
import 'package:walks/ui/kit/kit_state_placeholder.dart';
import 'package:walks/ui/kit/kit_top_bar.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/chapter/bloc/chapter_bloc.dart';
import 'package:walks/ui/theme/dimens.dart';

part 'widgets/chapter_block_view.dart';
part 'widgets/chapter_content_frame.dart';

/// Full-screen reader for the chapter identified by the route.
class ChapterPage extends StatelessWidget {
  /// Creates the page.
  const ChapterPage({
    required this.progressionId,
    required this.chapterId,
    required this.catalog,
    required this.progress,
    required this.crashReporter,
    super.key,
  });

  /// Catalog progression.
  final String progressionId;

  /// Chapter in the progression.
  final String chapterId;

  /// Provides chapter titles and content.
  final Catalog catalog;

  /// Records which chapters the user opened.
  final ProgressRepository progress;

  /// Reports unexpected storage failures.
  final CrashReporter crashReporter;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ChapterBloc(
      catalog: catalog,
      progress: progress,
      crashReporter: crashReporter,
    ),
    child: _ChapterContentFrame(
      progressionId: progressionId,
      chapterId: chapterId,
    ),
  );
}

/// The reader shows catalog blocks in their original order.
class ChapterView extends StatelessWidget {
  /// Creates the reader layout.
  const ChapterView({
    required this.state,
    required this.onBack,
    required this.onRetry,
    super.key,
  });

  /// Current chapter contents or a loading or failure state.
  final ChapterState state;

  /// Returns to the previous screen.
  final VoidCallback onBack;

  /// Loads the same chapter again.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final blocks = state.content?.blocks
        .where(
          (block) => switch (block) {
            Paragraph(:final text) => text.trim().isNotEmpty,
            ImageBlock() => true,
            MapPoint(:final label) => label.trim().isNotEmpty,
          },
        )
        .toList();
    return Scaffold(
      appBar: KitTopBar(
        title: l10n.chapterReader,
        backLabel: l10n.chapterBack,
        onBack: onBack,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.s24),
          children: [
            if (state.loading)
              const KitStatePlaceholder.loading()
            else if (state.retryable)
              KitStatePlaceholder.error(
                title: l10n.chapterReadError,
                message: state.storageFull
                    ? l10n.storageFull
                    : l10n.chapterRetryMessage,
                actionLabel: l10n.retry,
                onAction: onRetry,
              )
            else if (state.unavailable)
              Text(l10n.chapterUnavailable, style: theme.textTheme.titleLarge)
            else ...[
              if (state.progressionTitle case final title?)
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              if (state.chapterTitle case final title?) ...[
                const SizedBox(height: Spacing.s8),
                Semantics(
                  header: true,
                  child: Text(title, style: theme.textTheme.headlineMedium),
                ),
              ],
              const SizedBox(height: Spacing.s32),
              if (blocks == null || blocks.isEmpty)
                Text(l10n.chapterEmpty, style: theme.textTheme.bodyLarge)
              else
                for (final block in blocks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.s24),
                    child: _ChapterBlockView(block: block),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
