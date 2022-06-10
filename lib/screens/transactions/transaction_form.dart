import 'dart:async';
import 'package:bytebank/components/bloc_container.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../components/error.dart';
import '../../components/invalid_filds_popup.dart';
import '../../components/progress.dart';
import '../../models/contact.dart';
import '../../models/transaction.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class SendingTransactionFormState extends TransactionFormState {
  const SendingTransactionFormState();
}

@immutable
class ShowTransactionFormState extends TransactionFormState {
  const ShowTransactionFormState();
}

@immutable
class SentTransactionFormState extends TransactionFormState {
  const SentTransactionFormState();
}

@immutable
class FatalErrorTransactionFormState extends TransactionFormState {
  final String _message;

  const FatalErrorTransactionFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(const ShowTransactionFormState());

  final TransactionWebClient _transactionWebClient = TransactionWebClient();

  void saveTransaction(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    emit(const SendingTransactionFormState());
    await _sendTransaction(transactionCreated, password, context);
  }

  _sendTransaction(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    await _transactionWebClient
        .save(transactionCreated, password)
        .then((transaction) => emit(const SentTransactionFormState()))
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
        emit(FatalErrorTransactionFormState(error.message));
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
        emit(const FatalErrorTransactionFormState('Timeout submitting'));
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
        emit(const FatalErrorTransactionFormState('Unknown error'));
      },
    );
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;

  const TransactionFormContainer(this._contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return TransactionFormCubit();
      },
      child: BlocListener<TransactionFormCubit, TransactionFormState>(
        listener: (context, state) {
          if (state is SentTransactionFormState) {
            Navigator.pop(context);
          }
        },
        child: TransactionFormStateless(_contact),
      ),
    );
  }
}

class TransactionFormStateless extends StatelessWidget {
  final Contact _contact;

  const TransactionFormStateless(this._contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
      builder: (context, state) {
        if (state is ShowTransactionFormState) {
          return _BasicTransactionForm(_contact);
        }
        if (state is SendingTransactionFormState ||
            state is SentTransactionFormState) {
          return const ProgressView('Sending...');
        }
        if (state is FatalErrorTransactionFormState) {
          return ErrorView(state._message);
        }
        return const ErrorView('Unknown error');
      },
    );
  }
}

class _BasicTransactionForm extends StatelessWidget {
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = const Uuid().v4();
  final Contact _contact;

  _BasicTransactionForm(this._contact);

  @override
  Widget build(BuildContext context) {
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
              Text(
                _contact.name,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
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
                            Transaction(transactionId, value, _contact);
                        showDialog(
                            context: context,
                            builder: (contextDialog) {
                              return TransactionAuthDialog(
                                onConfirm: (String password) {
                                  BlocProvider.of<TransactionFormCubit>(context)
                                      .saveTransaction(transactionCreated,
                                          password, context);
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
}
