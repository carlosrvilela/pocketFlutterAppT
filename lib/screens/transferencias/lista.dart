import 'package:flutter/material.dart';
import '../../models/transferencia.dart';
import 'formulario.dart';

const _tituloAppBar = 'Transferências';

class ListaDeTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaDeTransferenciasState();
  }
}

class ListaDeTransferenciasState extends State<ListaDeTransferencias> {
  // @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),
      body: ListView.builder(
          itemCount: widget._transferencias.length,
          itemBuilder: (context, index) {
            final transferencia = widget._transferencias[index];
            return ItemTransferencia(transferencia);
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioDeTransferencia();
          }));
          future.then((transferenciaRecebida) {
            _atualizaTransferencias(transferenciaRecebida);
          });
        },
      ),
    );
  }

  void _atualizaTransferencias(transferenciaRecebida) {
    if (transferenciaRecebida != null) {
      setState(() {
        widget._transferencias.add(transferenciaRecebida);
      });
    }
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title:
            Text(_transferencia.valor.toString() + ' - Valor da Transferência'),
        subtitle:
            Text(_transferencia.numeroConta.toString() + ' - Númroda conta'),
      ),
    );
  }
}
