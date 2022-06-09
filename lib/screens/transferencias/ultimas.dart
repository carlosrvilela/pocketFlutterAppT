import 'package:bytebank/components/loaclization.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/transferencias/lista.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LatestTransfersViewI18N extends ViewI18N {
  LatestTransfersViewI18N(BuildContext context) : super(context);

  String get title => (localize({'pt-br':'Ùltimas Trnsferência', 'en': 'Latest Transfers'})?? 'default');

  String get transferList => (localize({'pt-br':'Lista de Trnsferência', 'en': 'Transfer List'})?? 'default');

  String get noRecentTransfers => (localize({'pt-br':'Sem Trnsferência Recentes', 'en': 'No recent transfers'})?? 'default');
}

class LatestTransfers extends StatelessWidget {
  const LatestTransfers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18N = LatestTransfersViewI18N(context);
    return Column(
      children: [
         Text(
          i18N.title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Consumer<Transferencias>(builder: (context, transfers, child) {
          final latestTransfers =
              transfers.transferencias.reversed.toList();

          int length = transfers.transferencias.length;

          if (length == 0) {
            return const NoTransfers();
          } else if (length > 2) {
            length = 2;
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ItemTransferencia(latestTransfers[index]);
            },
          );
        }),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const ListaDeTransferencias();
                },
              ),
            );
          },
          child:  Text(i18N.transferList),
        ),
      ],
    );
  }
}

class NoTransfers extends StatelessWidget {
  const NoTransfers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18N = LatestTransfersViewI18N(context);
    return Card(
      margin: const EdgeInsets.all(40.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          i18N.noRecentTransfers,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
