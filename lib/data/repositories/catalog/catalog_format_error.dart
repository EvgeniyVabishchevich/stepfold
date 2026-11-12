/// A catalog file is broken: bad JSON, a missing text, an id that does not
/// match.
///
/// An [Error], not a `CatalogFailure`: it is a bug in the files we ship, so
/// nothing catches it. Tests that read every bundled file find it before
/// release.
final class CatalogFormatError extends Error {
  /// Creates the error for the file at [path].
  CatalogFormatError(this.path, this.message);

  /// The file that is broken.
  final String path;

  /// What is wrong with it.
  final String message;

  @override
  String toString() => 'CatalogFormatError($path): $message';
}
