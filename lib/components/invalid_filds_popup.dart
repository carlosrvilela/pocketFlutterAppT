import 'package:flutter/material.dart';

const _textoBotaoVoltar = 'Voltar';
const _textoCamposInvalidos = 'Um ou mais campos inválidos';
const _textoErro = 'Erro!';

class IvalidFildsPopUP {
  void throwPopUp(BuildContext context) => {
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
        ),
      };
}
