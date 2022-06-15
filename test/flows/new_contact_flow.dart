import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/screens/contacts/form.dart';
import 'package:bytebank/screens/contacts/list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../components/matchers.dart';
import '../components/mocks.dart';
import 'actions.dart';

@GenerateMocks([ContactDao])
void main() {
  testWidgets('Should create a new contact', (WidgetTester tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionWebClient = MockTransactionWebClient();
    await tester.pumpWidget(BytebankApp(
      contactDao: mockContactDao,
      transactionWebClient: mockTransactionWebClient,
    ));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    await clickOnTheTransferFeatureItem(tester);

    await tester.pumpAndSettle();
    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    //verify(mockContactDao.findAll()).called(1);//Erro Used on a non-mockito object

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);

    await tester.pumpAndSettle();
    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);
    final nameTextField = find.byWidgetPredicate((widget) {
      return textFieldByLabelTextMatcher(widget, 'Full Name');
    });
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Fulano');

    final accountNumberTextField = find.byWidgetPredicate((widget) {
      return textFieldByLabelTextMatcher(widget, 'Account Number');
    });
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');

    final newContactButton =
        find.widgetWithText(ElevatedButton, 'Add New Contact');
    expect(newContactButton, findsOneWidget);
    await tester.tap(newContactButton);

    await tester.pumpAndSettle();
    //verify(mockContactDao.save(mockContact));
    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);
    //verify(mockContactDao.findAll());
  });
}
