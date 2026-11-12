import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/models/progression.dart';

/// The day the app was installed in domain tests.
final installDay = Day(2026, 11, 1);

/// The moment rules act at in domain tests.
final now = DateTime.utc(2026, 11, 12, 10);

/// Progress right after install.
final start = Progress(installDay: installDay);

/// [start] with [steps] counted on the install day.
Progress withSteps(int steps) => start.recordAutoSteps(installDay, steps);

/// Three chapters, opened one by one: 1 000 + 5 000 + 5 000 steps.
const strict = Progression(
  id: 'story',
  kind: 'story',
  order: ChapterOrder.strict,
  chapters: [
    Chapter(id: 'c1', price: 1000),
    Chapter(id: 'c2', price: 5000),
    Chapter(id: 'c3', price: 5000),
  ],
);

/// Two chapters, opened in any order: 1 000 + 2 000 steps.
const free = Progression(
  id: 'trip',
  kind: 'journey',
  order: ChapterOrder.free,
  chapters: [
    Chapter(id: 't1', price: 1000),
    Chapter(id: 't2', price: 2000),
  ],
);
