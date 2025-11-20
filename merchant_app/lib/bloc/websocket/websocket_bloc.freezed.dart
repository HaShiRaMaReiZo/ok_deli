// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WebSocketEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connect,
    required TResult Function() disconnect,
    required TResult Function(int merchantId) subscribeToMerchant,
    required TResult Function(int packageId) subscribeToPackageLocation,
    required TResult Function(int packageId) unsubscribeFromPackageLocation,
    required TResult Function(String data) packageStatusChanged,
    required TResult Function(int packageId, String data) riderLocationUpdated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connect,
    TResult? Function()? disconnect,
    TResult? Function(int merchantId)? subscribeToMerchant,
    TResult? Function(int packageId)? subscribeToPackageLocation,
    TResult? Function(int packageId)? unsubscribeFromPackageLocation,
    TResult? Function(String data)? packageStatusChanged,
    TResult? Function(int packageId, String data)? riderLocationUpdated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connect,
    TResult Function()? disconnect,
    TResult Function(int merchantId)? subscribeToMerchant,
    TResult Function(int packageId)? subscribeToPackageLocation,
    TResult Function(int packageId)? unsubscribeFromPackageLocation,
    TResult Function(String data)? packageStatusChanged,
    TResult Function(int packageId, String data)? riderLocationUpdated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connect value) connect,
    required TResult Function(_Disconnect value) disconnect,
    required TResult Function(_SubscribeToMerchant value) subscribeToMerchant,
    required TResult Function(_SubscribeToPackageLocation value)
    subscribeToPackageLocation,
    required TResult Function(_UnsubscribeFromPackageLocation value)
    unsubscribeFromPackageLocation,
    required TResult Function(_PackageStatusChanged value) packageStatusChanged,
    required TResult Function(_RiderLocationUpdated value) riderLocationUpdated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connect value)? connect,
    TResult? Function(_Disconnect value)? disconnect,
    TResult? Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult? Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult? Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult? Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult? Function(_RiderLocationUpdated value)? riderLocationUpdated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connect value)? connect,
    TResult Function(_Disconnect value)? disconnect,
    TResult Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult Function(_RiderLocationUpdated value)? riderLocationUpdated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketEventCopyWith<$Res> {
  factory $WebSocketEventCopyWith(
    WebSocketEvent value,
    $Res Function(WebSocketEvent) then,
  ) = _$WebSocketEventCopyWithImpl<$Res, WebSocketEvent>;
}

/// @nodoc
class _$WebSocketEventCopyWithImpl<$Res, $Val extends WebSocketEvent>
    implements $WebSocketEventCopyWith<$Res> {
  _$WebSocketEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ConnectImplCopyWith<$Res> {
  factory _$$ConnectImplCopyWith(
    _$ConnectImpl value,
    $Res Function(_$ConnectImpl) then,
  ) = __$$ConnectImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConnectImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$ConnectImpl>
    implements _$$ConnectImplCopyWith<$Res> {
  __$$ConnectImplCopyWithImpl(
    _$ConnectImpl _value,
    $Res Function(_$ConnectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ConnectImpl implements _Connect {
  const _$ConnectImpl();

  @override
  String toString() {
    return 'WebSocketEvent.connect()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ConnectImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connect,
    required TResult Function() disconnect,
    required TResult Function(int merchantId) subscribeToMerchant,
    required TResult Function(int packageId) subscribeToPackageLocation,
    required TResult Function(int packageId) unsubscribeFromPackageLocation,
    required TResult Function(String data) packageStatusChanged,
    required TResult Function(int packageId, String data) riderLocationUpdated,
  }) {
    return connect();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connect,
    TResult? Function()? disconnect,
    TResult? Function(int merchantId)? subscribeToMerchant,
    TResult? Function(int packageId)? subscribeToPackageLocation,
    TResult? Function(int packageId)? unsubscribeFromPackageLocation,
    TResult? Function(String data)? packageStatusChanged,
    TResult? Function(int packageId, String data)? riderLocationUpdated,
  }) {
    return connect?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connect,
    TResult Function()? disconnect,
    TResult Function(int merchantId)? subscribeToMerchant,
    TResult Function(int packageId)? subscribeToPackageLocation,
    TResult Function(int packageId)? unsubscribeFromPackageLocation,
    TResult Function(String data)? packageStatusChanged,
    TResult Function(int packageId, String data)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (connect != null) {
      return connect();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connect value) connect,
    required TResult Function(_Disconnect value) disconnect,
    required TResult Function(_SubscribeToMerchant value) subscribeToMerchant,
    required TResult Function(_SubscribeToPackageLocation value)
    subscribeToPackageLocation,
    required TResult Function(_UnsubscribeFromPackageLocation value)
    unsubscribeFromPackageLocation,
    required TResult Function(_PackageStatusChanged value) packageStatusChanged,
    required TResult Function(_RiderLocationUpdated value) riderLocationUpdated,
  }) {
    return connect(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connect value)? connect,
    TResult? Function(_Disconnect value)? disconnect,
    TResult? Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult? Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult? Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult? Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult? Function(_RiderLocationUpdated value)? riderLocationUpdated,
  }) {
    return connect?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connect value)? connect,
    TResult Function(_Disconnect value)? disconnect,
    TResult Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult Function(_RiderLocationUpdated value)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (connect != null) {
      return connect(this);
    }
    return orElse();
  }
}

abstract class _Connect implements WebSocketEvent {
  const factory _Connect() = _$ConnectImpl;
}

