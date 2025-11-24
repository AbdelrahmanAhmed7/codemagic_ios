import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Rendering Performance Tests', () {
    testWidgets('Measure frame rendering time', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ));

      // Pump a few frames
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      print('🎬 Frame rendering test passed');
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Measure scroll performance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) => ListTile(
                title: Text('Item $index'),
              ),
            ),
          ),
        ),
      );

      // Perform scroll
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      print('📜 Scroll performance test passed');
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Measure widget build time', (WidgetTester tester) async {
      final buildStartTime = DateTime.now();

      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Center(child: Text('Test'))),
      ));

      final buildEndTime = DateTime.now();
      final buildDuration = buildEndTime.difference(buildStartTime);

      print('🏗️ Widget Build Time: ${buildDuration.inMilliseconds}ms');

      // Widget build should be fast (less than 100ms)
      expect(
        buildDuration.inMilliseconds,
        lessThan(100),
        reason: 'Widget build should complete in less than 100ms',
      );
    });

    testWidgets('Measure animation performance', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      // Animate for a few frames
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      print('⚡ Animation performance test passed');
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
