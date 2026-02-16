// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spacex_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpaceXState {

 SpaceXStatus get historyStatus; SpaceXStatus get latestStatus; List<Launch> get allLaunches; List<Launch> get filteredLaunches; Launch? get latestLaunch; String get searchQuery; String? get errorMessage;
/// Create a copy of SpaceXState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceXStateCopyWith<SpaceXState> get copyWith => _$SpaceXStateCopyWithImpl<SpaceXState>(this as SpaceXState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceXState&&(identical(other.historyStatus, historyStatus) || other.historyStatus == historyStatus)&&(identical(other.latestStatus, latestStatus) || other.latestStatus == latestStatus)&&const DeepCollectionEquality().equals(other.allLaunches, allLaunches)&&const DeepCollectionEquality().equals(other.filteredLaunches, filteredLaunches)&&(identical(other.latestLaunch, latestLaunch) || other.latestLaunch == latestLaunch)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,historyStatus,latestStatus,const DeepCollectionEquality().hash(allLaunches),const DeepCollectionEquality().hash(filteredLaunches),latestLaunch,searchQuery,errorMessage);

@override
String toString() {
  return 'SpaceXState(historyStatus: $historyStatus, latestStatus: $latestStatus, allLaunches: $allLaunches, filteredLaunches: $filteredLaunches, latestLaunch: $latestLaunch, searchQuery: $searchQuery, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SpaceXStateCopyWith<$Res>  {
  factory $SpaceXStateCopyWith(SpaceXState value, $Res Function(SpaceXState) _then) = _$SpaceXStateCopyWithImpl;
@useResult
$Res call({
 SpaceXStatus historyStatus, SpaceXStatus latestStatus, List<Launch> allLaunches, List<Launch> filteredLaunches, Launch? latestLaunch, String searchQuery, String? errorMessage
});


$LaunchCopyWith<$Res>? get latestLaunch;

}
/// @nodoc
class _$SpaceXStateCopyWithImpl<$Res>
    implements $SpaceXStateCopyWith<$Res> {
  _$SpaceXStateCopyWithImpl(this._self, this._then);

  final SpaceXState _self;
  final $Res Function(SpaceXState) _then;

/// Create a copy of SpaceXState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? historyStatus = null,Object? latestStatus = null,Object? allLaunches = null,Object? filteredLaunches = null,Object? latestLaunch = freezed,Object? searchQuery = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
historyStatus: null == historyStatus ? _self.historyStatus : historyStatus // ignore: cast_nullable_to_non_nullable
as SpaceXStatus,latestStatus: null == latestStatus ? _self.latestStatus : latestStatus // ignore: cast_nullable_to_non_nullable
as SpaceXStatus,allLaunches: null == allLaunches ? _self.allLaunches : allLaunches // ignore: cast_nullable_to_non_nullable
as List<Launch>,filteredLaunches: null == filteredLaunches ? _self.filteredLaunches : filteredLaunches // ignore: cast_nullable_to_non_nullable
as List<Launch>,latestLaunch: freezed == latestLaunch ? _self.latestLaunch : latestLaunch // ignore: cast_nullable_to_non_nullable
as Launch?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SpaceXState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LaunchCopyWith<$Res>? get latestLaunch {
    if (_self.latestLaunch == null) {
    return null;
  }

  return $LaunchCopyWith<$Res>(_self.latestLaunch!, (value) {
    return _then(_self.copyWith(latestLaunch: value));
  });
}
}


