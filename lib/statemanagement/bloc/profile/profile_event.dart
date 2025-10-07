import 'package:dentaire/data/models/userPofile.dart';

abstract class ProfileEvent {}

// Événement pour charger les informations de profil.
class LoadProfile extends ProfileEvent {}

// Événement pour mettre à jour les informations de profil.
class UpdateProfile extends ProfileEvent {
  final UserProfile profile;
  UpdateProfile(this.profile);
}
