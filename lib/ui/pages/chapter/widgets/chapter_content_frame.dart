part of '../chapter_page.dart';

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
