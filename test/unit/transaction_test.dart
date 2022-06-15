import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  int contactId = 0;
  Contact contact = Contact(contactId, 'fulano', 1000);
  String transactionId = '0';
  double transactionValue = 0;
  test('Should return the value when create a transaction', (){
    transactionValue = 200.0;
    final transaction = Transaction(transactionId, transactionValue, contact);
    expect(transaction.value, transactionValue);
  });

  test('Should show error when crate transaction whit value < 0', (){
    transactionValue = 0;
    expect(() => Transaction(transactionId, 0, contact), throwsAssertionError);
  });
}
