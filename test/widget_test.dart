import 'package:flutter_test/flutter_test.dart';
import 'package:walks/app/app.dart';
import 'package:walks/app/di.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/ui/kit/kit_bottom_navigation.dart';
import 'package:walks/ui/pages/today/today_page.dart';

void main() {
  setUp(() => configureDependencies(Implementations.fakes));
  tearDown(getIt.reset);

  testWidgets('StepfoldApp opens on the Today tab', (tester) async {
    await tester.pumpWidget(const StepfoldApp());
    await tester.pumpAndSettle();

    expect(find.byType(TodayView), findsOneWidget);
    expect(find.byType(KitBottomNavigation), findsOneWidget);
  });
}
