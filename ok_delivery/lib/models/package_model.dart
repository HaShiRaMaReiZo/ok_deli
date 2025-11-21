import 'package:json_annotation/json_annotation.dart';

part 'package_model.g.dart';

@JsonSerializable()
class PackageModel {
  final int id;
  @JsonKey(name: 'tracking_code')
  final String? trackingCode; // Nullable for drafts
  @JsonKey(name: 'merchant_id')
  final int merchantId;
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'customer_phone')
  final String customerPhone;
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
  @JsonKey(name: 'delivery_address')
  final String deliveryAddress;
  @JsonKey(name: 'delivery_latitude')
  final double? deliveryLatitude;
  @JsonKey(name: 'delivery_longitude')
  final double? deliveryLongitude;
  @JsonKey(name: 'payment_type')
  final String paymentType; // 'cod' or 'prepaid'
  final double amount;
  @JsonKey(name: 'package_image')
  final String? packageImage;
  @JsonKey(name: 'package_description')
  final String? packageDescription;
  final String? status; // Nullable for drafts
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  PackageModel({
    required this.id,
    this.trackingCode,
    required this.merchantId,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail,
    required this.deliveryAddress,
    this.deliveryLatitude,
    this.deliveryLongitude,
    required this.paymentType,
    required this.amount,
    this.packageImage,
    this.packageDescription,
    this.status, // Nullable for drafts
    required this.createdAt,
    required this.updatedAt,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) =>
      _$PackageModelFromJson(json);
  Map<String, dynamic> toJson() => _$PackageModelToJson(this);
}

// Model for creating a package (without id, timestamps, etc.)
class CreatePackageModel {
  final String customerName;
  final String customerPhone;
  final String? customerEmail;
  final String deliveryAddress;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String paymentType; // 'cod' or 'prepaid'
  final double amount;
  final String? packageImage; // Base64 encoded
  final String? packageDescription;

  CreatePackageModel({
    required this.customerName,
    required this.customerPhone,
    this.customerEmail,
    required this.deliveryAddress,
    this.deliveryLatitude,
    this.deliveryLongitude,
    required this.paymentType,
    required this.amount,
    this.packageImage,
    this.packageDescription,
  });

  Map<String, dynamic> toJson() => {
    'customer_name': customerName,
    'customer_phone': customerPhone,
    if (customerEmail != null && customerEmail!.isNotEmpty)
      'customer_email': customerEmail,
    'delivery_address': deliveryAddress,
    if (deliveryLatitude != null) 'delivery_latitude': deliveryLatitude,
    if (deliveryLongitude != null) 'delivery_longitude': deliveryLongitude,
    'payment_type': paymentType,
    'amount': amount,
    if (packageImage != null && packageImage!.isNotEmpty)
      'package_image': packageImage,
    if (packageDescription != null && packageDescription!.isNotEmpty)
      'package_description': packageDescription,
  };
}
