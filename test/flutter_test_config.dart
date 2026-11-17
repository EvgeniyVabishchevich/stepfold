import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs before every test file: loads the bundled Inter.
///
/// Without it tests draw every glyph as a box (the Ahem test font), and the
/// golden images show nothing of the real type.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inter = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    inter.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.ttf'));
  }
  await inter.load();
  await testMain();
}
