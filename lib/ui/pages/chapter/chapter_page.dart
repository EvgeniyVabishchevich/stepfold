import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/chapter/bloc/bloc.dart';
import 'package:walks/ui/pages/chapter/widgets/widgets.dart';
import 'package:walks/ui/theme/theme.dart';

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
    this.onJourneyTilesChanged,
    super.key,
  });

  /// Current chapter contents or a loading or failure state.
  final ChapterState state;

  /// Returns to the previous screen.
  final VoidCallback onBack;

  /// Loads the same chapter again.
  final VoidCallback onRetry;

  /// Reports map tile failures and recovery for the active journey.
  final ValueChanged<JourneyTilesChanged>? onJourneyTilesChanged;

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
              if (state.journey case final journey?) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: JourneyMap(
                      key: ValueKey(journey.progression.id),
                      journey: journey,
                      tilesUnavailable: state.journeyTilesUnavailable,
                      onTilesChanged: onJourneyTilesChanged,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.s24),
              ],
              if (blocks == null || blocks.isEmpty)
                Text(l10n.chapterEmpty, style: theme.textTheme.bodyLarge)
              else
                for (final block in blocks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.s24),
                    child: ChapterBlockView(block: block),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChapterContentFrame extends StatefulWidget {
  const _ChapterContentFrame({
    required this.progressionId,
    required this.chapterId,
  });

  final String progressionId;
  final String chapterId;

  @override
  State<_ChapterContentFrame> createState() => _ChapterContentFrameState();
}

class _ChapterContentFrameState extends State<_ChapterContentFrame> {
  String? _language;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = Localizations.localeOf(context).languageCode;
    if (_language == language) return;
    _language = language;
    _load();
  }

  @override
  void didUpdateWidget(_ChapterContentFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progressionId != oldWidget.progressionId ||
        widget.chapterId != oldWidget.chapterId) {
      _load();
    }
  }

  void _load() => context.read<ChapterBloc>().add(
    LoadChapter(widget.progressionId, widget.chapterId, _language!),
  );

  @override
  Widget build(BuildContext context) => BlocBuilder<ChapterBloc, ChapterState>(
    builder: (context, state) => ChapterView(
      state: state,
      onRetry: _load,
      onJourneyTilesChanged: context.read<ChapterBloc>().add,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(Routes.today);
        }
      },
    ),
  );
}
