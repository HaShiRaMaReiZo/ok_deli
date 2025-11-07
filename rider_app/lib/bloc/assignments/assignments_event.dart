part of 'assignments_bloc.dart';

@freezed
class AssignmentsEvent with _$AssignmentsEvent {
  const factory AssignmentsEvent.fetchRequested() = _FetchRequested;
}
