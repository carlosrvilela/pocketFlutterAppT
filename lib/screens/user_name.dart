import 'package:bytebank/components/bloc_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_name.dart';

class UserNameContainer extends BlocContainer {
  const UserNameContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserNameView();
  }
}

class UserNameView extends StatelessWidget {
  UserNameView({Key? key}) : super(key: key);

  final TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _userNameController.text = context.read<UserNameCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change user name'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _userNameController,
            decoration: const InputDecoration(
              labelText: 'Desired name',
            ),
            style: const TextStyle(fontSize: 24.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                child: const Text('Change'),
                onPressed: () {
                  final name = _userNameController.text;
                  context.read<UserNameCubit>().changeUserName(name);
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
