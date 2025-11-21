import 'package:json_annotation/json_annotation.dart';

part 'merchant_model.g.dart';

@JsonSerializable()
class MerchantModel {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'business_name')
  final String businessName;
  @JsonKey(name: 'business_address')
  final String businessAddress;
  @JsonKey(name: 'business_phone')
  final String businessPhone;
  @JsonKey(name: 'business_email')
  final String businessEmail;
  @JsonKey(name: 'registration_number')
  final String? registrationNumber;
  @JsonKey(name: 'rating', fromJson: _ratingFromJson)
  final double rating;
  @JsonKey(name: 'total_deliveries')
  final int totalDeliveries;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  MerchantModel({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.businessAddress,
    required this.businessPhone,
    required this.businessEmail,
    this.registrationNumber,
    required this.rating,
    required this.totalDeliveries,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantModelFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantModelToJson(this);

  static double _ratingFromJson(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
