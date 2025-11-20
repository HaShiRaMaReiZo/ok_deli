// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DeliveryEvent {
  int get packageId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int packageId, String? notes) receiveFromOffice,
    required TResult Function(int packageId) startDelivery,
    required TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )
    updateStatus,
    required TResult Function(int packageId, bool success, String? notes)
    contactCustomer,
    required TResult Function(int packageId, double amount, String? imagePath)
    collectCod,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int packageId, String? notes)? receiveFromOffice,
    TResult? Function(int packageId)? startDelivery,
    TResult? Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult? Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult? Function(int packageId, double amount, String? imagePath)?
    collectCod,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int packageId, String? notes)? receiveFromOffice,
    TResult Function(int packageId)? startDelivery,
    TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult Function(int packageId, double amount, String? imagePath)?
    collectCod,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReceiveFromOffice value) receiveFromOffice,
    required TResult Function(_StartDelivery value) startDelivery,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_ContactCustomer value) contactCustomer,
    required TResult Function(_CollectCod value) collectCod,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult? Function(_StartDelivery value)? startDelivery,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_ContactCustomer value)? contactCustomer,
    TResult? Function(_CollectCod value)? collectCod,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult Function(_StartDelivery value)? startDelivery,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_ContactCustomer value)? contactCustomer,
    TResult Function(_CollectCod value)? collectCod,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryEventCopyWith<DeliveryEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryEventCopyWith<$Res> {
  factory $DeliveryEventCopyWith(
    DeliveryEvent value,
    $Res Function(DeliveryEvent) then,
  ) = _$DeliveryEventCopyWithImpl<$Res, DeliveryEvent>;
  @useResult
  $Res call({int packageId});
}

/// @nodoc
class _$DeliveryEventCopyWithImpl<$Res, $Val extends DeliveryEvent>
    implements $DeliveryEventCopyWith<$Res> {
  _$DeliveryEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null}) {
    return _then(
      _value.copyWith(
            packageId: null == packageId
                ? _value.packageId
                : packageId // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReceiveFromOfficeImplCopyWith<$Res>
    implements $DeliveryEventCopyWith<$Res> {
  factory _$$ReceiveFromOfficeImplCopyWith(
    _$ReceiveFromOfficeImpl value,
    $Res Function(_$ReceiveFromOfficeImpl) then,
  ) = __$$ReceiveFromOfficeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int packageId, String? notes});
}

/// @nodoc
class __$$ReceiveFromOfficeImplCopyWithImpl<$Res>
    extends _$DeliveryEventCopyWithImpl<$Res, _$ReceiveFromOfficeImpl>
    implements _$$ReceiveFromOfficeImplCopyWith<$Res> {
  __$$ReceiveFromOfficeImplCopyWithImpl(
    _$ReceiveFromOfficeImpl _value,
    $Res Function(_$ReceiveFromOfficeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null, Object? notes = freezed}) {
    return _then(
      _$ReceiveFromOfficeImpl(
        packageId: null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ReceiveFromOfficeImpl implements _ReceiveFromOffice {
  const _$ReceiveFromOfficeImpl({required this.packageId, this.notes});

  @override
  final int packageId;
  @override
  final String? notes;

  @override
  String toString() {
    return 'DeliveryEvent.receiveFromOffice(packageId: $packageId, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiveFromOfficeImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageId, notes);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiveFromOfficeImplCopyWith<_$ReceiveFromOfficeImpl> get copyWith =>
      __$$ReceiveFromOfficeImplCopyWithImpl<_$ReceiveFromOfficeImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int packageId, String? notes) receiveFromOffice,
    required TResult Function(int packageId) startDelivery,
    required TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )
    updateStatus,
    required TResult Function(int packageId, bool success, String? notes)
    contactCustomer,
    required TResult Function(int packageId, double amount, String? imagePath)
    collectCod,
  }) {
    return receiveFromOffice(packageId, notes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int packageId, String? notes)? receiveFromOffice,
    TResult? Function(int packageId)? startDelivery,
    TResult? Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult? Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult? Function(int packageId, double amount, String? imagePath)?
    collectCod,
  }) {
    return receiveFromOffice?.call(packageId, notes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int packageId, String? notes)? receiveFromOffice,
    TResult Function(int packageId)? startDelivery,
    TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult Function(int packageId, double amount, String? imagePath)?
    collectCod,
    required TResult orElse(),
  }) {
    if (receiveFromOffice != null) {
      return receiveFromOffice(packageId, notes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReceiveFromOffice value) receiveFromOffice,
    required TResult Function(_StartDelivery value) startDelivery,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_ContactCustomer value) contactCustomer,
    required TResult Function(_CollectCod value) collectCod,
  }) {
    return receiveFromOffice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult? Function(_StartDelivery value)? startDelivery,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_ContactCustomer value)? contactCustomer,
    TResult? Function(_CollectCod value)? collectCod,
  }) {
    return receiveFromOffice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult Function(_StartDelivery value)? startDelivery,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_ContactCustomer value)? contactCustomer,
    TResult Function(_CollectCod value)? collectCod,
    required TResult orElse(),
  }) {
    if (receiveFromOffice != null) {
      return receiveFromOffice(this);
    }
    return orElse();
  }
}

