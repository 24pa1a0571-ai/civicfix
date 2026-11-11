import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:civicfix/main.dart';

void main() {
  testWidgets('uses system brightness and allows toggling it', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(const MyApp());
    expect(
      tester.widget<MyHomePage>(find.byType(MyHomePage)).useLightMode,
      isFalse,
    );

    await tester.tap(find.byTooltip('Toggle brightness'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MyHomePage>(find.byType(MyHomePage)).useLightMode,
      isTrue,
    );

    await tester.tap(find.byTooltip('Toggle brightness'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MyHomePage>(find.byType(MyHomePage)).useLightMode,
      isFalse,
    );
  });
}
