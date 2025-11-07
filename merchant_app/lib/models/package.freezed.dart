// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Package _$PackageFromJson(Map<String, dynamic> json) {
  return _Package.fromJson(json);
}

/// @nodoc
mixin _$Package {
  int get id => throw _privateConstructorUsedError;
  String get trackingCode => throw _privateConstructorUsedError;
  int get merchantId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError;
  String? get customerEmail => throw _privateConstructorUsedError;
  String get deliveryAddress => throw _privateConstructorUsedError;
  double? get deliveryLatitude => throw _privateConstructorUsedError;
  double? get deliveryLongitude => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String? get packageImage => throw _privateConstructorUsedError;
  String? get packageDescription => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int? get currentRiderId => throw _privateConstructorUsedError;
  DateTime? get assignedAt => throw _privateConstructorUsedError;
  DateTime? get pickedUpAt => throw _privateConstructorUsedError;
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  int? get deliveryAttempts => throw _privateConstructorUsedError;
  String? get deliveryNotes => throw _privateConstructorUsedError;

  /// Serializes this Package to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageCopyWith<Package> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageCopyWith<$Res> {
  factory $PackageCopyWith(Package value, $Res Function(Package) then) =
      _$PackageCopyWithImpl<$Res, Package>;
  @useResult
  $Res call({
    int id,
    String trackingCode,
    int merchantId,
    String customerName,
    String customerPhone,
    String? customerEmail,
    String deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String paymentType,
    double amount,
    String? packageImage,
    String? packageDescription,
    String status,
    int? currentRiderId,
    DateTime? assignedAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    int? deliveryAttempts,
    String? deliveryNotes,
  });
}

/// @nodoc
class _$PackageCopyWithImpl<$Res, $Val extends Package>
    implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackingCode = null,
    Object? merchantId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? customerEmail = freezed,
    Object? deliveryAddress = null,
    Object? deliveryLatitude = freezed,
    Object? deliveryLongitude = freezed,
    Object? paymentType = null,
    Object? amount = null,
    Object? packageImage = freezed,
    Object? packageDescription = freezed,
    Object? status = null,
    Object? currentRiderId = freezed,
    Object? assignedAt = freezed,
    Object? pickedUpAt = freezed,
    Object? deliveredAt = freezed,
    Object? deliveryAttempts = freezed,
    Object? deliveryNotes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            trackingCode: null == trackingCode
                ? _value.trackingCode
                : trackingCode // ignore: cast_nullable_to_non_nullable
                      as String,
            merchantId: null == merchantId
                ? _value.merchantId
                : merchantId // ignore: cast_nullable_to_non_nullable
                      as int,
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            customerPhone: null == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            customerEmail: freezed == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryAddress: null == deliveryAddress
                ? _value.deliveryAddress
                : deliveryAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryLatitude: freezed == deliveryLatitude
                ? _value.deliveryLatitude
                : deliveryLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            deliveryLongitude: freezed == deliveryLongitude
                ? _value.deliveryLongitude
                : deliveryLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            paymentType: null == paymentType
                ? _value.paymentType
                : paymentType // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            packageImage: freezed == packageImage
                ? _value.packageImage
                : packageImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageDescription: freezed == packageDescription
                ? _value.packageDescription
                : packageDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            currentRiderId: freezed == currentRiderId
                ? _value.currentRiderId
                : currentRiderId // ignore: cast_nullable_to_non_nullable
                      as int?,
            assignedAt: freezed == assignedAt
                ? _value.assignedAt
                : assignedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            pickedUpAt: freezed == pickedUpAt
                ? _value.pickedUpAt
                : pickedUpAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deliveredAt: freezed == deliveredAt
                ? _value.deliveredAt
                : deliveredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deliveryAttempts: freezed == deliveryAttempts
                ? _value.deliveryAttempts
                : deliveryAttempts // ignore: cast_nullable_to_non_nullable
                      as int?,
            deliveryNotes: freezed == deliveryNotes
                ? _value.deliveryNotes
                : deliveryNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackageImplCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$$PackageImplCopyWith(
    _$PackageImpl value,
    $Res Function(_$PackageImpl) then,
  ) = __$$PackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String trackingCode,
    int merchantId,
    String customerName,
    String customerPhone,
    String? customerEmail,
    String deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String paymentType,
    double amount,
    String? packageImage,
    String? packageDescription,
    String status,
    int? currentRiderId,
    DateTime? assignedAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    int? deliveryAttempts,
    String? deliveryNotes,
  });
}

