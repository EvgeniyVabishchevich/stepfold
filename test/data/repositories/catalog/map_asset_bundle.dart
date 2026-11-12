import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An [AssetBundle] in memory: path → text. Counts how often each path was
/// read.
class MapAssetBundle extends CachingAssetBundle {
  /// Creates a bundle with [files].
  MapAssetBundle(this.files);

  /// Path → text of the file.
  final Map<String, String> files;

  /// Path → how many times it was read.
  final Map<String, int> reads = {};

  @override
  Future<ByteData> load(String key) async {
    reads[key] = (reads[key] ?? 0) + 1;
    final text = files[key];
    if (text == null) throw FlutterError('Unable to load asset: "$key".');
    return ByteData.sublistView(utf8.encode(text));
  }

  // CachingAssetBundle would keep strings itself; read every time, so the
  // tests see what the catalog keeps.
  @override
  Future<String> loadString(String key, {bool cache = true}) =>
      super.loadString(key, cache: false);
}
