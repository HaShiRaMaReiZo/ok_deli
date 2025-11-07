// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageImpl _$$PackageImplFromJson(Map<String, dynamic> json) =>
    _$PackageImpl(
      id: (json['id'] as num).toInt(),
      trackingCode: json['trackingCode'] as String,
      merchantId: (json['merchantId'] as num).toInt(),
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerEmail: json['customerEmail'] as String?,
      deliveryAddress: json['deliveryAddress'] as String,
      deliveryLatitude: (json['deliveryLatitude'] as num?)?.toDouble(),
      deliveryLongitude: (json['deliveryLongitude'] as num?)?.toDouble(),
      paymentType: json['paymentType'] as String,
      amount: (json['amount'] as num).toDouble(),
      packageImage: json['packageImage'] as String?,
      packageDescription: json['packageDescription'] as String?,
      status: json['status'] as String,
      currentRiderId: (json['currentRiderId'] as num?)?.toInt(),
      assignedAt: json['assignedAt'] == null
          ? null
          : DateTime.parse(json['assignedAt'] as String),
      pickedUpAt: json['pickedUpAt'] == null
          ? null
          : DateTime.parse(json['pickedUpAt'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      deliveryAttempts: (json['deliveryAttempts'] as num?)?.toInt(),
      deliveryNotes: json['deliveryNotes'] as String?,
    );

Map<String, dynamic> _$$PackageImplToJson(_$PackageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trackingCode': instance.trackingCode,
      'merchantId': instance.merchantId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerEmail': instance.customerEmail,
      'deliveryAddress': instance.deliveryAddress,
      'deliveryLatitude': instance.deliveryLatitude,
      'deliveryLongitude': instance.deliveryLongitude,
      'paymentType': instance.paymentType,
      'amount': instance.amount,
      'packageImage': instance.packageImage,
      'packageDescription': instance.packageDescription,
      'status': instance.status,
      'currentRiderId': instance.currentRiderId,
      'assignedAt': instance.assignedAt?.toIso8601String(),
      'pickedUpAt': instance.pickedUpAt?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'deliveryAttempts': instance.deliveryAttempts,
      'deliveryNotes': instance.deliveryNotes,
    };
