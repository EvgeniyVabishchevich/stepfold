import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/app/app.dart';
import 'package:walks/ui/today/today_view.dart';

void main() {
  testWidgets('StepfoldApp opens on the Today tab', (tester) async {
    await tester.pumpWidget(const StepfoldApp());
    await tester.pumpAndSettle();

    expect(find.byType(TodayView), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
