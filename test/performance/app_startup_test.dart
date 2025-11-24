import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App Startup Performance Tests', () {
    testWidgets('Measure app startup time', (WidgetTester tester) async {
      // Record start time
      final startTime = DateTime.now();

      // Build a simple widget
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Center(child: Text('Test'))),
      ));

      // Record end time
      final endTime = DateTime.now();
      final startupDuration = endTime.difference(startTime);

      // Log the startup time
      print('🚀 Widget Build Time: ${startupDuration.inMilliseconds}ms');

      // Assert that build time is reasonable (less than 1 second)
      expect(
        startupDuration.inMilliseconds,
        lessThan(1000),
        reason: 'Widget should build in less than 1 second',
      );

      // Verify that the app has loaded
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Measure time to first frame', (WidgetTester tester) async {
      final startTime = DateTime.now();

      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ));

      final firstFrameTime = DateTime.now();
      final timeToFirstFrame = firstFrameTime.difference(startTime);

      print('⚡ Time to First Frame: ${timeToFirstFrame.inMilliseconds}ms');

      // First frame should appear quickly (less than 200ms)
      expect(
        timeToFirstFrame.inMilliseconds,
        lessThan(200),
        reason: 'First frame should appear in less than 200ms',
      );
    });

    testWidgets('Measure rebuild performance', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Center(child: Text('Test'))),
      ));

      // Measure time to rebuild
      final rebuildStartTime = DateTime.now();
      
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Center(child: Text('Updated'))),
      ));
      
      final rebuildEndTime = DateTime.now();
      final rebuildDuration = rebuildEndTime.difference(rebuildStartTime);

      print('🔄 Rebuild Time: ${rebuildDuration.inMilliseconds}ms');

      // Rebuild should be fast (less than 100ms)
      expect(
        rebuildDuration.inMilliseconds,
        lessThan(100),
        reason: 'Rebuild should complete in less than 100ms',
      );
    });
  });
}
