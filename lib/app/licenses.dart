import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Adds the licenses of bundled assets to the app's licenses page.
///
/// Packages add theirs on their own; a font or icons copied into `assets/`
/// do not.
void registerAssetLicenses() {
  LicenseRegistry.addLicense(() async* {
    final ofl = await rootBundle.loadString('assets/fonts/inter/OFL.txt');
    yield LicenseEntryWithLineBreaks(const ['Inter'], ofl);
    final phosphor = await rootBundle.loadString(
      'assets/icons/PHOSPHOR_LICENSE.txt',
    );
    yield LicenseEntryWithLineBreaks(const ['Phosphor Icons'], phosphor);
  });
}
