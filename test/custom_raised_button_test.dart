import 'package:firebase_course/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('On pressed Callback', (WidgetTester widgetTester) async {
    var pressed = false;
    await widgetTester.pumpWidget(
      MaterialApp(
        home: CustomRaisedButton(
          child: Text("Tap Me"),
          onPressed: () => pressed = true,
        ),
      ),
    );
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
    expect(find.text('Tap Me'), findsOneWidget);
    await widgetTester.press(button);
    expect(pressed, true);
  });
}
