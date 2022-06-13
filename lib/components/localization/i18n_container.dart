import 'package:bytebank/components/bloc_container.dart';
import 'package:bytebank/components/localization/i18n_cubit.dart';
import 'package:bytebank/components/localization/i18n_loading_view.dart';
import 'package:bytebank/http/webclients/i18n_webclient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class I18NLoadingContainer extends BlocContainer {
  final I18NWidgetCreator creator;
  final String locale;
  final String viewKey;

  const I18NLoadingContainer(
      {Key? key,
        required this.creator,
        required this.locale,
        required this.viewKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (BuildContext context) {
        final cubit = I18NMessagesCubit(viewKey);
        cubit.reload(I18NWebClient(locale, viewKey));
        return cubit;
      },
      child: I18NLoadingView(creator),
    );
  }
}