import 'package:flutter/material.dart';

void main() => runApp(const StepfoldApp());

/// Root widget of the Stepfold app.
class StepfoldApp extends StatelessWidget {
  /// Creates the root widget.
  const StepfoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Stepfold',
      home: Scaffold(body: Center(child: Text('Stepfold'))),
    );
  }
}
