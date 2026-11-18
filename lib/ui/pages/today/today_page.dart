import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/failures/storage_failure.dart';
import 'package:walks/domain/models/app_permission.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_steps.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/medal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/repositories/catalog.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';
import 'package:walks/domain/repositories/progress_repository.dart';
import 'package:walks/domain/rules/streak.dart';
import 'package:walks/domain/use_cases/buy_medal.dart';
import 'package:walks/domain/use_cases/open_chapter.dart';
import 'package:walks/ui/core/app_resume_listener.dart';
import 'package:walks/ui/core/routes.dart';
import 'package:walks/ui/kit/kit_button.dart';
import 'package:walks/ui/kit/kit_progress_bar.dart';
import 'package:walks/ui/kit/kit_state_placeholder.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/home_shell/bloc/step_sync_bloc.dart';
import 'package:walks/ui/pages/today/bloc/today_bloc.dart';
import 'package:walks/ui/theme/dimens.dart';
import 'package:walks/ui/theme/stepfold_colors.dart';

part 'widgets/daily_summary.dart';
part 'widgets/day_heading.dart';
part 'widgets/goal_card.dart';
part 'widgets/today_content.dart';
part 'widgets/today_surfaces.dart';

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
          _Heading(day: state.day, onLongPress: onOpenDevMenu),
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
            _DailySummary(progress: progress, day: state.day),
            const SizedBox(height: Spacing.s16),
            _GoalCard(
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
      PermissionStatus.canRequest => _Notice(
        title: l10n.todayAllowSteps,
        message: l10n.todayAllowStepsMessage,
        actionLabel: l10n.todayAllow,
        onAction: onRequestSteps,
      ),
      PermissionStatus.blocked => _Notice(
        title: l10n.todayStepsBlocked,
        message: l10n.todayStepsBlockedMessage,
        actionLabel: l10n.todayOpenSettings,
        onAction: onOpenStepSettings,
      ),
      PermissionStatus.unavailable => _Notice(
        title: l10n.todayStepsUnavailable,
        message: l10n.todayStepsUnavailableMessage,
      ),
      _ when sync.storageFailure != null || sync.sourceFailure != null =>
        _Notice(
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
