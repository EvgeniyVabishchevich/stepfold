import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/history/bloc/history_bloc.dart';
import 'package:walks/ui/pages/history/bloc/history_state.dart';
import 'package:walks/ui/pages/history/widgets/history_editor.dart';
import 'package:walks/ui/pages/history/widgets/history_labels.dart';
import 'package:walks/ui/pages/history/widgets/history_week_card.dart';
import 'package:walks/ui/theme/theme.dart';

/// Step history, reached from Today or from an isolated developer preview.
class HistoryPage extends StatelessWidget {
  /// Creates the page and its bloc.
  const HistoryPage({
    required this.progress,
    required this.catalog,
    required this.addManualSteps,
    required this.updateLock,
    required this.crashReporter,
    this.preview = false,
    super.key,
  });

  /// The repository that holds steps and the manual-entry lock.
  final ProgressRepository progress;

  /// Resolves the titles of the week's openings.
  final Catalog catalog;

  /// Saves a manual addition after validation.
  final AddManualSteps addManualSteps;

  /// Changes the manual-entry lock.
  final UpdateManualEntryLock updateLock;

  /// Reports unexpected storage failures.
  final CrashReporter crashReporter;

  /// Distinguishes the developer dataset from the user's history.
  final bool preview;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => HistoryBloc(
      progress: progress,
      catalog: catalog,
      addManualSteps: addManualSteps,
      updateLock: updateLock,
      crashReporter: crashReporter,
    )..add(const WatchHistory()),
    child: AppResumeListener(
      onResume: (context) =>
          context.read<HistoryBloc>().add(const RefreshHistoryTime()),
      child: _HistoryContent(preview: preview),
    ),
  );
}

class _HistoryContent extends StatefulWidget {
  const _HistoryContent({required this.preview});

  final bool preview;

  @override
  State<_HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<_HistoryContent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<HistoryBloc>().add(
      LoadHistoryCatalog(Localizations.localeOf(context).languageCode),
    );
  }

  Future<void> _edit(BuildContext context, HistoryState state, Day? day) async {
    final bloc = context.read<HistoryBloc>();
    final edit = await showModalBottomSheet<HistoryEdit>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => HistoryEditor(
        progress: state.progress!,
        today: state.today,
        firstDay: state.firstEditableDay,
        editing: day,
      ),
    );
    if (edit != null && !bloc.isClosed) bloc.add(SaveHistoryEdit(edit));
  }

  Future<void> _confirm(BuildContext context, HistoryState state) async {
    final edit = state.confirmation;
    if (edit == null) return;
    final bloc = context.read<HistoryBloc>();
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.historyConfirmTitle),
        content: Text(
          l10n.historyConfirmMessage(
            l10n.stepCount(edit.steps),
            DateFormat.MMMMd(l10n.localeName).format(dateOf(edit.day)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.historyCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.historySave),
          ),
        ],
      ),
    );
    if (bloc.isClosed) return;
    bloc.add(
      confirmed == true
          ? SaveHistoryEdit(edit, confirmed: true)
          : const CancelHistoryEdit(),
    );
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<HistoryBloc, HistoryState>(
    listenWhen: (previous, current) =>
        previous.confirmation != current.confirmation,
    listener: _confirm,
    builder: (context, state) => HistoryView(
      state: state,
      preview: widget.preview,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(widget.preview ? Routes.devMenu : Routes.today);
        }
      },
      onRetry: () => context.read<HistoryBloc>().add(const WatchHistory()),
      onEdit: (day) => _edit(context, state, day),
      onLockChanged: (locked) =>
          context.read<HistoryBloc>().add(ChangeHistoryLock(locked: locked)),
    ),
  );
}

/// The history layout and its loading, empty, and error states.
class HistoryView extends StatelessWidget {
  /// Creates the view with callbacks for the screen actions.
  const HistoryView({
    required this.state,
    required this.onBack,
    required this.onRetry,
    required this.onEdit,
    required this.onLockChanged,
    this.preview = false,
    super.key,
  });

  /// Live data and action feedback.
  final HistoryState state;

  /// Whether this is the isolated developer preview.
  final bool preview;

  /// Returns to the entry point.
  final VoidCallback onBack;

  /// Retries the progress subscription.
  final VoidCallback onRetry;

  /// Opens the editor with a chosen day, or a date picker if null.
  final ValueChanged<Day?> onEdit;