/// @nodoc
class __$$PackageImplCopyWithImpl<$Res>
    extends _$PackageCopyWithImpl<$Res, _$PackageImpl>
    implements _$$PackageImplCopyWith<$Res> {
  __$$PackageImplCopyWithImpl(
    _$PackageImpl _value,
    $Res Function(_$PackageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackingCode = null,
    Object? merchantId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? customerEmail = freezed,
    Object? deliveryAddress = null,
    Object? deliveryLatitude = freezed,
    Object? deliveryLongitude = freezed,
    Object? paymentType = null,
    Object? amount = null,
    Object? packageImage = freezed,
    Object? packageDescription = freezed,
    Object? status = null,
    Object? currentRiderId = freezed,
    Object? assignedAt = freezed,
    Object? pickedUpAt = freezed,
    Object? deliveredAt = freezed,
    Object? deliveryAttempts = freezed,
    Object? deliveryNotes = freezed,
  }) {
    return _then(
      _$PackageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        trackingCode: null == trackingCode
            ? _value.trackingCode
            : trackingCode // ignore: cast_nullable_to_non_nullable
                  as String,
        merchantId: null == merchantId
            ? _value.merchantId
            : merchantId // ignore: cast_nullable_to_non_nullable
                  as int,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        customerPhone: null == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        customerEmail: freezed == customerEmail
            ? _value.customerEmail
            : customerEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryAddress: null == deliveryAddress
            ? _value.deliveryAddress
            : deliveryAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryLatitude: freezed == deliveryLatitude
            ? _value.deliveryLatitude
            : deliveryLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        deliveryLongitude: freezed == deliveryLongitude
            ? _value.deliveryLongitude
            : deliveryLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        paymentType: null == paymentType
            ? _value.paymentType
            : paymentType // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        packageImage: freezed == packageImage
            ? _value.packageImage
            : packageImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageDescription: freezed == packageDescription
            ? _value.packageDescription
            : packageDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        currentRiderId: freezed == currentRiderId
            ? _value.currentRiderId
            : currentRiderId // ignore: cast_nullable_to_non_nullable
                  as int?,
        assignedAt: freezed == assignedAt
            ? _value.assignedAt
            : assignedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pickedUpAt: freezed == pickedUpAt
            ? _value.pickedUpAt
            : pickedUpAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deliveredAt: freezed == deliveredAt
            ? _value.deliveredAt
            : deliveredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deliveryAttempts: freezed == deliveryAttempts
            ? _value.deliveryAttempts
            : deliveryAttempts // ignore: cast_nullable_to_non_nullable
                  as int?,
        deliveryNotes: freezed == deliveryNotes
            ? _value.deliveryNotes
            : deliveryNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageImpl implements _Package {
  const _$PackageImpl({
    required this.id,
    required this.trackingCode,
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
    required this.status,
    this.currentRiderId,
    this.assignedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.deliveryAttempts,
    this.deliveryNotes,
  });

  factory _$PackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageImplFromJson(json);

  @override
  final int id;
  @override
  final String trackingCode;
  @override
  final int merchantId;
  @override
  final String customerName;
  @override
  final String customerPhone;
  @override
  final String? customerEmail;
  @override
  final String deliveryAddress;
  @override
  final double? deliveryLatitude;
  @override
  final double? deliveryLongitude;
  @override
  final String paymentType;
  @override
  final double amount;
  @override
  final String? packageImage;
  @override
  final String? packageDescription;
  @override
  final String status;
  @override
  final int? currentRiderId;
  @override
  final DateTime? assignedAt;
  @override
  final DateTime? pickedUpAt;
  @override
  final DateTime? deliveredAt;
  @override
  final int? deliveryAttempts;
  @override
  final String? deliveryNotes;

  @override
  String toString() {
    return 'Package(id: $id, trackingCode: $trackingCode, merchantId: $merchantId, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, deliveryAddress: $deliveryAddress, deliveryLatitude: $deliveryLatitude, deliveryLongitude: $deliveryLongitude, paymentType: $paymentType, amount: $amount, packageImage: $packageImage, packageDescription: $packageDescription, status: $status, currentRiderId: $currentRiderId, assignedAt: $assignedAt, pickedUpAt: $pickedUpAt, deliveredAt: $deliveredAt, deliveryAttempts: $deliveryAttempts, deliveryNotes: $deliveryNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trackingCode, trackingCode) ||
                other.trackingCode == trackingCode) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.deliveryLatitude, deliveryLatitude) ||
                other.deliveryLatitude == deliveryLatitude) &&
            (identical(other.deliveryLongitude, deliveryLongitude) ||
                other.deliveryLongitude == deliveryLongitude) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.packageImage, packageImage) ||
                other.packageImage == packageImage) &&
            (identical(other.packageDescription, packageDescription) ||
                other.packageDescription == packageDescription) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentRiderId, currentRiderId) ||
                other.currentRiderId == currentRiderId) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.pickedUpAt, pickedUpAt) ||
                other.pickedUpAt == pickedUpAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.deliveryAttempts, deliveryAttempts) ||
                other.deliveryAttempts == deliveryAttempts) &&
            (identical(other.deliveryNotes, deliveryNotes) ||
                other.deliveryNotes == deliveryNotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    trackingCode,
    merchantId,
    customerName,
    customerPhone,
    customerEmail,
    deliveryAddress,
    deliveryLatitude,
    deliveryLongitude,
    paymentType,
    amount,
    packageImage,
    packageDescription,
    status,
    currentRiderId,
    assignedAt,
    pickedUpAt,
    deliveredAt,
    deliveryAttempts,
    deliveryNotes,
  ]);

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      __$$PackageImplCopyWithImpl<_$PackageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageImplToJson(this);
  }
}

