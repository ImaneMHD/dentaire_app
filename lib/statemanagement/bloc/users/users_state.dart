import 'package:dentaire/data/models/User.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UsersInitialState extends UserState {}

class UsersLoadingState extends UserState {}

class UsersLoadedState extends UserState {
  final List<AppUser> users;
  const UsersLoadedState(this.users);

  @override
  List<Object> get props => [users];
}

class UsersErrorState extends UserState {
  final String message;
  const UsersErrorState(this.message);

  @override
  List<Object> get props => [message];
}