  /// Enables the lock or requests an unlock.
  final ValueChanged<bool> onLockChanged;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: KitTopBar(
      title: preview ? context.l10n.historyPreview : context.l10n.historyTitle,
      backLabel: context.l10n.chapterBack,
      onBack: onBack,
    ),
    body: SafeArea(top: false, child: _body(context)),
  );

  Widget _body(BuildContext context) {
    final l10n = context.l10n;
    if (state.readFailure case final failure?) {
      return ListView(
        children: [
          KitStatePlaceholder.error(
            title: l10n.historyReadError,
            message: failure is StorageFull
                ? l10n.storageFull
                : l10n.todayProgressRetryMessage,
            actionLabel: l10n.retry,
            onAction: onRetry,
          ),
        ],
      );
    }
    final progress = state.progress;
    if (progress == null) {
      return const SingleChildScrollView(child: KitStatePlaceholder.loading());
    }
    final today = state.today;
    final days =
        progress.days.values
            .where(
              (record) =>
                  !record.day.isAfter(today) &&
                  (record.auto != null || record.isManual),
            )
            .toList()
          ..sort((a, b) => b.day.compareTo(a.day));
    final canEdit =
        !state.locked && !state.busy && !today.isBefore(state.firstEditableDay);
    return ListView.builder(
      padding: const EdgeInsets.all(Spacing.s16),
      itemCount: 1 + days.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _header(context, progress, days.isEmpty, canEdit);
        }
        final record = days[index - 1];
        return _HistoryDay(
          record: record,
          today: today,
          onTap: canEdit && !record.day.isBefore(state.firstEditableDay)
              ? () => onEdit(record.day)
              : null,
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    Progress progress,
    bool empty,
    bool canEdit,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final week = historyWeek(progress, state.today);
    return Padding(
      padding: EdgeInsets.only(bottom: empty ? 0 : Spacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.s12,
        children: [
          if (empty && week.openings.isEmpty)
            KitStatePlaceholder.empty(
              title: l10n.historyEmpty,
              message: l10n.historyEmptyMessage,
            )
          else
            HistoryWeekCard(
              week: week,
              today: state.today,
              catalog: state.catalog,
            ),
          if (!state.locked && !state.today.isBefore(state.firstEditableDay))
            KitButton(
              kind: KitButtonKind.primary,
              label: l10n.historyAddSteps,
              onPressed: canEdit ? () => onEdit(null) : null,
            ),
          _LockControl(state: state, onChanged: onLockChanged),
          if (state.writeFailure case final failure?)
            Semantics(
              liveRegion: true,
              child: Text(switch (failure) {
                StorageFull() => l10n.storageFull,
                ManualEntryLocked() => l10n.historyLockOn,
                ManualEntryDayOutOfRange() => l10n.historyDateUnavailable,
                ManualEntryNegative() => l10n.historyInvalidAmount,
                _ => l10n.historyWriteError,
              }, style: TextStyle(color: theme.colorScheme.error)),
            ),
          if (!empty)
            Text(l10n.historyByDay, style: theme.textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _LockControl extends StatelessWidget {
  const _LockControl({required this.state, required this.onChanged});

  final HistoryState state;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final unlockAt = state.progress?.manualEntryLock.unlockAt;
    final waiting = state.locked && unlockAt != null;
    final local = unlockAt?.toLocal();
    final label = waiting
        ? l10n.historyLockUntil(
            DateFormat.MMMMd(l10n.localeName).add_Hm().format(local!),
          )
        : state.locked
        ? l10n.historyLockOnSubtitle
        : l10n.historyLockOff;
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: waiting
          ? Padding(
              padding: const EdgeInsets.all(Spacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label),
                  TextButton(
                    onPressed: state.busy ? null : () => onChanged(true),
                    child: Text(l10n.historyKeepLock),
                  ),
                ],
              ),
            )
          : SwitchListTile(
              key: const Key('history-manual-entry-lock'),
              title: Text(l10n.historyLock),
              subtitle: Text(label),
              value: state.locked,
              onChanged: state.busy ? null : onChanged,
            ),
    );
  }
}

class _HistoryDay extends StatelessWidget {
  const _HistoryDay({
    required this.record,
    required this.today,
    required this.onTap,
  });

  final DaySteps record;
  final Day today;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final numbers = NumberFormat.decimalPattern(l10n.localeName);
    final steps = record.isManual
        ? l10n.historyManualLabel(
            numbers.format(record.auto ?? 0),
            numbers.format(record.manual),
          )
        : l10n.stepCount(record.counted);
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.s8),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          title: Text(historyDayLabel(context, record.day, today)),
          subtitle: Text(
            l10n.historyCountAndDistance(
              steps,
              historyDistance(context, record.counted),
            ),
          ),
          trailing: onTap == null
              ? null
              : Icon(Icons.edit_outlined, semanticLabel: l10n.historyEditTitle),
          onTap: onTap,
        ),
      ),
    );
  }
}
