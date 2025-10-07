import 'package:dentaire/data/models/User.dart';
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsersEvent extends UserEvent {}

class AddUserEvent extends UserEvent {
  final AppUser user;
  const AddUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateUserEvent extends UserEvent {
  final AppUser user;
  const UpdateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class DeleteUserEvent extends UserEvent {
  final String userId;
  const DeleteUserEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
