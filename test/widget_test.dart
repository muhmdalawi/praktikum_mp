import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praktikum_mp2/main.dart';

void main() {
  testWidgets('App smoke test and compact screen test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Materi'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });
}
