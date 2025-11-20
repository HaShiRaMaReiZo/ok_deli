import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../repositories/rider_package_repository.dart';

part 'assignments_event.dart';
part 'assignments_state.dart';
part 'assignments_bloc.freezed.dart';

class AssignmentsBloc extends Bloc<AssignmentsEvent, AssignmentsState> {
  AssignmentsBloc({required this.repository}) : super(const AssignmentsState.loading()) {
    on<_FetchRequested>((event, emit) async {
      emit(const AssignmentsState.loading());
      try {
        final items = await repository.list();
        emit(AssignmentsState.loaded(assignments: items));
      } catch (e) {
        final errorMessage = e is DioException && e.error is String
            ? e.error as String
            : e.toString();
        emit(AssignmentsState.failure(message: errorMessage));
      }
    });
  }

  final RiderPackageRepository repository;
}
