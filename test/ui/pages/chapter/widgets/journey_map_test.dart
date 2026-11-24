import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/chapter/bloc/bloc.dart';
import 'package:walks/ui/pages/chapter/widgets/journey_map.dart';

class _MissingTileProvider extends TileProvider {
  @override
  ImageProvider<Object> getImage(
    TileCoordinates coordinates,
    TileLayer options,
  ) => const _MissingTile();
}

class _MissingTile extends ImageProvider<Object> {
  const _MissingTile();

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) =>
      throw StateError('Tile unavailable');
}

void main() {
  const route = Progression(
    id: 'test',
    kind: 'journey',
    order: ChapterOrder.strict,
    chapters: [
      Chapter(id: 'start', price: 2000, title: 'Начало'),
      Chapter(id: 'next', price: 6000, title: 'Конец'),
    ],
    journeyLegs: [
      [
        (latitude: 51, longitude: 37),
        (latitude: 51.1, longitude: 37),
        (latitude: 51.8, longitude: 37),
        (latitude: 52, longitude: 37),
      ],
    ],
  );

  testWidgets('the road and distance-based preview survive missing tiles', (
    tester,
  ) async {
    final provider = _MissingTileProvider();
    final reports = <JourneyTilesChanged>[];

    Future<void> show(int previewSteps, {bool unavailable = false}) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: appLocalizationsDelegates,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: JourneyMap(
                  journey: (
                    progression: route,
                    position: (reachedStop: 0, previewSteps: previewSteps),
                  ),
                  tilesUnavailable: unavailable,
                  tileProvider: provider,
                  onTilesChanged: reports.add,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
    }

    LatLng marker() =>
        tester.widget<MarkerLayer>(find.byType(MarkerLayer)).markers.last.point;

    await show(3000);
    expect(reports, isNotEmpty);
    expect(reports.last.unavailable, isTrue);
    await show(3000, unavailable: true);

    expect(find.text('Подложка недоступна'), findsOneWidget);
    final lines = tester.widget<PolylineLayer>(find.byType(PolylineLayer));
    expect(lines.polylines, hasLength(2));
    expect(marker().latitude, closeTo(51.5, .001));
    expect(marker(), lines.polylines.last.points.last);

    await show(6000, unavailable: true);
    expect(marker(), const LatLng(52, 37));
    expect(find.text('Шагов хватает'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
