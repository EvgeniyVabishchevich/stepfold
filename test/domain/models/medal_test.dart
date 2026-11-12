import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/medal.dart';

void main() {
  group('Medal', () {
    test('goes bronze, silver, gold, then stops', () {
      expect(Medal.bronze.next, Medal.silver);
      expect(Medal.silver.next, Medal.gold);
      expect(Medal.gold.next, isNull);
    });

    test('silver costs 10% and gold 30% of the route', () {
      expect(Medal.silver.price(20000), 2000);
      expect(Medal.gold.price(20000), 6000);
    });

    test('rounds the price up', () {
      expect(Medal.silver.price(1001), 101);
    });
  });
}
