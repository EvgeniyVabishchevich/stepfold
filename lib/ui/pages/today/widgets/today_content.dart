part of '../today_page.dart';

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