/// Adds pattern-matching-related methods to [SpaceXState].
extension SpaceXStatePatterns on SpaceXState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceXState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceXState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceXState value)  $default,){
final _that = this;
switch (_that) {
case _SpaceXState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceXState value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceXState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SpaceXStatus historyStatus,  SpaceXStatus latestStatus,  List<Launch> allLaunches,  List<Launch> filteredLaunches,  Launch? latestLaunch,  String searchQuery,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceXState() when $default != null:
return $default(_that.historyStatus,_that.latestStatus,_that.allLaunches,_that.filteredLaunches,_that.latestLaunch,_that.searchQuery,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SpaceXStatus historyStatus,  SpaceXStatus latestStatus,  List<Launch> allLaunches,  List<Launch> filteredLaunches,  Launch? latestLaunch,  String searchQuery,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SpaceXState():
return $default(_that.historyStatus,_that.latestStatus,_that.allLaunches,_that.filteredLaunches,_that.latestLaunch,_that.searchQuery,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SpaceXStatus historyStatus,  SpaceXStatus latestStatus,  List<Launch> allLaunches,  List<Launch> filteredLaunches,  Launch? latestLaunch,  String searchQuery,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SpaceXState() when $default != null:
return $default(_that.historyStatus,_that.latestStatus,_that.allLaunches,_that.filteredLaunches,_that.latestLaunch,_that.searchQuery,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SpaceXState implements SpaceXState {
  const _SpaceXState({this.historyStatus = SpaceXStatus.initial, this.latestStatus = SpaceXStatus.initial, final  List<Launch> allLaunches = const [], final  List<Launch> filteredLaunches = const [], this.latestLaunch, this.searchQuery = '', this.errorMessage}): _allLaunches = allLaunches,_filteredLaunches = filteredLaunches;
  

@override@JsonKey() final  SpaceXStatus historyStatus;
@override@JsonKey() final  SpaceXStatus latestStatus;
 final  List<Launch> _allLaunches;
@override@JsonKey() List<Launch> get allLaunches {
  if (_allLaunches is EqualUnmodifiableListView) return _allLaunches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allLaunches);
}

 final  List<Launch> _filteredLaunches;
@override@JsonKey() List<Launch> get filteredLaunches {
  if (_filteredLaunches is EqualUnmodifiableListView) return _filteredLaunches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredLaunches);
}

@override final  Launch? latestLaunch;
@override@JsonKey() final  String searchQuery;
@override final  String? errorMessage;

/// Create a copy of SpaceXState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceXStateCopyWith<_SpaceXState> get copyWith => __$SpaceXStateCopyWithImpl<_SpaceXState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceXState&&(identical(other.historyStatus, historyStatus) || other.historyStatus == historyStatus)&&(identical(other.latestStatus, latestStatus) || other.latestStatus == latestStatus)&&const DeepCollectionEquality().equals(other._allLaunches, _allLaunches)&&const DeepCollectionEquality().equals(other._filteredLaunches, _filteredLaunches)&&(identical(other.latestLaunch, latestLaunch) || other.latestLaunch == latestLaunch)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,historyStatus,latestStatus,const DeepCollectionEquality().hash(_allLaunches),const DeepCollectionEquality().hash(_filteredLaunches),latestLaunch,searchQuery,errorMessage);

@override
String toString() {
  return 'SpaceXState(historyStatus: $historyStatus, latestStatus: $latestStatus, allLaunches: $allLaunches, filteredLaunches: $filteredLaunches, latestLaunch: $latestLaunch, searchQuery: $searchQuery, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SpaceXStateCopyWith<$Res> implements $SpaceXStateCopyWith<$Res> {
  factory _$SpaceXStateCopyWith(_SpaceXState value, $Res Function(_SpaceXState) _then) = __$SpaceXStateCopyWithImpl;
@override @useResult
$Res call({
 SpaceXStatus historyStatus, SpaceXStatus latestStatus, List<Launch> allLaunches, List<Launch> filteredLaunches, Launch? latestLaunch, String searchQuery, String? errorMessage
});


@override $LaunchCopyWith<$Res>? get latestLaunch;

}
/// @nodoc
class __$SpaceXStateCopyWithImpl<$Res>
    implements _$SpaceXStateCopyWith<$Res> {
  __$SpaceXStateCopyWithImpl(this._self, this._then);

  final _SpaceXState _self;
  final $Res Function(_SpaceXState) _then;

/// Create a copy of SpaceXState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? historyStatus = null,Object? latestStatus = null,Object? allLaunches = null,Object? filteredLaunches = null,Object? latestLaunch = freezed,Object? searchQuery = null,Object? errorMessage = freezed,}) {
  return _then(_SpaceXState(
historyStatus: null == historyStatus ? _self.historyStatus : historyStatus // ignore: cast_nullable_to_non_nullable
as SpaceXStatus,latestStatus: null == latestStatus ? _self.latestStatus : latestStatus // ignore: cast_nullable_to_non_nullable
as SpaceXStatus,allLaunches: null == allLaunches ? _self._allLaunches : allLaunches // ignore: cast_nullable_to_non_nullable
as List<Launch>,filteredLaunches: null == filteredLaunches ? _self._filteredLaunches : filteredLaunches // ignore: cast_nullable_to_non_nullable
as List<Launch>,latestLaunch: freezed == latestLaunch ? _self.latestLaunch : latestLaunch // ignore: cast_nullable_to_non_nullable
as Launch?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SpaceXState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LaunchCopyWith<$Res>? get latestLaunch {
    if (_self.latestLaunch == null) {
    return null;
  }

  return $LaunchCopyWith<$Res>(_self.latestLaunch!, (value) {
    return _then(_self.copyWith(latestLaunch: value));
  });
}
}

// dart format on