/// @nodoc
abstract class _$$DisconnectImplCopyWith<$Res> {
  factory _$$DisconnectImplCopyWith(
    _$DisconnectImpl value,
    $Res Function(_$DisconnectImpl) then,
  ) = __$$DisconnectImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DisconnectImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$DisconnectImpl>
    implements _$$DisconnectImplCopyWith<$Res> {
  __$$DisconnectImplCopyWithImpl(
    _$DisconnectImpl _value,
    $Res Function(_$DisconnectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DisconnectImpl implements _Disconnect {
  const _$DisconnectImpl();

  @override
  String toString() {
    return 'WebSocketEvent.disconnect()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DisconnectImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connect,
    required TResult Function() disconnect,
    required TResult Function(int merchantId) subscribeToMerchant,
    required TResult Function(int packageId) subscribeToPackageLocation,
    required TResult Function(int packageId) unsubscribeFromPackageLocation,
    required TResult Function(String data) packageStatusChanged,
    required TResult Function(int packageId, String data) riderLocationUpdated,
  }) {
    return disconnect();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connect,
    TResult? Function()? disconnect,
    TResult? Function(int merchantId)? subscribeToMerchant,
    TResult? Function(int packageId)? subscribeToPackageLocation,
    TResult? Function(int packageId)? unsubscribeFromPackageLocation,
    TResult? Function(String data)? packageStatusChanged,
    TResult? Function(int packageId, String data)? riderLocationUpdated,
  }) {
    return disconnect?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connect,
    TResult Function()? disconnect,
    TResult Function(int merchantId)? subscribeToMerchant,
    TResult Function(int packageId)? subscribeToPackageLocation,
    TResult Function(int packageId)? unsubscribeFromPackageLocation,
    TResult Function(String data)? packageStatusChanged,
    TResult Function(int packageId, String data)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (disconnect != null) {
      return disconnect();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connect value) connect,
    required TResult Function(_Disconnect value) disconnect,
    required TResult Function(_SubscribeToMerchant value) subscribeToMerchant,
    required TResult Function(_SubscribeToPackageLocation value)
    subscribeToPackageLocation,
    required TResult Function(_UnsubscribeFromPackageLocation value)
    unsubscribeFromPackageLocation,
    required TResult Function(_PackageStatusChanged value) packageStatusChanged,
    required TResult Function(_RiderLocationUpdated value) riderLocationUpdated,
  }) {
    return disconnect(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connect value)? connect,
    TResult? Function(_Disconnect value)? disconnect,
    TResult? Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult? Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult? Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult? Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult? Function(_RiderLocationUpdated value)? riderLocationUpdated,
  }) {
    return disconnect?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connect value)? connect,
    TResult Function(_Disconnect value)? disconnect,
    TResult Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult Function(_RiderLocationUpdated value)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (disconnect != null) {
      return disconnect(this);
    }
    return orElse();
  }
}

abstract class _Disconnect implements WebSocketEvent {
  const factory _Disconnect() = _$DisconnectImpl;
}

/// @nodoc
abstract class _$$SubscribeToMerchantImplCopyWith<$Res> {
  factory _$$SubscribeToMerchantImplCopyWith(
    _$SubscribeToMerchantImpl value,
    $Res Function(_$SubscribeToMerchantImpl) then,
  ) = __$$SubscribeToMerchantImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int merchantId});
}

