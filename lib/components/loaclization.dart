import 'package:bytebank/components/bloc_container.dart';
import 'package:bytebank/components/error.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/http/webclients/i18n_webclient.dart';
import 'package:bytebank/screens/contacts/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalizationContainer extends BlocContainer {
  final Widget child;

  const LocalizationContainer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentLocaleCubit>(
      create: (context) => CurrentLocaleCubit(),
      child: child,
    );
  }
}

class CurrentLocaleCubit extends Cubit<String> {
  CurrentLocaleCubit() : super('pt-br');
}

class ViewI18N {
  String _language = 'default';

  ViewI18N(BuildContext context) {
    _language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  String? localize(Map<String, String> map) {
    assert(map != null);
    assert(map.containsKey(_language));

    return map[_language];
  }
}

@immutable
abstract class I18NMessagesState {
  const I18NMessagesState();
}

@immutable
class LoadingI18NMessagesState extends I18NMessagesState {
  const LoadingI18NMessagesState();
}

@immutable
class LoadedI18NMessagesState extends I18NMessagesState {
  final I18NMessages _messages;

  const LoadedI18NMessagesState(this._messages);
}

class I18NMessages {
  final Map<String, dynamic> _messages;

  I18NMessages(this._messages);

  String? get(String key) {
    assert(key != null);
    assert(_messages.containsKey(key));

    return _messages[key];
  }
}

@immutable
class InitI18NMessagesState extends I18NMessagesState {
  const InitI18NMessagesState();
}

@immutable
class FatalErrorI18NMessagesState extends I18NMessagesState {
  const FatalErrorI18NMessagesState();
}

class I18NLoadingContainer extends BlocContainer {
  I18NWidgetCreator creator;
  String locale;
  String viewKey;

  I18NLoadingContainer({required this.creator, required this.locale ,required this.viewKey});
  // I18NLoadingContainer({required String viewKey ,required I18NWidgetCreator creator}){
  //   this.creator = creator;
  //   this.viewKey = viewKey;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (BuildContext context) {
        final cubit = I18NMessagesCubit();
        cubit.reload(I18NWebClient(locale, viewKey));
        return cubit;
      },
      child: I18NLoadingView(creator),
    );
  }
}

typedef I18NWidgetCreator = Widget Function(I18NMessages messages);

class I18NLoadingView extends StatelessWidget {
  final I18NWidgetCreator _creator;

  const I18NLoadingView(this._creator, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>(
      builder: (context, state) {
        if (state is InitI18NMessagesState ||
            state is LoadingContactsListState) {
          return const ProgressView('Loading...');
        }
        if (state is LoadedI18NMessagesState) {
          final messages = state._messages;
          return _creator.call(messages);
        }
        return const ErrorView('Erro ao buscar mensagens');
      },
    );
  }
}

class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  I18NMessagesCubit() : super(const InitI18NMessagesState());

  reload(I18NWebClient client) {
    emit(const LoadingI18NMessagesState());
    client.findAll().then((messages) => emit(
          LoadedI18NMessagesState(I18NMessages(messages)),
        ));
  }
}

// I18NMessages(
//   {
//     'transfer': 'Transfer',
//     'transactionFeed': 'Transaction Feed',
//     'changeName': 'Change Name',
//     'receiveDeposit': 'Receive Deposit',
//     'newTransfer': 'New Transfer',
//     'latestTransfers': 'Latest Transfers',
//     'transferList': 'Transfer List',
//     'noRecentTransfers': 'No recent transfers',
//   },
// ),
