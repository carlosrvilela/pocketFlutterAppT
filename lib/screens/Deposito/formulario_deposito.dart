import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/invalid_filds_popup.dart';

const _tituloAppBar = 'Receber Depósito';
const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '0.00';
const _textoBotaoComfrimar = 'Confirmar';

class FormularioDeposito extends StatelessWidget {
  final TextEditingController _controladorCampoValor = TextEditingController();

  FormularioDeposito({Key? key}) : super(key: key);

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
                controlador: _controladorCampoValor,
                rotulo: _rotuloCampoValor,
                dica: _dicaCampoValor,
                icone: Icons.monetization_on),
            ElevatedButton(
              onPressed: () => _criaDeposito(context),
              child: const Text(_textoBotaoComfrimar),
            ),
          ],
        ),
      ),
    );
  }

  _criaDeposito(context) {
    final double? valor = double.tryParse(_controladorCampoValor.text);
    final depositoValido = _validaDeposito(valor);
    if (depositoValido) {
      _atualizaSaldo(context, valor);
      Navigator.pop(context);
    } else {
      IvalidFildsPopUP invalidFilds = IvalidFildsPopUP();
      invalidFilds.throwPopUp(context);
    }
  }

  _validaDeposito(valor) {
    final campoPreenchido = valor != null;
    return campoPreenchido;
  }

  _atualizaSaldo(context, valor) {
    Provider.of<Saldo>(context, listen: false).adiciona(valor);
  }
}