/// @nodoc
class __$$SubscribeToMerchantImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$SubscribeToMerchantImpl>
    implements _$$SubscribeToMerchantImplCopyWith<$Res> {
  __$$SubscribeToMerchantImplCopyWithImpl(
    _$SubscribeToMerchantImpl _value,
    $Res Function(_$SubscribeToMerchantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? merchantId = null}) {
    return _then(
      _$SubscribeToMerchantImpl(
        null == merchantId
            ? _value.merchantId
            : merchantId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SubscribeToMerchantImpl implements _SubscribeToMerchant {
  const _$SubscribeToMerchantImpl(this.merchantId);

  @override
  final int merchantId;

  @override
  String toString() {
    return 'WebSocketEvent.subscribeToMerchant(merchantId: $merchantId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscribeToMerchantImpl &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, merchantId);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscribeToMerchantImplCopyWith<_$SubscribeToMerchantImpl> get copyWith =>
      __$$SubscribeToMerchantImplCopyWithImpl<_$SubscribeToMerchantImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connect,
    required TResult Function() disconnect,
    required TResult Function(int merchantId) subscribeToMerchant,
    required TResult Function(int packageId) subscribeToPackageLocation,
    required TResult Function(int packageId) unsubscribeFromPackageLocation,
    required TResult Function(String data) packageStatusChanged,
    required TResult Function(int packageId, String data) riderLocationUpdated,
  }) {
    return subscribeToMerchant(merchantId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connect,
    TResult? Function()? disconnect,
    TResult? Function(int merchantId)? subscribeToMerchant,
    TResult? Function(int packageId)? subscribeToPackageLocation,
    TResult? Function(int packageId)? unsubscribeFromPackageLocation,
    TResult? Function(String data)? packageStatusChanged,
    TResult? Function(int packageId, String data)? riderLocationUpdated,
  }) {
    return subscribeToMerchant?.call(merchantId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connect,
    TResult Function()? disconnect,
    TResult Function(int merchantId)? subscribeToMerchant,
    TResult Function(int packageId)? subscribeToPackageLocation,
    TResult Function(int packageId)? unsubscribeFromPackageLocation,
    TResult Function(String data)? packageStatusChanged,
    TResult Function(int packageId, String data)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (subscribeToMerchant != null) {
      return subscribeToMerchant(merchantId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connect value) connect,
    required TResult Function(_Disconnect value) disconnect,
    required TResult Function(_SubscribeToMerchant value) subscribeToMerchant,
    required TResult Function(_SubscribeToPackageLocation value)
    subscribeToPackageLocation,
    required TResult Function(_UnsubscribeFromPackageLocation value)
    unsubscribeFromPackageLocation,
    required TResult Function(_PackageStatusChanged value) packageStatusChanged,
    required TResult Function(_RiderLocationUpdated value) riderLocationUpdated,
  }) {
    return subscribeToMerchant(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connect value)? connect,
    TResult? Function(_Disconnect value)? disconnect,
    TResult? Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult? Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult? Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult? Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult? Function(_RiderLocationUpdated value)? riderLocationUpdated,
  }) {
    return subscribeToMerchant?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connect value)? connect,
    TResult Function(_Disconnect value)? disconnect,
    TResult Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult Function(_RiderLocationUpdated value)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (subscribeToMerchant != null) {
      return subscribeToMerchant(this);
    }
    return orElse();
  }
}

abstract class _SubscribeToMerchant implements WebSocketEvent {
  const factory _SubscribeToMerchant(final int merchantId) =
      _$SubscribeToMerchantImpl;

  int get merchantId;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscribeToMerchantImplCopyWith<_$SubscribeToMerchantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SubscribeToPackageLocationImplCopyWith<$Res> {
  factory _$$SubscribeToPackageLocationImplCopyWith(
    _$SubscribeToPackageLocationImpl value,
    $Res Function(_$SubscribeToPackageLocationImpl) then,
  ) = __$$SubscribeToPackageLocationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int packageId});
}

/// @nodoc
class __$$SubscribeToPackageLocationImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$SubscribeToPackageLocationImpl>
    implements _$$SubscribeToPackageLocationImplCopyWith<$Res> {
  __$$SubscribeToPackageLocationImplCopyWithImpl(
    _$SubscribeToPackageLocationImpl _value,
    $Res Function(_$SubscribeToPackageLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null}) {
    return _then(
      _$SubscribeToPackageLocationImpl(
        null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SubscribeToPackageLocationImpl implements _SubscribeToPackageLocation {
  const _$SubscribeToPackageLocationImpl(this.packageId);

  @override
  final int packageId;

  @override
  String toString() {
    return 'WebSocketEvent.subscribeToPackageLocation(packageId: $packageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscribeToPackageLocationImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageId);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscribeToPackageLocationImplCopyWith<_$SubscribeToPackageLocationImpl>
  get copyWith =>
      __$$SubscribeToPackageLocationImplCopyWithImpl<
        _$SubscribeToPackageLocationImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connect,
    required TResult Function() disconnect,
    required TResult Function(int merchantId) subscribeToMerchant,
    required TResult Function(int packageId) subscribeToPackageLocation,
    required TResult Function(int packageId) unsubscribeFromPackageLocation,
    required TResult Function(String data) packageStatusChanged,
    required TResult Function(int packageId, String data) riderLocationUpdated,
  }) {
    return subscribeToPackageLocation(packageId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connect,
    TResult? Function()? disconnect,
    TResult? Function(int merchantId)? subscribeToMerchant,
    TResult? Function(int packageId)? subscribeToPackageLocation,
    TResult? Function(int packageId)? unsubscribeFromPackageLocation,
    TResult? Function(String data)? packageStatusChanged,
    TResult? Function(int packageId, String data)? riderLocationUpdated,
  }) {
    return subscribeToPackageLocation?.call(packageId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connect,
    TResult Function()? disconnect,
    TResult Function(int merchantId)? subscribeToMerchant,
    TResult Function(int packageId)? subscribeToPackageLocation,
    TResult Function(int packageId)? unsubscribeFromPackageLocation,
    TResult Function(String data)? packageStatusChanged,
    TResult Function(int packageId, String data)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (subscribeToPackageLocation != null) {
      return subscribeToPackageLocation(packageId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connect value) connect,
    required TResult Function(_Disconnect value) disconnect,
    required TResult Function(_SubscribeToMerchant value) subscribeToMerchant,
    required TResult Function(_SubscribeToPackageLocation value)
    subscribeToPackageLocation,
    required TResult Function(_UnsubscribeFromPackageLocation value)
    unsubscribeFromPackageLocation,
    required TResult Function(_PackageStatusChanged value) packageStatusChanged,
    required TResult Function(_RiderLocationUpdated value) riderLocationUpdated,
  }) {
    return subscribeToPackageLocation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connect value)? connect,
    TResult? Function(_Disconnect value)? disconnect,
    TResult? Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult? Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult? Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult? Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult? Function(_RiderLocationUpdated value)? riderLocationUpdated,
  }) {
    return subscribeToPackageLocation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connect value)? connect,
    TResult Function(_Disconnect value)? disconnect,
    TResult Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult Function(_RiderLocationUpdated value)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (subscribeToPackageLocation != null) {
      return subscribeToPackageLocation(this);
    }
    return orElse();
  }
}

abstract class _SubscribeToPackageLocation implements WebSocketEvent {
  const factory _SubscribeToPackageLocation(final int packageId) =
      _$SubscribeToPackageLocationImpl;

  int get packageId;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscribeToPackageLocationImplCopyWith<_$SubscribeToPackageLocationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnsubscribeFromPackageLocationImplCopyWith<$Res> {
  factory _$$UnsubscribeFromPackageLocationImplCopyWith(
    _$UnsubscribeFromPackageLocationImpl value,
    $Res Function(_$UnsubscribeFromPackageLocationImpl) then,
  ) = __$$UnsubscribeFromPackageLocationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int packageId});
}

/// @nodoc
class __$$UnsubscribeFromPackageLocationImplCopyWithImpl<$Res>
    extends
        _$WebSocketEventCopyWithImpl<$Res, _$UnsubscribeFromPackageLocationImpl>
    implements _$$UnsubscribeFromPackageLocationImplCopyWith<$Res> {
  __$$UnsubscribeFromPackageLocationImplCopyWithImpl(
    _$UnsubscribeFromPackageLocationImpl _value,
    $Res Function(_$UnsubscribeFromPackageLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null}) {
    return _then(
      _$UnsubscribeFromPackageLocationImpl(
        null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$UnsubscribeFromPackageLocationImpl
    implements _UnsubscribeFromPackageLocation {
  const _$UnsubscribeFromPackageLocationImpl(this.packageId);

  @override
  final int packageId;

  @override
  String toString() {
    return 'WebSocketEvent.unsubscribeFromPackageLocation(packageId: $packageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnsubscribeFromPackageLocationImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageId);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnsubscribeFromPackageLocationImplCopyWith<
    _$UnsubscribeFromPackageLocationImpl
  >
  get copyWith =>
      __$$UnsubscribeFromPackageLocationImplCopyWithImpl<
        _$UnsubscribeFromPackageLocationImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connect,
    required TResult Function() disconnect,
    required TResult Function(int merchantId) subscribeToMerchant,
    required TResult Function(int packageId) subscribeToPackageLocation,
    required TResult Function(int packageId) unsubscribeFromPackageLocation,
    required TResult Function(String data) packageStatusChanged,
    required TResult Function(int packageId, String data) riderLocationUpdated,
  }) {
    return unsubscribeFromPackageLocation(packageId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connect,
    TResult? Function()? disconnect,
    TResult? Function(int merchantId)? subscribeToMerchant,
    TResult? Function(int packageId)? subscribeToPackageLocation,
    TResult? Function(int packageId)? unsubscribeFromPackageLocation,
    TResult? Function(String data)? packageStatusChanged,
    TResult? Function(int packageId, String data)? riderLocationUpdated,
  }) {
    return unsubscribeFromPackageLocation?.call(packageId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connect,
    TResult Function()? disconnect,
    TResult Function(int merchantId)? subscribeToMerchant,
    TResult Function(int packageId)? subscribeToPackageLocation,
    TResult Function(int packageId)? unsubscribeFromPackageLocation,
    TResult Function(String data)? packageStatusChanged,
    TResult Function(int packageId, String data)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (unsubscribeFromPackageLocation != null) {
      return unsubscribeFromPackageLocation(packageId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connect value) connect,
    required TResult Function(_Disconnect value) disconnect,
    required TResult Function(_SubscribeToMerchant value) subscribeToMerchant,
    required TResult Function(_SubscribeToPackageLocation value)
    subscribeToPackageLocation,
    required TResult Function(_UnsubscribeFromPackageLocation value)
    unsubscribeFromPackageLocation,
    required TResult Function(_PackageStatusChanged value) packageStatusChanged,
    required TResult Function(_RiderLocationUpdated value) riderLocationUpdated,
  }) {
    return unsubscribeFromPackageLocation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connect value)? connect,
    TResult? Function(_Disconnect value)? disconnect,
    TResult? Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult? Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult? Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult? Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult? Function(_RiderLocationUpdated value)? riderLocationUpdated,
  }) {
    return unsubscribeFromPackageLocation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connect value)? connect,
    TResult Function(_Disconnect value)? disconnect,
    TResult Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult Function(_RiderLocationUpdated value)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (unsubscribeFromPackageLocation != null) {
      return unsubscribeFromPackageLocation(this);
    }
    return orElse();
  }
}

abstract class _UnsubscribeFromPackageLocation implements WebSocketEvent {
  const factory _UnsubscribeFromPackageLocation(final int packageId) =
      _$UnsubscribeFromPackageLocationImpl;

  int get packageId;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnsubscribeFromPackageLocationImplCopyWith<
    _$UnsubscribeFromPackageLocationImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PackageStatusChangedImplCopyWith<$Res> {
  factory _$$PackageStatusChangedImplCopyWith(
    _$PackageStatusChangedImpl value,
    $Res Function(_$PackageStatusChangedImpl) then,
  ) = __$$PackageStatusChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String data});
}

/// @nodoc
class __$$PackageStatusChangedImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$PackageStatusChangedImpl>
    implements _$$PackageStatusChangedImplCopyWith<$Res> {
  __$$PackageStatusChangedImplCopyWithImpl(
    _$PackageStatusChangedImpl _value,
    $Res Function(_$PackageStatusChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$PackageStatusChangedImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PackageStatusChangedImpl implements _PackageStatusChanged {
  const _$PackageStatusChangedImpl(this.data);

  @override
  final String data;

  @override
  String toString() {
    return 'WebSocketEvent.packageStatusChanged(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageStatusChangedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageStatusChangedImplCopyWith<_$PackageStatusChangedImpl>
  get copyWith =>
      __$$PackageStatusChangedImplCopyWithImpl<_$PackageStatusChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connect,
    required TResult Function() disconnect,
    required TResult Function(int merchantId) subscribeToMerchant,
    required TResult Function(int packageId) subscribeToPackageLocation,
    required TResult Function(int packageId) unsubscribeFromPackageLocation,
    required TResult Function(String data) packageStatusChanged,
    required TResult Function(int packageId, String data) riderLocationUpdated,
  }) {
    return packageStatusChanged(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connect,
    TResult? Function()? disconnect,
    TResult? Function(int merchantId)? subscribeToMerchant,
    TResult? Function(int packageId)? subscribeToPackageLocation,
    TResult? Function(int packageId)? unsubscribeFromPackageLocation,
    TResult? Function(String data)? packageStatusChanged,
    TResult? Function(int packageId, String data)? riderLocationUpdated,
  }) {
    return packageStatusChanged?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connect,
    TResult Function()? disconnect,
    TResult Function(int merchantId)? subscribeToMerchant,
    TResult Function(int packageId)? subscribeToPackageLocation,
    TResult Function(int packageId)? unsubscribeFromPackageLocation,
    TResult Function(String data)? packageStatusChanged,
    TResult Function(int packageId, String data)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (packageStatusChanged != null) {
      return packageStatusChanged(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connect value) connect,
    required TResult Function(_Disconnect value) disconnect,
    required TResult Function(_SubscribeToMerchant value) subscribeToMerchant,
    required TResult Function(_SubscribeToPackageLocation value)
    subscribeToPackageLocation,
    required TResult Function(_UnsubscribeFromPackageLocation value)
    unsubscribeFromPackageLocation,
    required TResult Function(_PackageStatusChanged value) packageStatusChanged,
    required TResult Function(_RiderLocationUpdated value) riderLocationUpdated,
  }) {
    return packageStatusChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connect value)? connect,
    TResult? Function(_Disconnect value)? disconnect,
    TResult? Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult? Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult? Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult? Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult? Function(_RiderLocationUpdated value)? riderLocationUpdated,
  }) {
    return packageStatusChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connect value)? connect,
    TResult Function(_Disconnect value)? disconnect,
    TResult Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult Function(_RiderLocationUpdated value)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (packageStatusChanged != null) {
      return packageStatusChanged(this);
    }
    return orElse();
  }
}

