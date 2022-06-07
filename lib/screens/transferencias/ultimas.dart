import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/transferencias/lista.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _titulo = 'Últimas Transferências';

class UltimasTransferencias extends StatelessWidget {
  const UltimasTransferencias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          _titulo,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Consumer<Transferencias>(builder: (context, transferencias, child) {
          final ultimasTranferencias =
              transferencias.transferencias.reversed.toList();

          int tamanho = transferencias.transferencias.length;

          if (tamanho == 0) {
            return const SemTransferencias();
          } else if (tamanho > 2) {
            tamanho = 2;
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: tamanho,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ItemTransferencia(ultimasTranferencias[index]);
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
          child: const Text('Lista de Transferências'),
        ),
      ],
    );
  }
}

class SemTransferencias extends StatelessWidget {
  const SemTransferencias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(40.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Sem tranferências recentes',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
