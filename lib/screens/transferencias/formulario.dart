import 'package:bytebank/models/transferencias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/editor.dart';
import '../../components/invalid_filds_popup.dart';
import '../../models/saldo.dart';
import '../../models/transferencia.dart';

const _tituloAppBar = 'Nova Transferência';
const _rotuloCampoConta = 'Número da conta';
const _dicaCampoConta = '0000';
const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '0.00';
const _textoBotaoComfrimar = 'Confirmar';

class FormularioDeTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
                controlador: _controladorCampoNumeroConta,
                rotulo: _rotuloCampoConta,
                dica: _dicaCampoConta),
            Editor(
                controlador: _controladorCampoValor,
                rotulo: _rotuloCampoValor,
                dica: _dicaCampoValor,
                icone: Icons.monetization_on),
            ElevatedButton(
              onPressed: () => _criaTransferencia(context),
              child: const Text(_textoBotaoComfrimar),
            ),
          ],
        ),
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    final int? numeroConta = int.tryParse(_controladorCampoNumeroConta.text);
    final double? valor = double.tryParse(_controladorCampoValor.text);
    final transferenciaValida =
        _validaTransferencia(context, numeroConta, valor);

    if (transferenciaValida) {
      final Transferencia novaTransferencia =
          Transferencia(valor!, numeroConta!);
      _atualizaEstado(context, novaTransferencia, valor);
      Navigator.pop(context);
    } else {
      IvalidFildsPopUP invalidFilds = IvalidFildsPopUP();
      invalidFilds.throwPopUp(context);
    }
  }

  _validaTransferencia(context, numeroConta, valor) {
    final _camposPreenchidos = numeroConta != null && valor != null;
    final _saldoSuficiente = valor <=
        Provider.of<Saldo>(
          context,
          listen: false,
        ).valor;
    return _camposPreenchidos && _saldoSuficiente;
  }

  _atualizaEstado(context, novaTransferencia, valor) {
    Provider.of<Transferencias>(
      context,
      listen: false,
    ).adiciona(novaTransferencia);
    Provider.of<Saldo>(
      context,
      listen: false,
    ).subtrai(valor);
  }
}
