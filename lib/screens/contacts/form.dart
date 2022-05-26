import 'package:flutter/material.dart';

import '../../components/invalid_filds_popup.dart';
import '../../models/contact.dart';

class ContactForm extends StatefulWidget {
  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _controllerNome = TextEditingController();

  final TextEditingController _controllerNumeroConta = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerNome,
              style: TextStyle(
                fontSize: 24.0,
              ),
              decoration: InputDecoration(
                labelText: 'Nome Completo',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _controllerNumeroConta,
                style: TextStyle(
                  fontSize: 24.0,
                ),
                decoration: InputDecoration(
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
                    final String? nome = _controllerNome.text;
                    final int? numeroDaConta = int.tryParse(_controllerNumeroConta.text);
                    if (nome != null && nome != '' && numeroDaConta != null){
                      final Contact novoCcontato = Contact(nome, numeroDaConta);
                      Navigator.pop(context, novoCcontato);
                    }else{
                      final IvalidFildsPopUP invalidFilds = IvalidFildsPopUP();
                      invalidFilds.throwPopUp(context);
                    }
                  },
                  child: Text('Adicionar Novo Contato'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}