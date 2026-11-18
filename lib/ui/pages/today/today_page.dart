import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/home_shell/bloc/bloc.dart';
import 'package:walks/ui/pages/today/bloc/bloc.dart';
import 'package:walks/ui/pages/today/widgets/widgets.dart';
import 'package:walks/ui/theme/theme.dart';

/// The Today tab and its navigation.
class TodayPage extends StatelessWidget {
  /// Creates the page.
  const TodayPage({
    required this.progress,
    required this.catalog,
    required this.openChapter,
    required this.buyMedal,
    required this.crashReporter,
    required this.canOpenDevMenu,
    super.key,
  });

  /// The user's progress.
  final ProgressRepository progress;

  /// The catalog used to resolve goals.
  final Catalog catalog;

  /// Opens the selected chapter.
  final OpenChapter openChapter;

  /// Buys the selected medal.
  final BuyMedal buyMedal;

  /// Reports unexpected storage failures.
  final CrashReporter crashReporter;

  /// Whether this build exposes the developer menu.
  final bool canOpenDevMenu;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => TodayBloc(
      progress: progress,
      catalog: catalog,
      openChapter: openChapter,
      buyMedal: buyMedal,
      crashReporter: crashReporter,
    ),
    child: AppResumeListener(
      onResume: (context) =>
          context.read<TodayBloc>().add(const RefreshTodayDate()),
      child: _TodayContent(canOpenDevMenu: canOpenDevMenu),
    ),
  );
}

/// The day summary, current goal, and access to the step counter.
class TodayView extends StatelessWidget {
  /// Creates the view.
  const TodayView({
    required this.state,
    required this.sync,
    required this.onOpenCatalog,
    required this.onSpend,
    required this.onRetryProgress,
    required this.onRetryCatalog,
    required this.onRequestSteps,
    required this.onOpenStepSettings,
    required this.onRetrySync,
    this.onOpenDevMenu,
    super.key,
  });

  /// Current progress and catalog.
  final TodayState state;

  /// Availability of automatic steps.
  final StepSyncState sync;

  /// Opens the catalog.
  final VoidCallback onOpenCatalog;

  /// Spends steps on the displayed goal.
  final ValueChanged<Goal> onSpend;

  /// Retries the progress subscription.
  final VoidCallback onRetryProgress;

  /// Reloads the catalog.
  final VoidCallback onRetryCatalog;

  /// Requests permission after the user sees the explanation.
  final VoidCallback onRequestSteps;

  /// Opens settings when the system dialog is blocked.
  final VoidCallback onOpenStepSettings;

  /// Retries sync after a failure.
  final VoidCallback onRetrySync;

  /// Opens the developer menu via a long press on the title.
  final VoidCallback? onOpenDevMenu;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = state.progress;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.all(Spacing.s16),
        children: [
          TodayHeading(day: state.day, onLongPress: onOpenDevMenu),
          const SizedBox(height: Spacing.s16),
          if (state.progressFailure case final failure?)
            KitStatePlaceholder.error(
              title: l10n.todayProgressError,
              message: failure is StorageFull
                  ? l10n.storageFull
                  : l10n.todayProgressRetryMessage,
              actionLabel: l10n.retry,
              onAction: onRetryProgress,
            )
          else if (progress == null)
            const KitStatePlaceholder.loading()
          else ...[
            TodayDailySummary(progress: progress, day: state.day),
            const SizedBox(height: Spacing.s16),
            TodayGoalCard(
              progress: progress,
              state: state,
              onOpenCatalog: onOpenCatalog,
              onRetryCatalog: onRetryCatalog,
              onSpend: onSpend,
            ),
            if (_counterNotice(context) case final notice?) ...[
              const SizedBox(height: Spacing.s16),
              notice,
            ],
          ],
        ],
      ),
    );
  }

  Widget? _counterNotice(BuildContext context) {
    final l10n = context.l10n;
    if (sync.checking) return null;
    return switch (sync.permission) {
      PermissionStatus.canRequest => TodayNotice(
        title: l10n.todayAllowSteps,
        message: l10n.todayAllowStepsMessage,
        actionLabel: l10n.todayAllow,
        onAction: onRequestSteps,
      ),
      PermissionStatus.blocked => TodayNotice(
        title: l10n.todayStepsBlocked,
        message: l10n.todayStepsBlockedMessage,
        actionLabel: l10n.todayOpenSettings,
        onAction: onOpenStepSettings,
      ),
      PermissionStatus.unavailable => TodayNotice(
        title: l10n.todayStepsUnavailable,
        message: l10n.todayStepsUnavailableMessage,
      ),
      _ when sync.storageFailure != null || sync.sourceFailure != null =>
        TodayNotice(
          title: l10n.todayStepSyncError,
          message: sync.storageFailure is StorageFull
              ? l10n.storageFull
              : l10n.todayStepsUnavailableMessage,
          actionLabel: l10n.retry,
          onAction: onRetrySync,
        ),
      _ => null,
    };
  }
}

class _TodayContent extends StatefulWidget {
  const _TodayContent({required this.canOpenDevMenu});

  final bool canOpenDevMenu;

  @override
  State<_TodayContent> createState() => _TodayContentState();
}

class _TodayContentState extends State<_TodayContent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = Localizations.localeOf(context).languageCode;
    context.read<TodayBloc>().add(LoadToday(language));
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<TodayBloc, TodayState>(
    listenWhen: (previous, current) =>
        current.openedChapter != null &&
        current.openedChapter != previous.openedChapter,
    listener: (context, state) {
      final chapter = state.openedChapter!;
      unawaited(
        context.push<void>(
          Routes.chapterLocation(chapter.progressionId, chapter.chapterId),
        ),
      );
    },
    builder: (context, state) => BlocBuilder<StepSyncBloc, StepSyncState>(
      builder: (context, sync) => TodayView(
        state: state,
        sync: sync,
        onOpenCatalog: () => context.go(Routes.catalog),
        onOpenDevMenu: widget.canOpenDevMenu
            ? () => context.push(Routes.devMenu)
            : null,
        onSpend: (goal) =>
            context.read<TodayBloc>().add(SpendOnTodayGoal(goal)),
        onRetryProgress: () =>
            context.read<TodayBloc>().add(const RetryTodayProgress()),
        onRetryCatalog: () =>
            context.read<TodayBloc>().add(const RetryTodayCatalog()),
        onRequestSteps: () =>
            context.read<StepSyncBloc>().add(const RequestStepPermission()),
        onOpenStepSettings: () =>
            context.read<StepSyncBloc>().add(const OpenStepSettings()),
        onRetrySync: () =>
            context.read<StepSyncBloc>().add(const CheckStepSync()),
      ),
    ),
  );
}
