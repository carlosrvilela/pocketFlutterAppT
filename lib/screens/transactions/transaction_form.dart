import 'dart:async';

import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../components/invalid_filds_popup.dart';
import '../../components/progress.dart';
import '../../models/contact.dart';
import '../../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  const TransactionForm(this.contact, {Key? key}) : super(key: key);

  @override
  TransactionFormState createState() => TransactionFormState();
}

class TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = const Uuid().v4();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: _sending,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Progress(
                    message: 'Sending...',
                  ),
                ),
              ),
              Text(
                widget.contact.name,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      if (value != null && value != 0) {
                        final transactionCreated =
                            Transaction(transactionId, value, widget.contact);
                        showDialog(
                            context: context,
                            builder: (contextDialog) {
                              return TransactionAuthDialog(
                                onConfirm: (String password) {
                                  _saveTransaction(
                                    dependencies!.transactionWebClient,
                                    transactionCreated,
                                    password,
                                    context,
                                  );
                                },
                              );
                            });
                      } else {
                        final IvalidFildsPopUP invalidFilds =
                            IvalidFildsPopUP();
                        invalidFilds.throwPopUp(context);
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveTransaction(
    TransactionWebClient transactionWebClient,
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    Transaction? transaction = await _sendTransaction(
      transactionWebClient,
      transactionCreated,
      password,
      context,
    );
    await _showSuccessDialog(transaction);
  }

  Future<Transaction?> _sendTransaction(
    TransactionWebClient transactionWebClient,
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    setState(() {
      _sending = true;
    });
    final Transaction? transaction = await transactionWebClient
        .save(transactionCreated, password)
        .catchError(
      (error) {
        _showFailureDialog(
          context,
          message: error.message,
        );
      },
      test: (error) => error is HttpException,
    ).catchError(
      (error) {
        _showFailureDialog(
          context,
          message: 'Timeout submitting',
        );
      },
      test: (error) => error is TimeoutException,
    ).catchError(
      (error) {
        _showFailureDialog(
          context,
        );
      },
    ).whenComplete(() {
      setState(() {
        _sending = false;
      });
    });
    return transaction;
  }

  void _showFailureDialog(
    BuildContext context, {
    String message = 'Unknown error',
  }) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return FailureDialog(message);
      },
    );
  }

  Future<void> _showSuccessDialog(Transaction? transaction) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return const SuccessDialog('Successful  transaction');
          });
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
