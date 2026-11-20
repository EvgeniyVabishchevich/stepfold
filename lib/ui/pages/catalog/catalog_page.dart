import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/catalog/bloc/catalog_bloc.dart';
import 'package:walks/ui/pages/catalog/bloc/catalog_state.dart';
import 'package:walks/ui/pages/catalog/widgets/catalog_row.dart';
import 'package:walks/ui/theme/theme.dart';

/// The list of progressions or the chapters of one progression.
class CatalogPage extends StatelessWidget {
  /// Creates the catalog page and its route-scoped bloc.
  const CatalogPage({
    required this.catalog,
    required this.progress,
    required this.setGoal,
    required this.crashReporter,
    this.progressionId,
    super.key,
  });

  /// Localized catalog index.
  final Catalog catalog;

  /// The current user's opened chapters and goal.
  final ProgressRepository progress;

  /// Saves a chapter as the active goal.
  final SetGoal setGoal;

  /// Reports unexpected storage failures.
  final CrashReporter crashReporter;

  /// The progression opened inside the catalog tab, if any.
  final String? progressionId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CatalogBloc(
      catalog: catalog,
      progress: progress,
      setGoal: setGoal,
      crashReporter: crashReporter,
    )..add(const WatchCatalogProgress()),
    child: _CatalogFrame(progressionId: progressionId),
  );
}

class _CatalogFrame extends StatefulWidget {
  const _CatalogFrame({required this.progressionId});

  final String? progressionId;

  @override
  State<_CatalogFrame> createState() => _CatalogFrameState();
}

class _CatalogFrameState extends State<_CatalogFrame> {
  String? _language;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = Localizations.localeOf(context).languageCode;
    if (language == _language) return;
    _language = language;
    _load();
  }

  void _load() => context.read<CatalogBloc>().add(LoadCatalog(_language!));

  @override
  Widget build(BuildContext context) => BlocBuilder<CatalogBloc, CatalogState>(
    builder: (context, state) => CatalogView(
      state: state,
      progressionId: widget.progressionId,
      onRetry: () {
        if (state.catalogFailure != null) _load();
        if (state.readFailure != null) {
          context.read<CatalogBloc>().add(const WatchCatalogProgress());
        }
      },
      onFilter: (id) => context.read<CatalogBloc>().add(FilterCatalog(id)),
      onOpenProgression: (id) => context.push(Routes.progressionLocation(id)),
      onReadChapter: (goal) => context.push(
        Routes.chapterLocation(goal.progressionId, goal.chapterId),
      ),
      onChooseGoal: (goal) =>
          context.read<CatalogBloc>().add(ChooseCatalogGoal(goal)),
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(Routes.catalog);
        }
      },
    ),
  );
}

/// Catalog layout for a list or a progression detail route.
class CatalogView extends StatelessWidget {
  /// Creates the view from screen state and callbacks.
  const CatalogView({
    required this.state,
    required this.progressionId,
    required this.onRetry,
    required this.onFilter,
    required this.onOpenProgression,
    required this.onReadChapter,
    required this.onChooseGoal,
    required this.onBack,
    super.key,
  });

  /// Current catalog, progress, and feedback.
  final CatalogState state;

  /// Null in the list route.
  final String? progressionId;

  /// Retries the failed read.
  final VoidCallback onRetry;

  /// Selects a different progression length.
  final ValueChanged<String> onFilter;

  /// Opens the progression page.
  final ValueChanged<String> onOpenProgression;

  /// Reads a chapter that is already open.
  final ValueChanged<ChapterGoal> onReadChapter;

  /// Selects an available chapter as the active goal.
  final ValueChanged<ChapterGoal> onChooseGoal;

  /// Returns to the list.
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final id = progressionId;
    return Scaffold(
      appBar: id == null
          ? null
          : KitTopBar(
              title: l10n.tabCatalog,
              backLabel: l10n.chapterBack,
              onBack: onBack,
            ),
      body: SafeArea(
        top: id == null,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.s16),
          children: [
            if (id == null) ...[
              Semantics(
                header: true,
                child: Text(
                  l10n.tabCatalog,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: Spacing.s16),
            ],
            if (state.catalogFailure != null || state.readFailure != null)
              KitStatePlaceholder.error(
                title: l10n.catalogReadError,
                message: state.readFailure is StorageFull
                    ? l10n.storageFull
                    : l10n.catalogRetryMessage,
                actionLabel: l10n.retry,
                onAction: onRetry,
              )
            else if (state.index == null || state.progress == null)
              const KitStatePlaceholder.loading()
            else if (id == null)
              _CatalogList(
                state: state,
                onFilter: onFilter,
                onOpenProgression: onOpenProgression,
              )
            else if (state.visibleProgression(id) case final progression?)
              _ProgressionContent(
                state: state,
                progression: progression,
                onReadChapter: onReadChapter,
                onChooseGoal: onChooseGoal,
              )
            else
              Text(l10n.catalogProgressionUnavailable),
          ],
        ),
      ),
    );
  }
}

class _CatalogList extends StatelessWidget {
  const _CatalogList({
    required this.state,
    required this.onFilter,
    required this.onOpenProgression,
  });

  final CatalogState state;
  final ValueChanged<String> onFilter;
  final ValueChanged<String> onOpenProgression;

