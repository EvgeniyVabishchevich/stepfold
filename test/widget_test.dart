import 'package:flutter_test/flutter_test.dart';
import 'package:walks/app/app.dart';

void main() {
  testWidgets('StepfoldApp shows the app name', (tester) async {
    await tester.pumpWidget(const StepfoldApp());
    await tester.pumpAndSettle();

    expect(find.text('Stepfold'), findsOneWidget);
  });
}
