part of 'assignments_bloc.dart';

@freezed
class AssignmentsState with _$AssignmentsState {
  const factory AssignmentsState.loading() = _Loading;
  const factory AssignmentsState.loaded({required List<Map<String, dynamic>> assignments}) = _Loaded;
  const factory AssignmentsState.failure({required String message}) = _Failure;
}
