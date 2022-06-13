import 'package:bytebank/components/localization/i18n_messages.dart';

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
}