abstract class _ReceiveFromOffice implements DeliveryEvent {
  const factory _ReceiveFromOffice({
    required final int packageId,
    final String? notes,
  }) = _$ReceiveFromOfficeImpl;

  @override
  int get packageId;
  String? get notes;

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiveFromOfficeImplCopyWith<_$ReceiveFromOfficeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StartDeliveryImplCopyWith<$Res>
    implements $DeliveryEventCopyWith<$Res> {
  factory _$$StartDeliveryImplCopyWith(
    _$StartDeliveryImpl value,
    $Res Function(_$StartDeliveryImpl) then,
  ) = __$$StartDeliveryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int packageId});
}

/// @nodoc
class __$$StartDeliveryImplCopyWithImpl<$Res>
    extends _$DeliveryEventCopyWithImpl<$Res, _$StartDeliveryImpl>
    implements _$$StartDeliveryImplCopyWith<$Res> {
  __$$StartDeliveryImplCopyWithImpl(
    _$StartDeliveryImpl _value,
    $Res Function(_$StartDeliveryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null}) {
    return _then(
      _$StartDeliveryImpl(
        packageId: null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$StartDeliveryImpl implements _StartDelivery {
  const _$StartDeliveryImpl({required this.packageId});

  @override
  final int packageId;

  @override
  String toString() {
    return 'DeliveryEvent.startDelivery(packageId: $packageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartDeliveryImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageId);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartDeliveryImplCopyWith<_$StartDeliveryImpl> get copyWith =>
      __$$StartDeliveryImplCopyWithImpl<_$StartDeliveryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int packageId, String? notes) receiveFromOffice,
    required TResult Function(int packageId) startDelivery,
    required TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )
    updateStatus,
    required TResult Function(int packageId, bool success, String? notes)
    contactCustomer,
    required TResult Function(int packageId, double amount, String? imagePath)
    collectCod,
  }) {
    return startDelivery(packageId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int packageId, String? notes)? receiveFromOffice,
    TResult? Function(int packageId)? startDelivery,
    TResult? Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult? Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult? Function(int packageId, double amount, String? imagePath)?
    collectCod,
  }) {
    return startDelivery?.call(packageId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int packageId, String? notes)? receiveFromOffice,
    TResult Function(int packageId)? startDelivery,
    TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult Function(int packageId, double amount, String? imagePath)?
    collectCod,
    required TResult orElse(),
  }) {
    if (startDelivery != null) {
      return startDelivery(packageId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReceiveFromOffice value) receiveFromOffice,
    required TResult Function(_StartDelivery value) startDelivery,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_ContactCustomer value) contactCustomer,
    required TResult Function(_CollectCod value) collectCod,
  }) {
    return startDelivery(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult? Function(_StartDelivery value)? startDelivery,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_ContactCustomer value)? contactCustomer,
    TResult? Function(_CollectCod value)? collectCod,
  }) {
    return startDelivery?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult Function(_StartDelivery value)? startDelivery,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_ContactCustomer value)? contactCustomer,
    TResult Function(_CollectCod value)? collectCod,
    required TResult orElse(),
  }) {
    if (startDelivery != null) {
      return startDelivery(this);
    }
    return orElse();
  }
}

abstract class _StartDelivery implements DeliveryEvent {
  const factory _StartDelivery({required final int packageId}) =
      _$StartDeliveryImpl;

  @override
  int get packageId;

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartDeliveryImplCopyWith<_$StartDeliveryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateStatusImplCopyWith<$Res>
    implements $DeliveryEventCopyWith<$Res> {
  factory _$$UpdateStatusImplCopyWith(
    _$UpdateStatusImpl value,
    $Res Function(_$UpdateStatusImpl) then,
  ) = __$$UpdateStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int packageId,
    String status,
    String? notes,
    double? lat,
    double? lng,
  });
}

