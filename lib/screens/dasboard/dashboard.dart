import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/screens/Deposito/formulario_deposito.dart';
import 'package:bytebank/screens/contacts/list.dart';
import 'package:bytebank/screens/dasboard/SaldoCard.dart';
import 'package:bytebank/screens/transactions/list.dart';
import 'package:bytebank/screens/transferencias/formulario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bytebank'),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('images/bytebank_logo.png'),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SaldoCard(),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FormularioDeposito();
                        },
                      ),
                    );
                  },
                  child: Text('Receber Depósito'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FormularioDeTransferencia();
                        },
                      ),
                    );
                  },
                  child: Text('Nova Transferência'),
                )
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FeatureItem(
                    'Transfer',
                    Icons.monetization_on,
                    onClick: () {
                      _showContactsList(context);
                    },
                  ),
                  _FeatureItem(
                    'Transaction Feed',
                    Icons.description,
                    onClick: () {
                      _showTransactionsList(context);
                    },
                  ),
                ],
              ),
            )
          ],
        )
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Image.asset('images/bytebank_logo.png'),
        //     ),
        //     SizedBox(
        //       height: 120,
        //       child: ListView(
        //         scrollDirection: Axis.horizontal,
        //         children: [
        //           _FeatureItem(
        //             'Transfer',
        //             Icons.monetization_on,
        //             onClick: () {
        //               _showContactsList(context);
        //             },
        //           ),
        //           _FeatureItem(
        //             'Transaction Feed',
        //             Icons.description,
        //             onClick: () {
        //               _showTransactionsList(context);
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        );
  }

  void _showContactsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ContactsList(),
      ),
    );
  }

  _showTransactionsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransactionsList(),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  const _FeatureItem(this.name, this.icon, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 32.0,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
