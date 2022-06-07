import 'dart:async';

import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
  final TransactionWebClient _transactionWebClient = TransactionWebClient();
  final String transactionId = const Uuid().v4();
  bool _sending = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                                      transactionCreated, password, context);
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
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    Transaction? transaction = await _sendTransaction(
      transactionCreated,
      password,
      context,
    );
    await _showSuccessDialog(transaction);
  }

  Future<Transaction?> _sendTransaction(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    setState(() {
      _sending = true;
    });
    final Transaction? transaction = await _transactionWebClient
        .save(transactionCreated, password)
        .catchError(
      (error) {
        if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
          FirebaseCrashlytics.instance
              .setCustomKey('Http_Exception', error.toString());
          FirebaseCrashlytics.instance
              .setCustomKey('Http_Status_Code', error.statusCode);
          FirebaseCrashlytics.instance
              .setCustomKey('Http_Body', transactionCreated.toString());
          FirebaseCrashlytics.instance.recordError(error, null);
        }

        _showFailureDialog(
          context,
          message: error.message,
        );
      },
      test: (error) => error is HttpException,
    ).catchError(
      (error) {
        if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
          FirebaseCrashlytics.instance
              .setCustomKey('Timeout_Exception', error.toString());
          FirebaseCrashlytics.instance
              .setCustomKey('Http_Body', transactionCreated.toString());
          FirebaseCrashlytics.instance.recordError(error, null);
        }

        _showFailureDialog(
          context,
          message: 'Timeout submitting',
        );
      },
      test: (error) => error is TimeoutException,
    ).catchError(
      (error) {
        if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
          FirebaseCrashlytics.instance
              .setCustomKey('Unknown_Exception', error.toString());
          FirebaseCrashlytics.instance
              .setCustomKey('Http_Body', transactionCreated.toString());
          FirebaseCrashlytics.instance.recordError(error, null);
        }

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