  @override
  Widget build(BuildContext context) {
    final index = state.index!;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final groupId = state.lengthId;
    final catalog = state.visibleProgressions.toList();
    final progressions = groupId == null
        ? catalog
        : catalog
              .where((p) => lengthOf(p, index.lengthGroups).id == groupId)
              .toList();
    final kinds = {for (final kind in index.kinds) kind.id: kind.title};
    final fallback = progressions.isEmpty && index.lengthGroups.isNotEmpty
        ? index.lengthGroups
              .where(
                (group) => catalog.any(
                  (progression) =>
                      lengthOf(progression, index.lengthGroups).id == group.id,
                ),
              )
              .firstOrNull
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (index.lengthGroups.isNotEmpty) ...[
          Wrap(
            spacing: Spacing.s8,
            runSpacing: Spacing.s4,
            children: [
              for (final group in index.lengthGroups)
                ChoiceChip(
                  label: Text(group.title),
                  selected: group.id == groupId,
                  showCheckmark: false,
                  backgroundColor: scheme.surface,
                  selectedColor: scheme.primary,
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: group.id == groupId
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                  ),
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  onSelected: (_) => onFilter(group.id),
                ),
            ],
          ),
          const SizedBox(height: Spacing.s16),
        ],
        if (progressions.isEmpty)
          KitStatePlaceholder.empty(
            title: catalog.isEmpty
                ? l10n.catalogEmpty
                : l10n.catalogFilterEmpty,
            message: catalog.isEmpty
                ? l10n.catalogEmptyMessage
                : l10n.catalogFilterEmptyMessage,
            actionLabel: fallback == null ? null : l10n.catalogChangeLength,
            onAction: fallback == null ? null : () => onFilter(fallback.id),
          ),
        for (final progression in progressions) ...[
          CatalogRow(
            onTap: () => onOpenProgression(progression.id),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (kinds[progression.kind] case final kind?)
                        Text(kind, style: theme.textTheme.labelMedium),
                      const SizedBox(height: Spacing.s4),
                      Text(
                        progression.title,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
          const SizedBox(height: Spacing.s12),
        ],
      ],
    );
  }
}

class _ProgressionContent extends StatelessWidget {
  const _ProgressionContent({
    required this.state,
    required this.progression,
    required this.onReadChapter,
    required this.onChooseGoal,
  });

  final CatalogState state;
  final Progression progression;
  final ValueChanged<ChapterGoal> onReadChapter;
  final ValueChanged<ChapterGoal> onChooseGoal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final progress = state.progress!;
    final available = availableChapters(progress, progression).toSet();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(progression.title, style: theme.textTheme.headlineMedium),
        ),
        if (progression.description.isNotEmpty) ...[
          const SizedBox(height: Spacing.s8),
          Text(progression.description, style: theme.textTheme.bodyLarge),
        ],
        const SizedBox(height: Spacing.s16),
        Text(
          progression.order == ChapterOrder.strict
              ? l10n.catalogStrictOrder
              : l10n.catalogFreeOrder,
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: Spacing.s12),
        if (state.saveFailure != null || state.chapterUnavailable) ...[
          Semantics(
            liveRegion: true,
            child: Text(
              switch (state.saveFailure) {
                StorageFull() => l10n.storageFull,
                StorageUnavailable() => l10n.catalogGoalSaveError,
                null => l10n.chapterUnavailable,
              },
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          const SizedBox(height: Spacing.s12),
        ],
        for (final chapter in progression.chapters) ...[
          _ChapterRow(
            chapter: chapter,
            goal: ChapterGoal(
              progressionId: progression.id,
              chapterId: chapter.id,
            ),
            activeGoal: progress.goal,
            opened: progress.isOpened(progression.id, chapter.id),
            available: available.contains(chapter),
            saving: state.saving,
            onRead: onReadChapter,
            onChoose: onChooseGoal,
          ),
          const SizedBox(height: Spacing.s8),
        ],
      ],
    );
  }
}

class _ChapterRow extends StatelessWidget {
  const _ChapterRow({
    required this.chapter,
    required this.goal,
    required this.activeGoal,
    required this.opened,
    required this.available,
    required this.saving,
    required this.onRead,
    required this.onChoose,
  });

  final Chapter chapter;
  final ChapterGoal goal;
  final Goal? activeGoal;
  final bool opened;
  final bool available;
  final bool saving;
  final ValueChanged<ChapterGoal> onRead;
  final ValueChanged<ChapterGoal> onChoose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = StepfoldColors.of(context);
    final selected = !opened && goal == activeGoal;
    final status = switch ((opened, selected, available)) {
      (true, _, _) => l10n.catalogChapterOpened,
      (_, true, _) => l10n.catalogCurrentGoal,
      (_, _, true) => l10n.catalogChooseGoal,
      _ => l10n.catalogChapterLocked,
    };
    final action = switch ((opened, available, selected, saving)) {
      (true, _, _, _) => () => onRead(goal),
      (_, true, false, false) => () => onChoose(goal),
      _ => null,
    };
    return CatalogRow(
      color: selected
          ? scheme.surfaceContainerHighest
          : !opened && !available
          ? colors.surfaceDisabled
          : scheme.surface,
      onTap: action,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(chapter.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: Spacing.s4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  l10n.stepCount(chapter.price),
                  style: theme.textTheme.labelMedium,
                ),
              ),
              const SizedBox(width: Spacing.s8),
              Flexible(
                child: Text(
                  status,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: selected || available
                        ? colors.primaryText
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