abstract class _PackageStatusChanged implements WebSocketEvent {
  const factory _PackageStatusChanged(final String data) =
      _$PackageStatusChangedImpl;

  String get data;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageStatusChangedImplCopyWith<_$PackageStatusChangedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RiderLocationUpdatedImplCopyWith<$Res> {
  factory _$$RiderLocationUpdatedImplCopyWith(
    _$RiderLocationUpdatedImpl value,
    $Res Function(_$RiderLocationUpdatedImpl) then,
  ) = __$$RiderLocationUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int packageId, String data});
}

/// @nodoc
class __$$RiderLocationUpdatedImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$RiderLocationUpdatedImpl>
    implements _$$RiderLocationUpdatedImplCopyWith<$Res> {
  __$$RiderLocationUpdatedImplCopyWithImpl(
    _$RiderLocationUpdatedImpl _value,
    $Res Function(_$RiderLocationUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null, Object? data = null}) {
    return _then(
      _$RiderLocationUpdatedImpl(
        null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RiderLocationUpdatedImpl implements _RiderLocationUpdated {
  const _$RiderLocationUpdatedImpl(this.packageId, this.data);

  @override
  final int packageId;
  @override
  final String data;

  @override
  String toString() {
    return 'WebSocketEvent.riderLocationUpdated(packageId: $packageId, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiderLocationUpdatedImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageId, data);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RiderLocationUpdatedImplCopyWith<_$RiderLocationUpdatedImpl>
  get copyWith =>
      __$$RiderLocationUpdatedImplCopyWithImpl<_$RiderLocationUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connect,
    required TResult Function() disconnect,
    required TResult Function(int merchantId) subscribeToMerchant,
    required TResult Function(int packageId) subscribeToPackageLocation,
    required TResult Function(int packageId) unsubscribeFromPackageLocation,
    required TResult Function(String data) packageStatusChanged,
    required TResult Function(int packageId, String data) riderLocationUpdated,
  }) {
    return riderLocationUpdated(packageId, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connect,
    TResult? Function()? disconnect,
    TResult? Function(int merchantId)? subscribeToMerchant,
    TResult? Function(int packageId)? subscribeToPackageLocation,
    TResult? Function(int packageId)? unsubscribeFromPackageLocation,
    TResult? Function(String data)? packageStatusChanged,
    TResult? Function(int packageId, String data)? riderLocationUpdated,
  }) {
    return riderLocationUpdated?.call(packageId, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connect,
    TResult Function()? disconnect,
    TResult Function(int merchantId)? subscribeToMerchant,
    TResult Function(int packageId)? subscribeToPackageLocation,
    TResult Function(int packageId)? unsubscribeFromPackageLocation,
    TResult Function(String data)? packageStatusChanged,
    TResult Function(int packageId, String data)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (riderLocationUpdated != null) {
      return riderLocationUpdated(packageId, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connect value) connect,
    required TResult Function(_Disconnect value) disconnect,
    required TResult Function(_SubscribeToMerchant value) subscribeToMerchant,
    required TResult Function(_SubscribeToPackageLocation value)
    subscribeToPackageLocation,
    required TResult Function(_UnsubscribeFromPackageLocation value)
    unsubscribeFromPackageLocation,
    required TResult Function(_PackageStatusChanged value) packageStatusChanged,
    required TResult Function(_RiderLocationUpdated value) riderLocationUpdated,
  }) {
    return riderLocationUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connect value)? connect,
    TResult? Function(_Disconnect value)? disconnect,
    TResult? Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult? Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult? Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult? Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult? Function(_RiderLocationUpdated value)? riderLocationUpdated,
  }) {
    return riderLocationUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connect value)? connect,
    TResult Function(_Disconnect value)? disconnect,
    TResult Function(_SubscribeToMerchant value)? subscribeToMerchant,
    TResult Function(_SubscribeToPackageLocation value)?
    subscribeToPackageLocation,
    TResult Function(_UnsubscribeFromPackageLocation value)?
    unsubscribeFromPackageLocation,
    TResult Function(_PackageStatusChanged value)? packageStatusChanged,
    TResult Function(_RiderLocationUpdated value)? riderLocationUpdated,
    required TResult orElse(),
  }) {
    if (riderLocationUpdated != null) {
      return riderLocationUpdated(this);
    }
    return orElse();
  }
}

