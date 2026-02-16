// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'latest_launch_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LatestLaunchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestLaunchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LatestLaunchState()';
}


}

/// @nodoc
class $LatestLaunchStateCopyWith<$Res>  {
$LatestLaunchStateCopyWith(LatestLaunchState _, $Res Function(LatestLaunchState) __);
}


/// Adds pattern-matching-related methods to [LatestLaunchState].
extension LatestLaunchStatePatterns on LatestLaunchState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LatestLaunchInitial value)?  initial,TResult Function( LatestLaunchLoading value)?  loading,TResult Function( LatestLaunchLoaded value)?  loaded,TResult Function( LatestLaunchError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LatestLaunchInitial() when initial != null:
return initial(_that);case LatestLaunchLoading() when loading != null:
return loading(_that);case LatestLaunchLoaded() when loaded != null:
return loaded(_that);case LatestLaunchError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LatestLaunchInitial value)  initial,required TResult Function( LatestLaunchLoading value)  loading,required TResult Function( LatestLaunchLoaded value)  loaded,required TResult Function( LatestLaunchError value)  error,}){
final _that = this;
switch (_that) {
case LatestLaunchInitial():
return initial(_that);case LatestLaunchLoading():
return loading(_that);case LatestLaunchLoaded():
return loaded(_that);case LatestLaunchError():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LatestLaunchInitial value)?  initial,TResult? Function( LatestLaunchLoading value)?  loading,TResult? Function( LatestLaunchLoaded value)?  loaded,TResult? Function( LatestLaunchError value)?  error,}){
final _that = this;
switch (_that) {
case LatestLaunchInitial() when initial != null:
return initial(_that);case LatestLaunchLoading() when loading != null:
return loading(_that);case LatestLaunchLoaded() when loaded != null:
return loaded(_that);case LatestLaunchError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Launch launch)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LatestLaunchInitial() when initial != null:
return initial();case LatestLaunchLoading() when loading != null:
return loading();case LatestLaunchLoaded() when loaded != null:
return loaded(_that.launch);case LatestLaunchError() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Launch launch)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case LatestLaunchInitial():
return initial();case LatestLaunchLoading():
return loading();case LatestLaunchLoaded():
return loaded(_that.launch);case LatestLaunchError():
return error(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Launch launch)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case LatestLaunchInitial() when initial != null:
return initial();case LatestLaunchLoading() when loading != null:
return loading();case LatestLaunchLoaded() when loaded != null:
return loaded(_that.launch);case LatestLaunchError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class LatestLaunchInitial implements LatestLaunchState {
  const LatestLaunchInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestLaunchInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LatestLaunchState.initial()';
}


}




/// @nodoc


class LatestLaunchLoading implements LatestLaunchState {
  const LatestLaunchLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestLaunchLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LatestLaunchState.loading()';
}


}




/// @nodoc


class LatestLaunchLoaded implements LatestLaunchState {
  const LatestLaunchLoaded(this.launch);
  

 final  Launch launch;

/// Create a copy of LatestLaunchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatestLaunchLoadedCopyWith<LatestLaunchLoaded> get copyWith => _$LatestLaunchLoadedCopyWithImpl<LatestLaunchLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestLaunchLoaded&&(identical(other.launch, launch) || other.launch == launch));
}


@override
int get hashCode => Object.hash(runtimeType,launch);

@override
String toString() {
  return 'LatestLaunchState.loaded(launch: $launch)';
}


}

/// @nodoc
abstract mixin class $LatestLaunchLoadedCopyWith<$Res> implements $LatestLaunchStateCopyWith<$Res> {
  factory $LatestLaunchLoadedCopyWith(LatestLaunchLoaded value, $Res Function(LatestLaunchLoaded) _then) = _$LatestLaunchLoadedCopyWithImpl;
@useResult
$Res call({
 Launch launch
});


$LaunchCopyWith<$Res> get launch;

}
/// @nodoc
class _$LatestLaunchLoadedCopyWithImpl<$Res>
    implements $LatestLaunchLoadedCopyWith<$Res> {
  _$LatestLaunchLoadedCopyWithImpl(this._self, this._then);

  final LatestLaunchLoaded _self;
  final $Res Function(LatestLaunchLoaded) _then;

/// Create a copy of LatestLaunchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? launch = null,}) {
  return _then(LatestLaunchLoaded(
null == launch ? _self.launch : launch // ignore: cast_nullable_to_non_nullable
as Launch,
  ));
}

/// Create a copy of LatestLaunchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LaunchCopyWith<$Res> get launch {
  
  return $LaunchCopyWith<$Res>(_self.launch, (value) {
    return _then(_self.copyWith(launch: value));
  });
}
}

/// @nodoc


class LatestLaunchError implements LatestLaunchState {
  const LatestLaunchError(this.message);
  

 final  String message;

/// Create a copy of LatestLaunchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatestLaunchErrorCopyWith<LatestLaunchError> get copyWith => _$LatestLaunchErrorCopyWithImpl<LatestLaunchError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestLaunchError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'LatestLaunchState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $LatestLaunchErrorCopyWith<$Res> implements $LatestLaunchStateCopyWith<$Res> {
  factory $LatestLaunchErrorCopyWith(LatestLaunchError value, $Res Function(LatestLaunchError) _then) = _$LatestLaunchErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LatestLaunchErrorCopyWithImpl<$Res>
    implements $LatestLaunchErrorCopyWith<$Res> {
  _$LatestLaunchErrorCopyWithImpl(this._self, this._then);

  final LatestLaunchError _self;
  final $Res Function(LatestLaunchError) _then;

/// Create a copy of LatestLaunchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LatestLaunchError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
