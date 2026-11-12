/// Why the catalog could not give what was asked.
///
/// A broken catalog file is not one of these: it is a bug, thrown as an
/// `Error` and caught by tests before release.
sealed class CatalogFailure implements Exception {
  const CatalogFailure();
}

/// The catalog could not be loaded: for example, no network and nothing
/// saved yet. The catalog built into the app never throws it.
final class CatalogUnavailable extends CatalogFailure {
  /// Creates the failure.
  const CatalogUnavailable();

  @override
  String toString() => 'CatalogUnavailable';
}

/// The catalog has no chapter [chapterId] in progression [progressionId].
final class ChapterNotFound extends CatalogFailure {
  /// Creates the failure.
  const ChapterNotFound(this.progressionId, this.chapterId);

  /// The progression asked for.
  final String progressionId;

  /// The chapter asked for.
  final String chapterId;

  @override
  String toString() => 'ChapterNotFound($progressionId/$chapterId)';
}
