import 'package:sqflite/sqflite.dart';
import '../../models/contact.dart';
import '../app_database.dart';

class ContactDao {
  static const String _tableName = 'contacts';
  static const String _contactId = 'id';
  static const String _contactName = 'name';
  static const String _contactAccountNumber = 'account_number';

  String get sqlTable => 'CREATE TABLE $_tableName('
      '$_contactId INTEGER PRIMARY KEY, '
      '$_contactName TEXT, '
      '$_contactAccountNumber INTEGER'
      ')';

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap);
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_contactName] = contact.name;
    contactMap[_contactAccountNumber] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = _toList(result);
    return contacts;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = [];
    for (Map<String, dynamic> row in result) {
      final Contact contact = Contact(
        row[_contactId],
        row[_contactName],
        row[_contactAccountNumber],
      );
      contacts.add(contact);
    }
    return contacts;
  }
}
