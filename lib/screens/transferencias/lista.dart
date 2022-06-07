import 'package:bytebank/models/transferencias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/transferencia.dart';
import 'formulario.dart';

const _tituloAppBar = 'Transferências';

class ListaDeTransferencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),
      body: Consumer<Transferencias>(
        builder: (context, transferencias, child) {
          return ListView.builder(
            itemCount: transferencias.transferencias.length,
            itemBuilder: (context, index) {
              final transferencia = transferencias.transferencias[index];
              return ItemTransferencia(transferencia);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioDeTransferencia();
          }));
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(_transferencia.toStringValor()),
        subtitle: Text(_transferencia.toStringNumeroConta()),
      ),
    );
  }
}
