import 'package:bytebank/components/bloc_container.dart';
import 'package:bytebank/models/user_name.dart';
import 'package:bytebank/screens/Deposito/formulario_deposito.dart';
import 'package:bytebank/screens/contacts/list.dart';
import 'package:bytebank/screens/dasboard/dasboar_feature_item.dart';
import 'package:bytebank/screens/dasboard/dasboard_i18n.dart';
import 'package:bytebank/screens/dasboard/saldo_card.dart';
import 'package:bytebank/screens/transactions/list.dart';
import 'package:bytebank/screens/transferencias/formulario.dart';
import 'package:bytebank/screens/transferencias/ultimas.dart';
import 'package:bytebank/screens/user_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                FeatureItem(
                  _i18N.transfer,
                  Icons.monetization_on,
                  onClick: () {
                    _showContactsList(context);
                  },
                ),
                FeatureItem(
                  _i18N.transactionFeed,
                  Icons.description,
                  onClick: () {
                    _showTransactionsList(context);
                  },
                ),
                FeatureItem(
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
