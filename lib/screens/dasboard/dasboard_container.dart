import 'package:bytebank/components/bloc_container.dart';
import 'package:bytebank/components/localization/i18n_container.dart';
import 'package:bytebank/models/user_name.dart';
import 'package:bytebank/screens/dasboard/dasboard_i18n.dart';
import 'package:bytebank/screens/dasboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardContainer extends BlocContainer {
  const DashboardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (contextProvider) => UserNameCubit('Fulano'),
      child: I18NLoadingContainer(
        creator: (messages) => DashboardView(DashboardViewLazyI18N(messages)),
        locale: 'en',
        viewKey: "i18n_dashboard",
      ),
    );
  }
}