/// @nodoc
class __$$UpdateStatusImplCopyWithImpl<$Res>
    extends _$DeliveryEventCopyWithImpl<$Res, _$UpdateStatusImpl>
    implements _$$UpdateStatusImplCopyWith<$Res> {
  __$$UpdateStatusImplCopyWithImpl(
    _$UpdateStatusImpl _value,
    $Res Function(_$UpdateStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageId = null,
    Object? status = null,
    Object? notes = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(
      _$UpdateStatusImpl(
        packageId: null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        lat: freezed == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double?,
        lng: freezed == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateStatusImpl implements _UpdateStatus {
  const _$UpdateStatusImpl({
    required this.packageId,
    required this.status,
    this.notes,
    this.lat,
    this.lng,
  });

  @override
  final int packageId;
  @override
  final String status;
  @override
  final String? notes;
  @override
  final double? lat;
  @override
  final double? lng;

  @override
  String toString() {
    return 'DeliveryEvent.updateStatus(packageId: $packageId, status: $status, notes: $notes, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStatusImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, packageId, status, notes, lat, lng);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStatusImplCopyWith<_$UpdateStatusImpl> get copyWith =>
      __$$UpdateStatusImplCopyWithImpl<_$UpdateStatusImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int packageId, String? notes) receiveFromOffice,
    required TResult Function(int packageId) startDelivery,
    required TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )
    updateStatus,
    required TResult Function(int packageId, bool success, String? notes)
    contactCustomer,
    required TResult Function(int packageId, double amount, String? imagePath)
    collectCod,
  }) {
    return updateStatus(packageId, status, notes, lat, lng);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int packageId, String? notes)? receiveFromOffice,
    TResult? Function(int packageId)? startDelivery,
    TResult? Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult? Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult? Function(int packageId, double amount, String? imagePath)?
    collectCod,
  }) {
    return updateStatus?.call(packageId, status, notes, lat, lng);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int packageId, String? notes)? receiveFromOffice,
    TResult Function(int packageId)? startDelivery,
    TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult Function(int packageId, double amount, String? imagePath)?
    collectCod,
    required TResult orElse(),
  }) {
    if (updateStatus != null) {
      return updateStatus(packageId, status, notes, lat, lng);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReceiveFromOffice value) receiveFromOffice,
    required TResult Function(_StartDelivery value) startDelivery,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_ContactCustomer value) contactCustomer,
    required TResult Function(_CollectCod value) collectCod,
  }) {
    return updateStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult? Function(_StartDelivery value)? startDelivery,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_ContactCustomer value)? contactCustomer,
    TResult? Function(_CollectCod value)? collectCod,
  }) {
    return updateStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult Function(_StartDelivery value)? startDelivery,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_ContactCustomer value)? contactCustomer,
    TResult Function(_CollectCod value)? collectCod,
    required TResult orElse(),
  }) {
    if (updateStatus != null) {
      return updateStatus(this);
    }
    return orElse();
  }
}

abstract class _UpdateStatus implements DeliveryEvent {
  const factory _UpdateStatus({
    required final int packageId,
    required final String status,
    final String? notes,
    final double? lat,
    final double? lng,
  }) = _$UpdateStatusImpl;

  @override
  int get packageId;
  String get status;
  String? get notes;
  double? get lat;
  double? get lng;

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStatusImplCopyWith<_$UpdateStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ContactCustomerImplCopyWith<$Res>
    implements $DeliveryEventCopyWith<$Res> {
  factory _$$ContactCustomerImplCopyWith(
    _$ContactCustomerImpl value,
    $Res Function(_$ContactCustomerImpl) then,
  ) = __$$ContactCustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int packageId, bool success, String? notes});
}

