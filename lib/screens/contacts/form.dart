import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:flutter/material.dart';

import '../../components/invalid_filds_popup.dart';
import '../../models/contact.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerNumeroConta = TextEditingController();
  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerNome,
              style: const TextStyle(
                fontSize: 24.0,
              ),
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _controllerNumeroConta,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
                decoration: const InputDecoration(
                  labelText: 'Número da Conta',
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
                    // ignore: unnecessary_nullable_for_final_variable_declarations
                    final String? nome = _controllerNome.text;
                    final int? numeroDaConta =
                        int.tryParse(_controllerNumeroConta.text);
                    if (nome != null && nome != '' && numeroDaConta != null) {
                      final Contact novoCcontato =
                          Contact(0, nome, numeroDaConta);
                      _contactDao.save(novoCcontato).then(
                        (id) => Navigator.pop(context),
                      );
                    } else {
                      final IvalidFildsPopUP invalidFilds = IvalidFildsPopUP();
                      invalidFilds.throwPopUp(context);
                    }
                  },
                  child: const Text('Adicionar Novo Contato'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