abstract class _RiderLocationUpdated implements WebSocketEvent {
  const factory _RiderLocationUpdated(final int packageId, final String data) =
      _$RiderLocationUpdatedImpl;

  int get packageId;
  String get data;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiderLocationUpdatedImplCopyWith<_$RiderLocationUpdatedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WebSocketState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connected,
    required TResult Function(int merchantId) subscribedToMerchant,
    required TResult Function(int packageId) subscribedToPackageLocation,
    required TResult Function(String message) error,
    required TResult Function(String data) packageUpdateReceived,
    required TResult Function(int packageId, String data)
    riderLocationUpdateReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? disconnected,
    TResult? Function()? connected,
    TResult? Function(int merchantId)? subscribedToMerchant,
    TResult? Function(int packageId)? subscribedToPackageLocation,
    TResult? Function(String message)? error,
    TResult? Function(String data)? packageUpdateReceived,
    TResult? Function(int packageId, String data)? riderLocationUpdateReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connected,
    TResult Function(int merchantId)? subscribedToMerchant,
    TResult Function(int packageId)? subscribedToPackageLocation,
    TResult Function(String message)? error,
    TResult Function(String data)? packageUpdateReceived,
    TResult Function(int packageId, String data)? riderLocationUpdateReceived,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Connected value) connected,
    required TResult Function(_SubscribedToMerchant value) subscribedToMerchant,
    required TResult Function(_SubscribedToPackageLocation value)
    subscribedToPackageLocation,
    required TResult Function(_Error value) error,
    required TResult Function(_PackageUpdateReceived value)
    packageUpdateReceived,
    required TResult Function(_RiderLocationUpdateReceived value)
    riderLocationUpdateReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Connected value)? connected,
    TResult? Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult? Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult? Function(_Error value)? error,
    TResult? Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult? Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Connected value)? connected,
    TResult Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult Function(_Error value)? error,
    TResult Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketStateCopyWith<$Res> {
  factory $WebSocketStateCopyWith(
    WebSocketState value,
    $Res Function(WebSocketState) then,
  ) = _$WebSocketStateCopyWithImpl<$Res, WebSocketState>;
}

/// @nodoc
class _$WebSocketStateCopyWithImpl<$Res, $Val extends WebSocketState>
    implements $WebSocketStateCopyWith<$Res> {
  _$WebSocketStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DisconnectedImplCopyWith<$Res> {
  factory _$$DisconnectedImplCopyWith(
    _$DisconnectedImpl value,
    $Res Function(_$DisconnectedImpl) then,
  ) = __$$DisconnectedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DisconnectedImplCopyWithImpl<$Res>
    extends _$WebSocketStateCopyWithImpl<$Res, _$DisconnectedImpl>
    implements _$$DisconnectedImplCopyWith<$Res> {
  __$$DisconnectedImplCopyWithImpl(
    _$DisconnectedImpl _value,
    $Res Function(_$DisconnectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DisconnectedImpl implements _Disconnected {
  const _$DisconnectedImpl();

  @override
  String toString() {
    return 'WebSocketState.disconnected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DisconnectedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connected,
    required TResult Function(int merchantId) subscribedToMerchant,
    required TResult Function(int packageId) subscribedToPackageLocation,
    required TResult Function(String message) error,
    required TResult Function(String data) packageUpdateReceived,
    required TResult Function(int packageId, String data)
    riderLocationUpdateReceived,
  }) {
    return disconnected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? disconnected,
    TResult? Function()? connected,
    TResult? Function(int merchantId)? subscribedToMerchant,
    TResult? Function(int packageId)? subscribedToPackageLocation,
    TResult? Function(String message)? error,
    TResult? Function(String data)? packageUpdateReceived,
    TResult? Function(int packageId, String data)? riderLocationUpdateReceived,
  }) {
    return disconnected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connected,
    TResult Function(int merchantId)? subscribedToMerchant,
    TResult Function(int packageId)? subscribedToPackageLocation,
    TResult Function(String message)? error,
    TResult Function(String data)? packageUpdateReceived,
    TResult Function(int packageId, String data)? riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Connected value) connected,
    required TResult Function(_SubscribedToMerchant value) subscribedToMerchant,
    required TResult Function(_SubscribedToPackageLocation value)
    subscribedToPackageLocation,
    required TResult Function(_Error value) error,
    required TResult Function(_PackageUpdateReceived value)
    packageUpdateReceived,
    required TResult Function(_RiderLocationUpdateReceived value)
    riderLocationUpdateReceived,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Connected value)? connected,
    TResult? Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult? Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult? Function(_Error value)? error,
    TResult? Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult? Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Connected value)? connected,
    TResult Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult Function(_Error value)? error,
    TResult Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }
}

