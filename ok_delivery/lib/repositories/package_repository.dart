import 'package:dio/dio.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../models/package_model.dart';

class PackageRepository {
  PackageRepository(this._client);
  final ApiClient _client;

  Future<BulkPackageResponse> bulkCreate(
    List<CreatePackageModel> packages,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.merchantPackagesBulk,
        data: {'packages': packages.map((p) => p.toJson()).toList()},
      );

      return BulkPackageResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Failed to create packages';
        throw Exception(errorMsg);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      } else {
        throw Exception(e.message ?? 'Network error occurred');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BulkPackageResponse> saveDraft(
    List<CreatePackageModel> packages,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.merchantDrafts,
        data: {'packages': packages.map((p) => p.toJson()).toList()},
      );

      // Check if response is HTML instead of JSON
      if (response.data is String) {
        final responseString = response.data as String;
        if (responseString.trim().startsWith('<!DOCTYPE') ||
            responseString.trim().startsWith('<html') ||
            responseString.contains('<html')) {
          throw Exception(
            'Server returned HTML instead of JSON. This usually means the database migrations have not been run. Please contact support or wait for the deployment to complete.',
          );
        }
      }

      // Ensure response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        throw Exception(
          'Invalid response format from server. Expected JSON but got: ${response.data.runtimeType}',
        );
      }

      return BulkPackageResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        // Check if response is HTML
        if (e.response?.data is String) {
          final responseString = e.response!.data as String;
          if (responseString.trim().startsWith('<!DOCTYPE') ||
              responseString.trim().startsWith('<html') ||
              responseString.contains('<html')) {
            throw Exception(
              'Server returned HTML error page. This usually means the database migrations have not been run. Please contact support.',
            );
          }
        }

        final errorMsg =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Failed to save drafts';
        throw Exception(errorMsg);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      } else {
        throw Exception(e.message ?? 'Network error occurred');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PackageModel>> getDrafts() async {
    try {
      final response = await _client.get(ApiEndpoints.merchantDrafts);

      return (response.data as List<dynamic>)
          .map((p) => PackageModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Failed to get drafts';
        throw Exception(errorMsg);
      } else {
        throw Exception(e.message ?? 'Network error occurred');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BulkPackageResponse> submitDrafts(List<int> packageIds) async {
    try {
      final response = await _client.post(
        ApiEndpoints.merchantDraftsSubmit,
        data: {'package_ids': packageIds},
      );

      return BulkPackageResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Failed to submit drafts';
        throw Exception(errorMsg);
      } else {
        throw Exception(e.message ?? 'Network error occurred');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDraft(int packageId) async {
    try {
      await _client.delete(ApiEndpoints.merchantDraftDelete(packageId));
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Failed to delete draft';
        throw Exception(errorMsg);
      } else {
        throw Exception(e.message ?? 'Network error occurred');
      }
    } catch (e) {
      rethrow;
    }
  }
}

class BulkPackageResponse {
  final String message;
  final int createdCount;
  final int submittedCount; // For submitDrafts response
  final int failedCount;
  final List<PackageModel> packages;
  final List<PackageError> errors;
  final List<ImageUploadError>? imageUploadErrors;

  BulkPackageResponse({
    required this.message,
    required this.createdCount,
    this.submittedCount = 0,
    required this.failedCount,
    required this.packages,
    required this.errors,
    this.imageUploadErrors,
  });

  factory BulkPackageResponse.fromJson(Map<String, dynamic> json) {
    return BulkPackageResponse(
      message: json['message'] as String,
      createdCount:
          json['created_count'] as int? ?? json['submitted_count'] as int? ?? 0,
      submittedCount: json['submitted_count'] as int? ?? 0,
      failedCount: json['failed_count'] as int,
      packages:
          (json['packages'] as List<dynamic>?)
              ?.map((p) => PackageModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      errors:
          (json['errors'] as List<dynamic>?)
              ?.map((e) => PackageError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      imageUploadErrors: (json['image_upload_errors'] as List<dynamic>?)
          ?.map((e) => ImageUploadError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PackageError {
  final int index;
  final String customerName;
  final String error;

  PackageError({
    required this.index,
    required this.customerName,
    required this.error,
  });

  factory PackageError.fromJson(Map<String, dynamic> json) {
    // Handle index as both int and string (backend might send either)
    int indexValue;
    if (json['index'] is int) {
      indexValue = json['index'] as int;
    } else if (json['index'] is String) {
      indexValue = int.tryParse(json['index'] as String) ?? 0;
    } else {
      indexValue = 0;
    }

    return PackageError(
      index: indexValue,
      customerName:
          json['customer_name'] as String? ??
          json['customerName'] as String? ??
          'Unknown',
      error: json['error'] as String,
    );
  }
}

class ImageUploadError {
  final String trackingCode;
  final String error;

  ImageUploadError({required this.trackingCode, required this.error});

  factory ImageUploadError.fromJson(Map<String, dynamic> json) {
    return ImageUploadError(
      trackingCode: json['tracking_code'] as String,
      error: json['error'] as String,
    );
  }
}
