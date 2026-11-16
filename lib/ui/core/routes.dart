/// Locations of the screens.
///
/// The router in `app/` builds its routes from these, pages navigate by them.
/// A link from a notification is one of these locations too.
abstract final class Routes {
  /// The Today tab, the first screen.
  static const today = '/today';

  /// The Catalog tab.
  static const catalog = '/catalog';

  /// The World tab.
  static const world = '/world';

  /// The Album tab.
  static const album = '/album';

  /// The developer menu, over the tabs. Absent in release.
  static const devMenu = '/dev';
}
