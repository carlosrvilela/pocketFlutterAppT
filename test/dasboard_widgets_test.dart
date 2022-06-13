import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should display the main image when the Dashboard is opened',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Dashboard()));
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });

  testWidgets('should display the first feature when the Dashboard is opened',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Dashboard()));
    final firstFeature = find.byType(FeatureItem);
    expect(firstFeature, findsWidgets);
  });
}
