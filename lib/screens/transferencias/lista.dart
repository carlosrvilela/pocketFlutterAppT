import 'package:flutter/material.dart';
import '../../models/transferencia.dart';
import 'formulario.dart';

const _tituloAppBar = 'Transferências';

class ListaDeTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  ListaDeTransferencias({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ListaDeTransferenciasState();
  }
}

class ListaDeTransferenciasState extends State<ListaDeTransferencias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),
      body: ListView.builder(
          itemCount: widget._transferencias.length,
          itemBuilder: (context, index) {
            final transferencia = widget._transferencias[index];
            return ItemTransferencia(transferencia);
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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

  const ItemTransferencia(this._transferencia, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text('${_transferencia.valor} - Valor da Transferência'),
        subtitle: Text('${_transferencia.numeroConta} - Númroda conta'),
      ),
    );
  }
}