abstract class _Disconnected implements WebSocketState {
  const factory _Disconnected() = _$DisconnectedImpl;
}

/// @nodoc
abstract class _$$ConnectedImplCopyWith<$Res> {
  factory _$$ConnectedImplCopyWith(
    _$ConnectedImpl value,
    $Res Function(_$ConnectedImpl) then,
  ) = __$$ConnectedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConnectedImplCopyWithImpl<$Res>
    extends _$WebSocketStateCopyWithImpl<$Res, _$ConnectedImpl>
    implements _$$ConnectedImplCopyWith<$Res> {
  __$$ConnectedImplCopyWithImpl(
    _$ConnectedImpl _value,
    $Res Function(_$ConnectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ConnectedImpl implements _Connected {
  const _$ConnectedImpl();

  @override
  String toString() {
    return 'WebSocketState.connected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ConnectedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connected,
    required TResult Function(int merchantId) subscribedToMerchant,
    required TResult Function(int packageId) subscribedToPackageLocation,
    required TResult Function(String message) error,
    required TResult Function(String data) packageUpdateReceived,
    required TResult Function(int packageId, String data)
    riderLocationUpdateReceived,
  }) {
    return connected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? disconnected,
    TResult? Function()? connected,
    TResult? Function(int merchantId)? subscribedToMerchant,
    TResult? Function(int packageId)? subscribedToPackageLocation,
    TResult? Function(String message)? error,
    TResult? Function(String data)? packageUpdateReceived,
    TResult? Function(int packageId, String data)? riderLocationUpdateReceived,
  }) {
    return connected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connected,
    TResult Function(int merchantId)? subscribedToMerchant,
    TResult Function(int packageId)? subscribedToPackageLocation,
    TResult Function(String message)? error,
    TResult Function(String data)? packageUpdateReceived,
    TResult Function(int packageId, String data)? riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Connected value) connected,
    required TResult Function(_SubscribedToMerchant value) subscribedToMerchant,
    required TResult Function(_SubscribedToPackageLocation value)
    subscribedToPackageLocation,
    required TResult Function(_Error value) error,
    required TResult Function(_PackageUpdateReceived value)
    packageUpdateReceived,
    required TResult Function(_RiderLocationUpdateReceived value)
    riderLocationUpdateReceived,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Connected value)? connected,
    TResult? Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult? Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult? Function(_Error value)? error,
    TResult? Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult? Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Connected value)? connected,
    TResult Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult Function(_Error value)? error,
    TResult Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class _Connected implements WebSocketState {
  const factory _Connected() = _$ConnectedImpl;
}

/// @nodoc
abstract class _$$SubscribedToMerchantImplCopyWith<$Res> {
  factory _$$SubscribedToMerchantImplCopyWith(
    _$SubscribedToMerchantImpl value,
    $Res Function(_$SubscribedToMerchantImpl) then,
  ) = __$$SubscribedToMerchantImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int merchantId});
}

