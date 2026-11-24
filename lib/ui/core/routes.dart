/// Locations of the screens.
///
/// The router in `app/` builds its routes from these, pages navigate by them.
/// A link from a notification is one of these locations too.
abstract final class Routes {
  /// The Today tab, the first screen.
  static const today = '/today';

  /// History under Today or the developer menu.
  static const historySegment = 'history';

  /// The user's step history within the Today tab.
  static const history = '$today/$historySegment';

  /// The Catalog tab.
  static const catalog = '/catalog';

  /// Route segment for a progression within the Catalog tab.
  static const progression = ':progressionId';

  /// Path for the chapters of a progression.
  static String progressionLocation(String progressionId) =>
      '$catalog/${Uri.encodeComponent(progressionId)}';

  /// The World tab.
  static const world = '/world';

  /// The Album tab.
  static const album = '/album';

  /// The Settings tab.
  static const settings = '/settings';

  /// A chapter reader on the root navigator.
  static const chapter = '/chapter/:progressionId/:chapterId';

  /// Path for a concrete chapter in the catalog.
  static String chapterLocation(String progressionId, String chapterId) =>
      '/chapter/${Uri.encodeComponent(progressionId)}/'
      '${Uri.encodeComponent(chapterId)}';

  /// The developer menu, over the tabs. Absent in release.
  static const devMenu = '/dev';

  /// The isolated generated history in developer builds.
  static const devHistory = '$devMenu/$historySegment';
}
