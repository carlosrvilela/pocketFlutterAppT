import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/transferencia.dart';

const _tituloAppBar = 'Nova Transferência';
const _rotuloCampoConta = 'Número da conta';
const _dicaCampoConta = '0000';
const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '0.00';

const _textoBotaoComfrimar = 'Confirmar';
const _textoBotaoVoltar = 'Voltar';
const _textoCamposInvalidos = 'Um ou mais campos inválidos';
const _textoErro = 'Erro!';

class FormularioDeTransferencia extends StatefulWidget {
  const FormularioDeTransferencia({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormularioDeTransferenciaState();
  }
}

class FormularioDeTransferenciaState extends State<FormularioDeTransferencia> {
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
    if (numeroConta != null && valor != null) {
      final Transferencia novaTransferencia = Transferencia(valor, numeroConta);
      Navigator.pop(context, novaTransferencia);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(_textoErro),
            content: const Text(_textoCamposInvalidos),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(_textoBotaoVoltar),
              )
            ],
          );
        },
      );
    }
  }
}