abstract class _Package implements Package {
  const factory _Package({
    required final int id,
    required final String trackingCode,
    required final int merchantId,
    required final String customerName,
    required final String customerPhone,
    final String? customerEmail,
    required final String deliveryAddress,
    final double? deliveryLatitude,
    final double? deliveryLongitude,
    required final String paymentType,
    required final double amount,
    final String? packageImage,
    final String? packageDescription,
    required final String status,
    final int? currentRiderId,
    final DateTime? assignedAt,
    final DateTime? pickedUpAt,
    final DateTime? deliveredAt,
    final int? deliveryAttempts,
    final String? deliveryNotes,
  }) = _$PackageImpl;

  factory _Package.fromJson(Map<String, dynamic> json) = _$PackageImpl.fromJson;

  @override
  int get id;
  @override
  String get trackingCode;
  @override
  int get merchantId;
  @override
  String get customerName;
  @override
  String get customerPhone;
  @override
  String? get customerEmail;
  @override
  String get deliveryAddress;
  @override
  double? get deliveryLatitude;
  @override
  double? get deliveryLongitude;
  @override
  String get paymentType;
  @override
  double get amount;
  @override
  String? get packageImage;
  @override
  String? get packageDescription;
  @override
  String get status;
  @override
  int? get currentRiderId;
  @override
  DateTime? get assignedAt;
  @override
  DateTime? get pickedUpAt;
  @override
  DateTime? get deliveredAt;
  @override
  int? get deliveryAttempts;
  @override
  String? get deliveryNotes;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
