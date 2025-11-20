import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/package.dart';
import '../../repositories/package_repository.dart';

part 'package_event.dart';
part 'package_state.dart';
part 'package_bloc.freezed.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  PackageBloc({required this.repository})
    : super(const PackageState.initial()) {
    on<_PackageFetchRequested>((event, emit) async {
      emit(const PackageState.loading());
      try {
        final items = await repository.list(page: event.page ?? 1);
        // If we get an empty list, that's not an error - show empty state
        emit(PackageState.loaded(packages: items));
      } catch (e, stackTrace) {
        // Log the full error for debugging
        print('PackageBloc error: $e');
        print('Stack trace: $stackTrace');

        String errorMessage;
        if (e is DioException) {
          // Check for authentication errors (401, redirect loops)
          final statusCode = e.response?.statusCode;
          if (statusCode == 401 ||
              e.error?.toString().contains('RedirectException') == true ||
              e.error?.toString().contains('Redirect loop') == true) {
            errorMessage = 'Authentication failed. Please login again.';
          } else {
            // Get error message from DioException
            errorMessage =
                e.response?.data?['message']?.toString() ??
                e.message ??
                e.error?.toString() ??
                e.toString();
          }
        } else {
          errorMessage = e.toString();
        }
        emit(PackageState.failure(message: errorMessage));
      }
    });
  }

  final PackageRepository repository;
}
