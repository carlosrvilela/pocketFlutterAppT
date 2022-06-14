import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:flutter/material.dart';

import '../../components/invalid_filds_popup.dart';
import '../../models/contact.dart';

class ContactForm extends StatefulWidget {
  final ContactDao contactDao;

  const ContactForm({Key? key, required this.contactDao}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState(contactDao: contactDao);
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAccountNumber = TextEditingController();
  final ContactDao contactDao;

  _ContactFormState({required this.contactDao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerName,
              style: const TextStyle(
                fontSize: 24.0,
              ),
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _controllerAccountNumber,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    final String? name = _controllerName.text;
                    final int? accountNumber =
                    int.tryParse(_controllerAccountNumber.text);
                    if (name != null && name != '' && accountNumber != null) {
                      final Contact newContact =
                      Contact(0, name, accountNumber);
                      _saveNewContact(newContact, context);
                    } else {
                      final IvalidFildsPopUP invalidFilds = IvalidFildsPopUP();
                      invalidFilds.throwPopUp(context);
                    }
                  },
                  child: const Text('Add New Contact'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNewContact(Contact newContact, BuildContext context) async {
    await contactDao.save(newContact);
    if (!mounted) return;
    Navigator.pop(context);
  }
}
