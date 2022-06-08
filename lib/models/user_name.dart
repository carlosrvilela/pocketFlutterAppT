import 'package:flutter_bloc/flutter_bloc.dart';

class UserNameCubit extends Cubit<String> {
  UserNameCubit(String userName) : super(userName);
  void changeUserName(String userName) => emit(userName);
}