/// @nodoc
class __$$ContactCustomerImplCopyWithImpl<$Res>
    extends _$DeliveryEventCopyWithImpl<$Res, _$ContactCustomerImpl>
    implements _$$ContactCustomerImplCopyWith<$Res> {
  __$$ContactCustomerImplCopyWithImpl(
    _$ContactCustomerImpl _value,
    $Res Function(_$ContactCustomerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageId = null,
    Object? success = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$ContactCustomerImpl(
        packageId: null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ContactCustomerImpl implements _ContactCustomer {
  const _$ContactCustomerImpl({
    required this.packageId,
    required this.success,
    this.notes,
  });

  @override
  final int packageId;
  @override
  final bool success;
  @override
  final String? notes;

  @override
  String toString() {
    return 'DeliveryEvent.contactCustomer(packageId: $packageId, success: $success, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactCustomerImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageId, success, notes);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactCustomerImplCopyWith<_$ContactCustomerImpl> get copyWith =>
      __$$ContactCustomerImplCopyWithImpl<_$ContactCustomerImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int packageId, String? notes) receiveFromOffice,
    required TResult Function(int packageId) startDelivery,
    required TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )
    updateStatus,
    required TResult Function(int packageId, bool success, String? notes)
    contactCustomer,
    required TResult Function(int packageId, double amount, String? imagePath)
    collectCod,
  }) {
    return contactCustomer(packageId, success, notes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int packageId, String? notes)? receiveFromOffice,
    TResult? Function(int packageId)? startDelivery,
    TResult? Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult? Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult? Function(int packageId, double amount, String? imagePath)?
    collectCod,
  }) {
    return contactCustomer?.call(packageId, success, notes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int packageId, String? notes)? receiveFromOffice,
    TResult Function(int packageId)? startDelivery,
    TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult Function(int packageId, double amount, String? imagePath)?
    collectCod,
    required TResult orElse(),
  }) {
    if (contactCustomer != null) {
      return contactCustomer(packageId, success, notes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReceiveFromOffice value) receiveFromOffice,
    required TResult Function(_StartDelivery value) startDelivery,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_ContactCustomer value) contactCustomer,
    required TResult Function(_CollectCod value) collectCod,
  }) {
    return contactCustomer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult? Function(_StartDelivery value)? startDelivery,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_ContactCustomer value)? contactCustomer,
    TResult? Function(_CollectCod value)? collectCod,
  }) {
    return contactCustomer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult Function(_StartDelivery value)? startDelivery,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_ContactCustomer value)? contactCustomer,
    TResult Function(_CollectCod value)? collectCod,
    required TResult orElse(),
  }) {
    if (contactCustomer != null) {
      return contactCustomer(this);
    }
    return orElse();
  }
}

abstract class _ContactCustomer implements DeliveryEvent {
  const factory _ContactCustomer({
    required final int packageId,
    required final bool success,
    final String? notes,
  }) = _$ContactCustomerImpl;

  @override
  int get packageId;
  bool get success;
  String? get notes;

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactCustomerImplCopyWith<_$ContactCustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CollectCodImplCopyWith<$Res>
    implements $DeliveryEventCopyWith<$Res> {
  factory _$$CollectCodImplCopyWith(
    _$CollectCodImpl value,
    $Res Function(_$CollectCodImpl) then,
  ) = __$$CollectCodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int packageId, double amount, String? imagePath});
}

/// @nodoc
class __$$CollectCodImplCopyWithImpl<$Res>
    extends _$DeliveryEventCopyWithImpl<$Res, _$CollectCodImpl>
    implements _$$CollectCodImplCopyWith<$Res> {
  __$$CollectCodImplCopyWithImpl(
    _$CollectCodImpl _value,
    $Res Function(_$CollectCodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageId = null,
    Object? amount = null,
    Object? imagePath = freezed,
  }) {
    return _then(
      _$CollectCodImpl(
        packageId: null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        imagePath: freezed == imagePath
            ? _value.imagePath
            : imagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CollectCodImpl implements _CollectCod {
  const _$CollectCodImpl({
    required this.packageId,
    required this.amount,
    this.imagePath,
  });

  @override
  final int packageId;
  @override
  final double amount;
  @override
  final String? imagePath;

  @override
  String toString() {
    return 'DeliveryEvent.collectCod(packageId: $packageId, amount: $amount, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectCodImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageId, amount, imagePath);

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectCodImplCopyWith<_$CollectCodImpl> get copyWith =>
      __$$CollectCodImplCopyWithImpl<_$CollectCodImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int packageId, String? notes) receiveFromOffice,
    required TResult Function(int packageId) startDelivery,
    required TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )
    updateStatus,
    required TResult Function(int packageId, bool success, String? notes)
    contactCustomer,
    required TResult Function(int packageId, double amount, String? imagePath)
    collectCod,
  }) {
    return collectCod(packageId, amount, imagePath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int packageId, String? notes)? receiveFromOffice,
    TResult? Function(int packageId)? startDelivery,
    TResult? Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult? Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult? Function(int packageId, double amount, String? imagePath)?
    collectCod,
  }) {
    return collectCod?.call(packageId, amount, imagePath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int packageId, String? notes)? receiveFromOffice,
    TResult Function(int packageId)? startDelivery,
    TResult Function(
      int packageId,
      String status,
      String? notes,
      double? lat,
      double? lng,
    )?
    updateStatus,
    TResult Function(int packageId, bool success, String? notes)?
    contactCustomer,
    TResult Function(int packageId, double amount, String? imagePath)?
    collectCod,
    required TResult orElse(),
  }) {
    if (collectCod != null) {
      return collectCod(packageId, amount, imagePath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReceiveFromOffice value) receiveFromOffice,
    required TResult Function(_StartDelivery value) startDelivery,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_ContactCustomer value) contactCustomer,
    required TResult Function(_CollectCod value) collectCod,
  }) {
    return collectCod(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult? Function(_StartDelivery value)? startDelivery,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_ContactCustomer value)? contactCustomer,
    TResult? Function(_CollectCod value)? collectCod,
  }) {
    return collectCod?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReceiveFromOffice value)? receiveFromOffice,
    TResult Function(_StartDelivery value)? startDelivery,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_ContactCustomer value)? contactCustomer,
    TResult Function(_CollectCod value)? collectCod,
    required TResult orElse(),
  }) {
    if (collectCod != null) {
      return collectCod(this);
    }
    return orElse();
  }
}

