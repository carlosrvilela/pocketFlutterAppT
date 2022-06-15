import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../components/matchers.dart';
import '../components/mocks.dart';

void main() {
  final mockContactDao = MockContactDao();

  group('When the Dashboard is opened', () {
    testWidgets('should display the main image', (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(home: Dashboard(contactDao: mockContactDao)));
      final mainImage = find.byType(Image);
      expect(mainImage, findsOneWidget);
    });

    testWidgets('should display the transfer feature', (tester) async {
      await tester
          .pumpWidget(MaterialApp(home: Dashboard(contactDao: mockContactDao)));
      // final iconTransferFeature =
      //     find.widgetWithIcon(FeatureItem, Icons.monetization_on);
      // expect(iconTransferFeature, findsOneWidget);
      // final textTransferFeature = find.widgetWithText(FeatureItem, 'Transfer');
      // expect(textTransferFeature, findsOneWidget);
      final transferFeatureItem = find.byWidgetPredicate((widget) =>
          featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
      expect(transferFeatureItem, findsOneWidget);
    });

    testWidgets('should display the transaction feed', (tester) async {
      await tester
          .pumpWidget(MaterialApp(home: Dashboard(contactDao: mockContactDao)));
      final transferFeatureItem = find.byWidgetPredicate((widget) =>
          featureItemMatcher(widget, 'Transaction Feed', Icons.description));
      expect(transferFeatureItem, findsOneWidget);
    });
  });
}
