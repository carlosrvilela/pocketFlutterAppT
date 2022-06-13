import 'package:bytebank/components/localization/i18n_messages.dart';
import 'package:bytebank/http/webclients/i18n_webclient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import 'i18n_states.dart';

class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  final LocalStorage storage = LocalStorage('local_storage_v1.json');
  final String _viewKey;

  I18NMessagesCubit(this._viewKey) : super(const InitI18NMessagesState());

  reload(I18NWebClient client) async {
    emit(const LoadingI18NMessagesState());
    final items = await getStorageItems();
    debugPrint('Loaded $_viewKey: $items');
    if (items != null) {
      emit(LoadedI18NMessagesState(I18NMessages(items)));
      return;
    }
    await client.findAll().then(saveAndRefresh);
  }

  saveAndRefresh(Map<String, dynamic> messages) async {
    await storage.ready.catchError((e) {
      debugPrint(e);
    });
    await storage.setItem(_viewKey, messages);
    debugPrint('Saving $_viewKey: $messages');
    final state = LoadedI18NMessagesState(I18NMessages(messages));
    emit(state);
  }

  Future getStorageItems() async {
    await storage.ready.catchError((e) {
      debugPrint(e);
    });
    final items = await storage.getItem(_viewKey);
    return items;
  }
}