abstract class _CollectCod implements DeliveryEvent {
  const factory _CollectCod({
    required final int packageId,
    required final double amount,
    final String? imagePath,
  }) = _$CollectCodImpl;

  @override
  int get packageId;
  double get amount;
  String? get imagePath;

  /// Create a copy of DeliveryEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectCodImplCopyWith<_$CollectCodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeliveryState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) success,
    required TResult Function(String message) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? success,
    TResult? Function(String message)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Failure value) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Failure value)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryStateCopyWith<$Res> {
  factory $DeliveryStateCopyWith(
    DeliveryState value,
    $Res Function(DeliveryState) then,
  ) = _$DeliveryStateCopyWithImpl<$Res, DeliveryState>;
}

/// @nodoc
class _$DeliveryStateCopyWithImpl<$Res, $Val extends DeliveryState>
    implements $DeliveryStateCopyWith<$Res> {
  _$DeliveryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
    _$IdleImpl value,
    $Res Function(_$IdleImpl) then,
  ) = __$$IdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$DeliveryStateCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
    : super(_value, _then);

  /// Create a copy of DeliveryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'DeliveryState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) success,
    required TResult Function(String message) failure,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? success,
    TResult? Function(String message)? failure,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Failure value) failure,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Failure value)? failure,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements DeliveryState {
  const factory _Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$DeliveryStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'DeliveryState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) success,
    required TResult Function(String message) failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? success,
    TResult? Function(String message)? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Failure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Failure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements DeliveryState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
    _$SuccessImpl value,
    $Res Function(_$SuccessImpl) then,
  ) = __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$DeliveryStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
    _$SuccessImpl _value,
    $Res Function(_$SuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SuccessImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'DeliveryState.success(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DeliveryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      __$$SuccessImplCopyWithImpl<_$SuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) success,
    required TResult Function(String message) failure,
  }) {
    return success(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? success,
    TResult? Function(String message)? failure,
  }) {
    return success?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Failure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Failure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success implements DeliveryState {
  const factory _Success({required final String message}) = _$SuccessImpl;

  String get message;

  /// Create a copy of DeliveryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FailureImplCopyWith<$Res> {
  factory _$$FailureImplCopyWith(
    _$FailureImpl value,
    $Res Function(_$FailureImpl) then,
  ) = __$$FailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FailureImplCopyWithImpl<$Res>
    extends _$DeliveryStateCopyWithImpl<$Res, _$FailureImpl>
    implements _$$FailureImplCopyWith<$Res> {
  __$$FailureImplCopyWithImpl(
    _$FailureImpl _value,
    $Res Function(_$FailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$FailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FailureImpl implements _Failure {
  const _$FailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'DeliveryState.failure(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DeliveryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailureImplCopyWith<_$FailureImpl> get copyWith =>
      __$$FailureImplCopyWithImpl<_$FailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String message) success,
    required TResult Function(String message) failure,
  }) {
    return failure(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String message)? success,
    TResult? Function(String message)? failure,
  }) {
    return failure?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String message)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Failure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Failure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _Failure implements DeliveryState {
  const factory _Failure({required final String message}) = _$FailureImpl;

  String get message;

  /// Create a copy of DeliveryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailureImplCopyWith<_$FailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
