import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/chapter/bloc/bloc.dart';
import 'package:walks/ui/theme/theme.dart';

/// The journey's road geometry, stops and current position.
class JourneyMap extends StatefulWidget {
  /// Creates a map card for an opened journey chapter.
  const JourneyMap({
    required this.journey,
    required this.tilesUnavailable,
    this.onTilesChanged,
    this.tileProvider,
    super.key,
  });

  /// The route and current progress.
  final ChapterJourney journey;

  /// Whether the tile at the center could be loaded.
  final bool tilesUnavailable;

  /// Reports changes to the visible background.
  final ValueChanged<JourneyTilesChanged>? onTilesChanged;

  /// An optional tile source for rendering the same route with another source.
  final TileProvider? tileProvider;

  @override
  State<JourneyMap> createState() => _JourneyMapState();
}

class _JourneyMapState extends State<JourneyMap> {
  static const _tileSize = 256;
  static final _copyright = Uri.https('www.openstreetmap.org', '/copyright');

  final _mapController = MapController();
  late final TileProvider _tileProvider =
      widget.tileProvider ?? NetworkTileProvider();
  late final List<List<LatLng>> _legs = [
    for (final leg in widget.journey.progression.journeyLegs)
      [for (final point in leg) LatLng(point.latitude, point.longitude)],
  ];
  late final List<LatLng> _route = _legs.expand((leg) => leg).toList();
  late final List<LatLng> _stops = [
    _legs.first.first,
    for (final leg in _legs) leg.last,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = context.l10n;
    final (:progression, :position) = widget.journey;
    final (:reachedStop, :previewSteps) = position;
    final reached = progression.chapters[reachedStop];
    final target = previewSteps == null
        ? null
        : progression.chapters[reachedStop + 1];
    final confirmed = _legs.take(reachedStop).expand((leg) => leg).toList();
    final preview = target == null || previewSteps == null || previewSteps == 0
        ? const <LatLng>[]
        : _pathPrefix(_legs[reachedStop], previewSteps / target.price);
    final markerPreview = preview.isEmpty ? null : preview.last;
    final showFallback = widget.tilesUnavailable;

    return Material(
      color: colors.surface,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(Radii.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Semantics(
              label: l10n.journeyMap,
              container: true,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  backgroundColor: colors.surfaceContainerHighest,
                  initialCameraFit: CameraFit.bounds(
                    bounds: LatLngBounds.fromPoints(_route),
                    padding: const EdgeInsets.fromLTRB(32, 44, 32, 56),
                    maxZoom: 14,
                  ),
                  minZoom: 4,
                  maxZoom: 16,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.ettynat.stepfold',
                    tileProvider: _tileProvider,
                    tileDisplay: TileDisplay.instantaneous(
                      opacity: theme.brightness == Brightness.dark ? .55 : 1,
                    ),
                    panBuffer: 0,
                    evictErrorTileStrategy: EvictErrorTileStrategy.notVisible,
                    errorTileCallback: (tile, _, _) =>
                        _reportTile(tile.coordinates, unavailable: true),
                    tileBuilder: (context, image, tile) {
                      if (tile.imageInfo != null && !tile.loadError) {
                        _reportTile(tile.coordinates, unavailable: false);
                      }
                      return image;
                    },
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _route,
                        color: colors.outline,
                        strokeWidth: 3,
                        borderColor: colors.surface,
                        borderStrokeWidth: 2,
                      ),
                      if (confirmed.isNotEmpty)
                        Polyline(
                          points: confirmed,
                          color: colors.primary,
                          strokeWidth: 4,
                        ),
                      if (preview.isNotEmpty)
                        Polyline(
                          points: preview,
                          color: colors.primary,
                          strokeWidth: 4,
                          pattern: StrokePattern.dashed(segments: const [5, 4]),
                        ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      for (var i = 0; i < _stops.length; i++)
                        Marker(
                          point: _stops[i],
                          width: 24,
                          height: 24,
                          child: Tooltip(
                            message: progression.chapters[i].title,
                            child: Center(
                              child: _dot(
                                diameter: i == reachedStop ? 16 : 10,
                                fill: i <= reachedStop
                                    ? colors.primary
                                    : colors.surface,
                                border: i <= reachedStop
                                    ? colors.surface
                                    : colors.outline,
                              ),
                            ),
                          ),
                        ),
                      if (markerPreview != null)
                        Marker(
                          point: markerPreview,
                          width: 24,
                          height: 24,
                          child: Tooltip(
                            message: l10n.journeyPreviewPosition,
                            child: Center(
                              child: _dot(
                                diameter: 20,
                                fill: colors.surface,
                                border: colors.primary,
                                child: _dot(diameter: 8, fill: colors.primary),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (showFallback)
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.s12),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(Radii.small),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.s12,
                              vertical: Spacing.s4,
                            ),
                            child: Text(
                              l10n.journeyTilesUnavailable,
                              style: theme.textTheme.labelMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Material(
                      color: colors.surface,
                      child: InkWell(
                        onTap: () => launchUrl(
                          _copyright,
                          mode: LaunchMode.externalApplication,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.s8,
                            vertical: Spacing.s4,
                          ),
                          child: Text(
                            '© OpenStreetMap contributors',
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Spacing.s4,
              children: [
                Text(
                  target == null
                      ? l10n.journeyReachedStop
                      : l10n.journeyNextStop(target.title),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  target == null || previewSteps == null
                      ? reached.title
                      : l10n.journeyProgress(
                          previewSteps,
                          l10n.stepCount(target.price),
                        ),
                  style: theme.textTheme.bodyLarge,
                ),
                if (target != null && previewSteps == target.price)
                  Text(l10n.todayReady, style: theme.textTheme.labelMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _reportTile(TileCoordinates coordinate, {required bool unavailable}) {
    final notify = widget.onTilesChanged;
    if (notify == null || unavailable == widget.tilesUnavailable) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || unavailable == widget.tilesUnavailable) return;
      final camera = _mapController.camera;
      final center = camera.projectAtZoom(
        camera.center,
        coordinate.z.toDouble(),
      );
      if (coordinate.z == camera.zoom.round() &&
          coordinate.x == (center.dx / _tileSize).floor() &&
          coordinate.y == (center.dy / _tileSize).floor()) {
        notify(
          JourneyTilesChanged(
            widget.journey.progression.id,
            unavailable: unavailable,
          ),
        );
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Widget _dot({
    required double diameter,
    required Color fill,
    Color? border,
    Widget? child,
  }) => Container(
    alignment: Alignment.center,
    width: diameter,
    height: diameter,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: fill,
      border: border == null ? null : Border.all(color: border, width: 2),
    ),
    child: child,
  );
}

/// Returns the portion of a leg covered by a fraction of its road distance.
List<LatLng> _pathPrefix(List<LatLng> leg, double fraction) {
  if (fraction >= 1) return leg;
  const distance = DistanceHaversine(roundResult: false);
  final lengths = [
    for (var i = 1; i < leg.length; i++) distance(leg[i - 1], leg[i]),
  ];
  var remaining =
      lengths.fold<double>(0, (sum, length) => sum + length) * fraction;

  for (var i = 0; i < lengths.length; i++) {
    final length = lengths[i];
    if (remaining < length) {
      final a = leg[i];
      final b = leg[i + 1];
      final part = remaining / length;
      return [
        ...leg.take(i + 1),
        LatLng(
          a.latitude + (b.latitude - a.latitude) * part,
          a.longitude + (b.longitude - a.longitude) * part,
        ),
      ];
    }
    remaining -= length;
  }
  return leg;
}
