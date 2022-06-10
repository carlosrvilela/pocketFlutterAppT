import 'package:bytebank/components/bloc_container.dart';
import 'package:bytebank/components/loaclization.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/transferencias/lista.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../models/user_name.dart';
import '../dasboard/dashboard.dart';

// class LatestTransfersContainer extends BlocContainer {
//   const LatestTransfersContainer({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (contextProvider) => UserNameCubit(''),
//       //value: BlocProvider.of<UserNameCubit>(context),
//       child: I18NLoadingContainer(
//             (messages) => LatestTransfersView(LatestTransfersViewLazyI18N(messages)),
//       ),
//     );
//   }
// }

// class LatestTransfersViewLazyI18N {
//   final I18NMessages _messages;
//
//   LatestTransfersViewLazyI18N(this._messages);
//
//   String get latestTransfers => _messages.get('latestTransfers') ?? 'default';
//
//   String get transferList => _messages.get('transferList') ?? 'default';
//
//   String get noRecentTransfers =>
//       _messages.get('noRecentTransfers') ?? 'default';
// }

class LatestTransfersView extends StatelessWidget {
  final DashboardViewLazyI18N _i18N;
  //final LatestTransfersViewLazyI18N _i18N;

  const LatestTransfersView(this._i18N, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _i18N.latestTransfers,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Consumer<Transferencias>(builder: (context, transfers, child) {
          final latestTransfers = transfers.transferencias.reversed.toList();

          int length = transfers.transferencias.length;

          if (length == 0) {
            return NoTransfersView(_i18N);
          } else if (length > 2) {
            length = 2;
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ItemTransferencia(latestTransfers[index]);
            },
          );
        }),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const ListaDeTransferencias();
                },
              ),
            );
          },
          child: Text(_i18N.transferList),
        ),
      ],
    );
  }
}

class NoTransfersView extends StatelessWidget {
  final DashboardViewLazyI18N _i18N;
  //final LatestTransfersViewLazyI18N _i18N;

  const NoTransfersView(this._i18N, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(40.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _i18N.noRecentTransfers,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
