import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:mockito/mockito.dart';

Contact mockContact = Contact(0, 'Fulano', 9999);
Transaction mockTransaction = Transaction('0', 200, mockContact);


// class MockContact extends Mock implements Contact {
//   @override
//   final int id;
//   @override
//   final String name;
//   @override
//   final int accountNumber;
//
//   MockContact(
//     this.id,
//     this.name,
//     this.accountNumber,
//   );
// }

class MockContactDao extends Mock implements ContactDao {
  @override
  Future<List<Contact>> findAll() async {
    return [mockContact];
  }

  @override
  Future<int> save(Contact contact) async {
    return 0;
  }
}

class MockTransactionWebClient extends Mock implements TransactionWebClient {
  @override
  Future<Transaction?> save(Transaction transaction, String password) async {
    return mockTransaction;
  }
}
