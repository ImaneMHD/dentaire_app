import 'package:bloc/bloc.dart';
import 'package:dentaire/statemanagement/bloc/profile/profile_event.dart';
import 'package:dentaire/statemanagement/bloc/profile/profile_service.dart';
import 'package:dentaire/statemanagement/bloc/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService _profileService;

  ProfileBloc(this._profileService) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final userProfile = await _profileService.getUserProfile();
      emit(ProfileLoaded(userProfile));
    } catch (e) {
      emit(ProfileError('Échec du chargement du profil: $e'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      await _profileService.updateProfile(event.profile);
      // Recharger le profil pour refléter les modifications.
      add(LoadProfile());
    } catch (e) {
      emit(ProfileError('Échec de la mise à jour du profil: $e'));
    }
  }
}
