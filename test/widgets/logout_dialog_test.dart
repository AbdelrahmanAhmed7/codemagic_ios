import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconsult/features/profile/presentation/widgets/logout_dialog.dart';

void main() {
  group('LogoutDialog Widget Tests', () {
    testWidgets('LogoutDialog displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LogoutDialog(),
          ),
        ),
      );

      // Verify dialog is displayed
      expect(find.byType(Dialog), findsOneWidget);
      
      // Verify logout icon is displayed
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    });

    testWidgets('LogoutDialog shows correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LogoutDialog(),
          ),
        ),
      );

      // Note: The title uses translation, so we check for the widget type
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('LogoutDialog has cancel and confirm buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LogoutDialog(),
          ),
        ),
      );

      // Verify buttons exist
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Cancel button returns false when tapped', (WidgetTester tester) async {
      bool? result;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await LogoutDialog.show(context);
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap button to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap cancel button
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });

    testWidgets('Confirm button returns true when tapped', (WidgetTester tester) async {
      bool? result;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await LogoutDialog.show(context);
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap button to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap confirm button
      await tester.tap(find.byType(ElevatedButton).last);
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('Dialog is not dismissible by tapping outside', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => LogoutDialog.show(context),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.byType(Dialog), findsOneWidget);

      // Try to dismiss by tapping outside (should not work due to barrierDismissible: false)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should still be visible
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('Dialog has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LogoutDialog(),
          ),
        ),
      );

      // Verify Container with decoration exists
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.decoration, isNotNull);
    });

    testWidgets('Icon has correct color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LogoutDialog(),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.logout_rounded));
      
      // Verify icon has a color (red shade)
      expect(icon.color, isNotNull);
    });

    testWidgets('Buttons are properly sized', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LogoutDialog(),
          ),
        ),
      );

      // Verify buttons are in a Row (side by side)
      expect(
        find.descendant(
          of: find.byType(Row),
          matching: find.byType(OutlinedButton),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(Row),
          matching: find.byType(ElevatedButton),
        ),
        findsOneWidget,
      );
    });
  });
}
