import 'package:walks/domain/models/catalog_index.dart';
import 'package:walks/domain/models/progression.dart';

/// The length group of [progression]: the first of [groups] whose
/// `maxSteps` its route price fits, or the last group, which has no limit.
///
/// [groups] go from the shortest up, as `CatalogIndex.lengthGroups` does.
/// Throws an [ArgumentError] when [groups] is empty.
LengthGroup lengthOf(Progression progression, List<LengthGroup> groups) {
  if (groups.isEmpty) throw ArgumentError.value(groups, 'groups', 'is empty');
  final price = progression.routePrice;
  for (final group in groups) {
    final max = group.maxSteps;
    if (max == null || price <= max) return group;
  }
  return groups.last;
}