/// @nodoc
class __$$SubscribedToMerchantImplCopyWithImpl<$Res>
    extends _$WebSocketStateCopyWithImpl<$Res, _$SubscribedToMerchantImpl>
    implements _$$SubscribedToMerchantImplCopyWith<$Res> {
  __$$SubscribedToMerchantImplCopyWithImpl(
    _$SubscribedToMerchantImpl _value,
    $Res Function(_$SubscribedToMerchantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? merchantId = null}) {
    return _then(
      _$SubscribedToMerchantImpl(
        null == merchantId
            ? _value.merchantId
            : merchantId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SubscribedToMerchantImpl implements _SubscribedToMerchant {
  const _$SubscribedToMerchantImpl(this.merchantId);

  @override
  final int merchantId;

  @override
  String toString() {
    return 'WebSocketState.subscribedToMerchant(merchantId: $merchantId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscribedToMerchantImpl &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, merchantId);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscribedToMerchantImplCopyWith<_$SubscribedToMerchantImpl>
  get copyWith =>
      __$$SubscribedToMerchantImplCopyWithImpl<_$SubscribedToMerchantImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connected,
    required TResult Function(int merchantId) subscribedToMerchant,
    required TResult Function(int packageId) subscribedToPackageLocation,
    required TResult Function(String message) error,
    required TResult Function(String data) packageUpdateReceived,
    required TResult Function(int packageId, String data)
    riderLocationUpdateReceived,
  }) {
    return subscribedToMerchant(merchantId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? disconnected,
    TResult? Function()? connected,
    TResult? Function(int merchantId)? subscribedToMerchant,
    TResult? Function(int packageId)? subscribedToPackageLocation,
    TResult? Function(String message)? error,
    TResult? Function(String data)? packageUpdateReceived,
    TResult? Function(int packageId, String data)? riderLocationUpdateReceived,
  }) {
    return subscribedToMerchant?.call(merchantId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connected,
    TResult Function(int merchantId)? subscribedToMerchant,
    TResult Function(int packageId)? subscribedToPackageLocation,
    TResult Function(String message)? error,
    TResult Function(String data)? packageUpdateReceived,
    TResult Function(int packageId, String data)? riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (subscribedToMerchant != null) {
      return subscribedToMerchant(merchantId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Connected value) connected,
    required TResult Function(_SubscribedToMerchant value) subscribedToMerchant,
    required TResult Function(_SubscribedToPackageLocation value)
    subscribedToPackageLocation,
    required TResult Function(_Error value) error,
    required TResult Function(_PackageUpdateReceived value)
    packageUpdateReceived,
    required TResult Function(_RiderLocationUpdateReceived value)
    riderLocationUpdateReceived,
  }) {
    return subscribedToMerchant(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Connected value)? connected,
    TResult? Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult? Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult? Function(_Error value)? error,
    TResult? Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult? Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
  }) {
    return subscribedToMerchant?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Connected value)? connected,
    TResult Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult Function(_Error value)? error,
    TResult Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (subscribedToMerchant != null) {
      return subscribedToMerchant(this);
    }
    return orElse();
  }
}

abstract class _SubscribedToMerchant implements WebSocketState {
  const factory _SubscribedToMerchant(final int merchantId) =
      _$SubscribedToMerchantImpl;

  int get merchantId;

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscribedToMerchantImplCopyWith<_$SubscribedToMerchantImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SubscribedToPackageLocationImplCopyWith<$Res> {
  factory _$$SubscribedToPackageLocationImplCopyWith(
    _$SubscribedToPackageLocationImpl value,
    $Res Function(_$SubscribedToPackageLocationImpl) then,
  ) = __$$SubscribedToPackageLocationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int packageId});
}

/// @nodoc
class __$$SubscribedToPackageLocationImplCopyWithImpl<$Res>
    extends
        _$WebSocketStateCopyWithImpl<$Res, _$SubscribedToPackageLocationImpl>
    implements _$$SubscribedToPackageLocationImplCopyWith<$Res> {
  __$$SubscribedToPackageLocationImplCopyWithImpl(
    _$SubscribedToPackageLocationImpl _value,
    $Res Function(_$SubscribedToPackageLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null}) {
    return _then(
      _$SubscribedToPackageLocationImpl(
        null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SubscribedToPackageLocationImpl
    implements _SubscribedToPackageLocation {
  const _$SubscribedToPackageLocationImpl(this.packageId);

  @override
  final int packageId;

  @override
  String toString() {
    return 'WebSocketState.subscribedToPackageLocation(packageId: $packageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscribedToPackageLocationImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageId);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscribedToPackageLocationImplCopyWith<_$SubscribedToPackageLocationImpl>
  get copyWith =>
      __$$SubscribedToPackageLocationImplCopyWithImpl<
        _$SubscribedToPackageLocationImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connected,
    required TResult Function(int merchantId) subscribedToMerchant,
    required TResult Function(int packageId) subscribedToPackageLocation,
    required TResult Function(String message) error,
    required TResult Function(String data) packageUpdateReceived,
    required TResult Function(int packageId, String data)
    riderLocationUpdateReceived,
  }) {
    return subscribedToPackageLocation(packageId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? disconnected,
    TResult? Function()? connected,
    TResult? Function(int merchantId)? subscribedToMerchant,
    TResult? Function(int packageId)? subscribedToPackageLocation,
    TResult? Function(String message)? error,
    TResult? Function(String data)? packageUpdateReceived,
    TResult? Function(int packageId, String data)? riderLocationUpdateReceived,
  }) {
    return subscribedToPackageLocation?.call(packageId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connected,
    TResult Function(int merchantId)? subscribedToMerchant,
    TResult Function(int packageId)? subscribedToPackageLocation,
    TResult Function(String message)? error,
    TResult Function(String data)? packageUpdateReceived,
    TResult Function(int packageId, String data)? riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (subscribedToPackageLocation != null) {
      return subscribedToPackageLocation(packageId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Connected value) connected,
    required TResult Function(_SubscribedToMerchant value) subscribedToMerchant,
    required TResult Function(_SubscribedToPackageLocation value)
    subscribedToPackageLocation,
    required TResult Function(_Error value) error,
    required TResult Function(_PackageUpdateReceived value)
    packageUpdateReceived,
    required TResult Function(_RiderLocationUpdateReceived value)
    riderLocationUpdateReceived,
  }) {
    return subscribedToPackageLocation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Connected value)? connected,
    TResult? Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult? Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult? Function(_Error value)? error,
    TResult? Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult? Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
  }) {
    return subscribedToPackageLocation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Connected value)? connected,
    TResult Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult Function(_Error value)? error,
    TResult Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (subscribedToPackageLocation != null) {
      return subscribedToPackageLocation(this);
    }
    return orElse();
  }
}

abstract class _SubscribedToPackageLocation implements WebSocketState {
  const factory _SubscribedToPackageLocation(final int packageId) =
      _$SubscribedToPackageLocationImpl;

  int get packageId;

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscribedToPackageLocationImplCopyWith<_$SubscribedToPackageLocationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$WebSocketStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'WebSocketState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connected,
    required TResult Function(int merchantId) subscribedToMerchant,
    required TResult Function(int packageId) subscribedToPackageLocation,
    required TResult Function(String message) error,
    required TResult Function(String data) packageUpdateReceived,
    required TResult Function(int packageId, String data)
    riderLocationUpdateReceived,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? disconnected,
    TResult? Function()? connected,
    TResult? Function(int merchantId)? subscribedToMerchant,
    TResult? Function(int packageId)? subscribedToPackageLocation,
    TResult? Function(String message)? error,
    TResult? Function(String data)? packageUpdateReceived,
    TResult? Function(int packageId, String data)? riderLocationUpdateReceived,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connected,
    TResult Function(int merchantId)? subscribedToMerchant,
    TResult Function(int packageId)? subscribedToPackageLocation,
    TResult Function(String message)? error,
    TResult Function(String data)? packageUpdateReceived,
    TResult Function(int packageId, String data)? riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Connected value) connected,
    required TResult Function(_SubscribedToMerchant value) subscribedToMerchant,
    required TResult Function(_SubscribedToPackageLocation value)
    subscribedToPackageLocation,
    required TResult Function(_Error value) error,
    required TResult Function(_PackageUpdateReceived value)
    packageUpdateReceived,
    required TResult Function(_RiderLocationUpdateReceived value)
    riderLocationUpdateReceived,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Connected value)? connected,
    TResult? Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult? Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult? Function(_Error value)? error,
    TResult? Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult? Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Connected value)? connected,
    TResult Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult Function(_Error value)? error,
    TResult Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements WebSocketState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PackageUpdateReceivedImplCopyWith<$Res> {
  factory _$$PackageUpdateReceivedImplCopyWith(
    _$PackageUpdateReceivedImpl value,
    $Res Function(_$PackageUpdateReceivedImpl) then,
  ) = __$$PackageUpdateReceivedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String data});
}

