import 'package:freezed_annotation/freezed_annotation.dart';

part 'package.freezed.dart';
part 'package.g.dart';

@freezed
class Package with _$Package {
  const factory Package({
    required int id,
    required String trackingCode,
    required int merchantId,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    required String deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    required String paymentType,
    required double amount,
    String? packageImage,
    String? packageDescription,
    required String status,
    int? currentRiderId,
    DateTime? assignedAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    int? deliveryAttempts,
    String? deliveryNotes,
  }) = _Package;

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);
}
