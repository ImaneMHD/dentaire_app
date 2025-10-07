import 'dart:async';
import 'package:dentaire/data/models/User.dart';
import 'package:dentaire/statemanagement/bloc/users/users_service.dart';
import 'package:dentaire/statemanagement/bloc/users/users_state.dart';
import 'package:dentaire/statemanagement/bloc/users/userts_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService;
  StreamSubscription? _usersSubscription;

  UserBloc(this._userService) : super(UsersInitialState()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<AddUserEvent>(_onAddUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<UserLoadedEvent>(_onUserLoaded);
  }

  Future<void> _onLoadUsers(
      LoadUsersEvent event, Emitter<UserState> emit) async {
    emit(UsersLoadingState());
    try {
      _usersSubscription?.cancel();
      _usersSubscription = _userService.getUsers().listen(
        (users) {
          add(UserLoadedEvent(users));
        },
        onError: (error) {
          emit(UsersErrorState(error.toString()));
        },
      );
    } catch (e) {
      emit(UsersErrorState(e.toString()));
    }
  }

  void _onUserLoaded(UserLoadedEvent event, Emitter<UserState> emit) {
    emit(UsersLoadedState(event.users));
  }

  Future<void> _onAddUser(AddUserEvent event, Emitter<UserState> emit) async {
    try {
      await _userService.addUser(event.user);
    } catch (e) {
      emit(UsersErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      await _userService.updateUser(event.user);
    } catch (e) {
      emit(UsersErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    try {
      await _userService.deleteUser(event.userId);
    } catch (e) {
      emit(UsersErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}

// Événement interne pour la mise à jour en temps réel
class UserLoadedEvent extends UserEvent {
  final List<AppUser> users;
  const UserLoadedEvent(this.users);

  @override
  List<Object> get props => [users];
}
