import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:mockito/mockito.dart';


Contact mockContact = Contact(0, 'Fulano', 9999);

class MockContactDao extends Mock implements ContactDao {
  @override
  Future<List<Contact>> findAll() async{
    return [mockContact];
  }

  @override
  Future<int> save(Contact contact) async {
    return 0;
  }
}