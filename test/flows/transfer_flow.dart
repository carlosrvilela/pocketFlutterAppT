import 'package:bytebank/main.dart';
import 'package:bytebank/screens/contacts/list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/transactions/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../components/matchers.dart';
import '../components/mocks.dart';
import 'actions.dart';

void main() {
  testWidgets('Should transfer to a contact', (tester) async {
    final mockContactDao = MockContactDao();
    await tester.pumpWidget(BytebankApp(contactDao: mockContactDao));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    // when(mockContactDao.findAll()).thenAnswer((invocation) async{
    //   return [mockContact];
    // });

    await clickOnTheTransferFeatureItem(tester);

    await tester.pumpAndSettle();
    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    //verify(mockContactDao.findAll()).called(1);//Erro Used on a non-mockito object

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == mockContact.name &&
            widget.contact.accountNumber == mockContact.accountNumber;
      }
      return false;
    });
    expect(contactItem, findsOneWidget);

    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);
  });
}
