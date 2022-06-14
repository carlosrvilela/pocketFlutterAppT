import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'components/matchers.dart';
import 'components/mocks.dart';

void main() {
  final mockContactDao = MockContactDao();
  testWidgets('should display the main image when the Dashboard is opened',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard(contactDao: mockContactDao)));
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });

  testWidgets(
      'should display the transfer feature when the Dashboard is opened',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard(contactDao: mockContactDao)));
    // final iconTransferFeature =
    //     find.widgetWithIcon(FeatureItem, Icons.monetization_on);
    // expect(iconTransferFeature, findsOneWidget);
    // final textTransferFeature = find.widgetWithText(FeatureItem, 'Transfer');
    // expect(textTransferFeature, findsOneWidget);
    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
    expect(transferFeatureItem, findsOneWidget);
  });

  testWidgets(
      'should display the transaction feed feature when the Dashboard is opened',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard(contactDao: mockContactDao)));
    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transaction Feed', Icons.description));
    expect(transferFeatureItem, findsOneWidget);
  });
}
