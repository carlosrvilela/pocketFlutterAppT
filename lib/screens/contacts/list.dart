import 'package:bytebank/screens/contacts/form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(
                'Fulano',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              subtitle: Text(
                '9999',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => ContactForm(),
                ),
              )
              .then(
                (response) => debugPrint(response.toString()),
              );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