/// @nodoc
class __$$PackageUpdateReceivedImplCopyWithImpl<$Res>
    extends _$WebSocketStateCopyWithImpl<$Res, _$PackageUpdateReceivedImpl>
    implements _$$PackageUpdateReceivedImplCopyWith<$Res> {
  __$$PackageUpdateReceivedImplCopyWithImpl(
    _$PackageUpdateReceivedImpl _value,
    $Res Function(_$PackageUpdateReceivedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$PackageUpdateReceivedImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PackageUpdateReceivedImpl implements _PackageUpdateReceived {
  const _$PackageUpdateReceivedImpl(this.data);

  @override
  final String data;

  @override
  String toString() {
    return 'WebSocketState.packageUpdateReceived(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageUpdateReceivedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageUpdateReceivedImplCopyWith<_$PackageUpdateReceivedImpl>
  get copyWith =>
      __$$PackageUpdateReceivedImplCopyWithImpl<_$PackageUpdateReceivedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connected,
    required TResult Function(int merchantId) subscribedToMerchant,
    required TResult Function(int packageId) subscribedToPackageLocation,
    required TResult Function(String message) error,
    required TResult Function(String data) packageUpdateReceived,
    required TResult Function(int packageId, String data)
    riderLocationUpdateReceived,
  }) {
    return packageUpdateReceived(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? disconnected,
    TResult? Function()? connected,
    TResult? Function(int merchantId)? subscribedToMerchant,
    TResult? Function(int packageId)? subscribedToPackageLocation,
    TResult? Function(String message)? error,
    TResult? Function(String data)? packageUpdateReceived,
    TResult? Function(int packageId, String data)? riderLocationUpdateReceived,
  }) {
    return packageUpdateReceived?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connected,
    TResult Function(int merchantId)? subscribedToMerchant,
    TResult Function(int packageId)? subscribedToPackageLocation,
    TResult Function(String message)? error,
    TResult Function(String data)? packageUpdateReceived,
    TResult Function(int packageId, String data)? riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (packageUpdateReceived != null) {
      return packageUpdateReceived(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Connected value) connected,
    required TResult Function(_SubscribedToMerchant value) subscribedToMerchant,
    required TResult Function(_SubscribedToPackageLocation value)
    subscribedToPackageLocation,
    required TResult Function(_Error value) error,
    required TResult Function(_PackageUpdateReceived value)
    packageUpdateReceived,
    required TResult Function(_RiderLocationUpdateReceived value)
    riderLocationUpdateReceived,
  }) {
    return packageUpdateReceived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Connected value)? connected,
    TResult? Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult? Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult? Function(_Error value)? error,
    TResult? Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult? Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
  }) {
    return packageUpdateReceived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Connected value)? connected,
    TResult Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult Function(_Error value)? error,
    TResult Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (packageUpdateReceived != null) {
      return packageUpdateReceived(this);
    }
    return orElse();
  }
}

abstract class _PackageUpdateReceived implements WebSocketState {
  const factory _PackageUpdateReceived(final String data) =
      _$PackageUpdateReceivedImpl;

  String get data;

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageUpdateReceivedImplCopyWith<_$PackageUpdateReceivedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RiderLocationUpdateReceivedImplCopyWith<$Res> {
  factory _$$RiderLocationUpdateReceivedImplCopyWith(
    _$RiderLocationUpdateReceivedImpl value,
    $Res Function(_$RiderLocationUpdateReceivedImpl) then,
  ) = __$$RiderLocationUpdateReceivedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int packageId, String data});
}

/// @nodoc
class __$$RiderLocationUpdateReceivedImplCopyWithImpl<$Res>
    extends
        _$WebSocketStateCopyWithImpl<$Res, _$RiderLocationUpdateReceivedImpl>
    implements _$$RiderLocationUpdateReceivedImplCopyWith<$Res> {
  __$$RiderLocationUpdateReceivedImplCopyWithImpl(
    _$RiderLocationUpdateReceivedImpl _value,
    $Res Function(_$RiderLocationUpdateReceivedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? packageId = null, Object? data = null}) {
    return _then(
      _$RiderLocationUpdateReceivedImpl(
        null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as int,
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RiderLocationUpdateReceivedImpl
    implements _RiderLocationUpdateReceived {
  const _$RiderLocationUpdateReceivedImpl(this.packageId, this.data);

  @override
  final int packageId;
  @override
  final String data;

  @override
  String toString() {
    return 'WebSocketState.riderLocationUpdateReceived(packageId: $packageId, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiderLocationUpdateReceivedImpl &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageId, data);

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RiderLocationUpdateReceivedImplCopyWith<_$RiderLocationUpdateReceivedImpl>
  get copyWith =>
      __$$RiderLocationUpdateReceivedImplCopyWithImpl<
        _$RiderLocationUpdateReceivedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connected,
    required TResult Function(int merchantId) subscribedToMerchant,
    required TResult Function(int packageId) subscribedToPackageLocation,
    required TResult Function(String message) error,
    required TResult Function(String data) packageUpdateReceived,
    required TResult Function(int packageId, String data)
    riderLocationUpdateReceived,
  }) {
    return riderLocationUpdateReceived(packageId, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? disconnected,
    TResult? Function()? connected,
    TResult? Function(int merchantId)? subscribedToMerchant,
    TResult? Function(int packageId)? subscribedToPackageLocation,
    TResult? Function(String message)? error,
    TResult? Function(String data)? packageUpdateReceived,
    TResult? Function(int packageId, String data)? riderLocationUpdateReceived,
  }) {
    return riderLocationUpdateReceived?.call(packageId, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connected,
    TResult Function(int merchantId)? subscribedToMerchant,
    TResult Function(int packageId)? subscribedToPackageLocation,
    TResult Function(String message)? error,
    TResult Function(String data)? packageUpdateReceived,
    TResult Function(int packageId, String data)? riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (riderLocationUpdateReceived != null) {
      return riderLocationUpdateReceived(packageId, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Connected value) connected,
    required TResult Function(_SubscribedToMerchant value) subscribedToMerchant,
    required TResult Function(_SubscribedToPackageLocation value)
    subscribedToPackageLocation,
    required TResult Function(_Error value) error,
    required TResult Function(_PackageUpdateReceived value)
    packageUpdateReceived,
    required TResult Function(_RiderLocationUpdateReceived value)
    riderLocationUpdateReceived,
  }) {
    return riderLocationUpdateReceived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Connected value)? connected,
    TResult? Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult? Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult? Function(_Error value)? error,
    TResult? Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult? Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
  }) {
    return riderLocationUpdateReceived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Connected value)? connected,
    TResult Function(_SubscribedToMerchant value)? subscribedToMerchant,
    TResult Function(_SubscribedToPackageLocation value)?
    subscribedToPackageLocation,
    TResult Function(_Error value)? error,
    TResult Function(_PackageUpdateReceived value)? packageUpdateReceived,
    TResult Function(_RiderLocationUpdateReceived value)?
    riderLocationUpdateReceived,
    required TResult orElse(),
  }) {
    if (riderLocationUpdateReceived != null) {
      return riderLocationUpdateReceived(this);
    }
    return orElse();
  }
}

abstract class _RiderLocationUpdateReceived implements WebSocketState {
  const factory _RiderLocationUpdateReceived(
    final int packageId,
    final String data,
  ) = _$RiderLocationUpdateReceivedImpl;

  int get packageId;
  String get data;

  /// Create a copy of WebSocketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiderLocationUpdateReceivedImplCopyWith<_$RiderLocationUpdateReceivedImpl>
  get copyWith => throw _privateConstructorUsedError;
}
