import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/package.dart';
import '../../repositories/package_repository.dart';

part 'package_event.dart';
part 'package_state.dart';
part 'package_bloc.freezed.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  PackageBloc({required this.repository}) : super(const PackageState.initial()) {
    on<_PackageFetchRequested>((event, emit) async {
      emit(const PackageState.loading());
      try {
        final items = await repository.list(page: event.page ?? 1);
        emit(PackageState.loaded(packages: items));
      } catch (e) {
        emit(PackageState.failure(message: e.toString()));
      }
    });
  }

  final PackageRepository repository;
}
