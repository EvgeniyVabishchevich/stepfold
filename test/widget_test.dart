import 'package:flutter_test/flutter_test.dart';
import 'package:walks/main.dart';

void main() {
  testWidgets('StepfoldApp shows the app name', (tester) async {
    await tester.pumpWidget(const StepfoldApp());

    expect(find.text('Stepfold'), findsOneWidget);
  });
}
