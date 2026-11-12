/// The medal of a progression.
///
/// Bronze comes for free when every chapter is opened. Silver and gold are
/// bought from the reserve, each for a share of the route price.
enum Medal {
  /// Every chapter is opened.
  bronze(percentOfRoute: 0),

  /// 10% of the route walked on top of bronze.
  silver(percentOfRoute: 10),

  /// 30% of the route walked on top of silver.
  gold(percentOfRoute: 30);

  const Medal({required this.percentOfRoute});

  /// The share of the route price, in percent, that this medal costs.
  final int percentOfRoute;

  /// The medal after this one, or `null` for gold.
  Medal? get next => switch (this) {
    bronze => silver,
    silver => gold,
    gold => null,
  };

  /// The price in steps for a route of [routePrice] steps, rounded up.
  int price(int routePrice) => (routePrice * percentOfRoute + 99) ~/ 100;
}
