/// Spacing of the kit, on a grid of 4 (tokens `space.*` in Penpot).
abstract final class Spacing {
  /// 4.
  static const double s4 = 4;

  /// 8.
  static const double s8 = 8;

  /// 12.
  static const double s12 = 12;

  /// 16.
  static const double s16 = 16;

  /// 24.
  static const double s24 = 24;

  /// 32.
  static const double s32 = 32;
}

/// Corner radii of the kit (tokens `radius.*` in Penpot).
///
/// `radius.full` has no number here: fully rounded shapes use
/// `StadiumBorder`, which rounds by half the height whatever it is.
abstract final class Radii {
  /// Buttons and other small controls.
  static const double small = 12;

  /// Cards.
  static const double card = 20;

  /// Bottom sheets.
  static const double sheet = 28;
}
