import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Drift stuff', (WidgetTester tester) async {
    await tester.pumpWidget(getWithWrapper(app.TestDriftLoader()));
    await tester.pumpAndSettle();
  });
}

Widget getWithWrapper(Widget child) => MaterialApp(home: Scaffold(body: child));
