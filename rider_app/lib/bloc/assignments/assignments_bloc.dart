import 'package:bloc/bloc.dart';
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
        emit(AssignmentsState.failure(message: e.toString()));
      }
    });
  }

  final RiderPackageRepository repository;
}
