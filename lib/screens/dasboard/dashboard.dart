import 'package:bytebank/components/bloc_container.dart';
import 'package:bytebank/components/loaclization.dart';
import 'package:bytebank/screens/Deposito/formulario_deposito.dart';
import 'package:bytebank/screens/contacts/list.dart';
import 'package:bytebank/screens/dasboard/saldo_card.dart';
import 'package:bytebank/screens/transactions/list.dart';
import 'package:bytebank/screens/transferencias/formulario.dart';
import 'package:bytebank/screens/transferencias/ultimas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_name.dart';
import '../user_name.dart';

class DashboardContainer extends BlocContainer {
  const DashboardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (contextProvider) => UserNameCubit('Fulano'),
      child: I18NLoadingContainer(
        creator: (messages) => DashboardView(DashboardViewLazyI18N(messages)),
        locale: 'pt-br',
        viewKey: "i18n_dashboard",
      ),
    );
  }
}

class DashboardViewLazyI18N {
  final I18NMessages _messages;

  DashboardViewLazyI18N(this._messages);

  String get transfer => _messages.get('transfer') ?? 'default';

  String get transactionFeed => _messages.get('transactionFeed') ?? 'default';

  String get changeName => _messages.get('changeName') ?? 'default';

  String get receiveDeposit => _messages.get('receiveDeposit') ?? 'default';

  String get newTransfer => _messages.get('newTransfer') ?? 'default';

  //
  String get latestTransfers => _messages.get('latestTransfers') ?? 'default';

  String get transferList => _messages.get('transferList') ?? 'default';

  String get noRecentTransfers =>
      _messages.get('noRecentTransfers') ?? 'default';

// String get transfer =>
//     (localize({'pt-br': 'Transferir', 'en': 'Transfer'}) ?? 'default');
//
// String get transactionFeed =>
//     (localize({'pt-br': 'Transações', 'en': 'Transaction Feed'}) ??
//         'default');
//
// String get changeName =>
//     (localize({'pt-br': 'Mudar nome de usuário', 'en': 'Change Name'}) ??
//         'default');
//
// String get receiveDeposit =>
//     (localize({'pt-br': 'Receber Depósito', 'en': 'Receive Deposit'}) ??
//         'default');
//
// String get newTransfer =>
//     (localize({'pt-br': 'Nova Trnsferência', 'en': 'New Transfer'}) ??
//         'default');
}

class DashboardView extends StatelessWidget {
  final DashboardViewLazyI18N _i18N;

  const DashboardView(this._i18N, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<UserNameCubit, String>(
          builder: (context, state) => Text('Welcome $state'),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Image.asset('images/bytebank_logo.png'),
          // ),
          const Align(
            alignment: Alignment.topCenter,
            child: SaldoCard(),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return FormularioDeposito();
                      },
                    ),
                  );
                },
                child: Text(_i18N.receiveDeposit),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return FormularioDeTransferencia();
                      },
                    ),
                  );
                },
                child: Text(_i18N.newTransfer),
              )
            ],
          ),
          LatestTransfersView(_i18N),
          //const LatestTransfersContainer(),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FeatureItem(
                  _i18N.transfer,
                  Icons.monetization_on,
                  onClick: () {
                    _showContactsList(context);
                  },
                ),
                _FeatureItem(
                  _i18N.transactionFeed,
                  Icons.description,
                  onClick: () {
                    _showTransactionsList(context);
                  },
                ),
                _FeatureItem(
                  _i18N.changeName,
                  Icons.person_outlined,
                  onClick: () {
                    _showChangeName(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showContactsList(BuildContext blocContext) {
    push(blocContext, const ContactsListContainer());
  }

  void _showChangeName(BuildContext blocContext) {
    Navigator.of(blocContext).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<UserNameCubit>(blocContext),
          child: const UserNameContainer(),
        ),
      ),
    );
  }

  _showTransactionsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransactionsList(),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  const _FeatureItem(this.name, this.icon, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 32.0,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
