import 'package:dentaire/statemanagement/bloc/dashbord/dashbord_event.dart';
import 'package:dentaire/statemanagement/bloc/dashbord/dashbord_service.dart';
import 'package:dentaire/statemanagement/bloc/dashbord/dashbord_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService service;

  DashboardBloc(this.service) : super(const DashboardState(isLoading: true)) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
      LoadDashboardData event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final stats = await service.fetchStats();
      final recent = await service.fetchRecentVideos();
      emit(
          state.copyWith(isLoading: false, stats: stats, recentVideos: recent));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
