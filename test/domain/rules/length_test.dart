import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/catalog_index.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/rules/length.dart';

void main() {
  const short = LengthGroup(id: 'short', title: 'Short', maxSteps: 30000);
  const medium = LengthGroup(id: 'medium', title: 'Medium', maxSteps: 80000);
  const long = LengthGroup(id: 'long', title: 'Long');
  const groups = [short, medium, long];

  Progression costing(int price) => Progression(
    id: 'p',
    kind: 'story',
    order: ChapterOrder.strict,
    chapters: [Chapter(id: 'c', price: price)],
  );

  test('a route fits the first group it is not longer than', () {
    expect(lengthOf(costing(21000), groups), short);
    expect(lengthOf(costing(50000), groups), medium);
  });

  test('a route exactly at the limit stays in that group', () {
    expect(lengthOf(costing(30000), groups), short);
    expect(lengthOf(costing(30001), groups), medium);
  });

  test('the group without a limit takes everything longer', () {
    expect(lengthOf(costing(1000000), groups), long);
  });

  test('a new group in the catalog takes its share without a code '
      'change', () {
    const unreal = LengthGroup(id: 'unreal', title: 'Unreal');
    final withUnreal = [short, medium, long.copyWith(maxSteps: 200000), unreal];

    expect(lengthOf(costing(150000), withUnreal).id, 'long');
    expect(lengthOf(costing(500000), withUnreal), unreal);
  });

  test('refuses an empty list of groups', () {
    expect(() => lengthOf(costing(1000), const []), throwsArgumentError);
  });
}
