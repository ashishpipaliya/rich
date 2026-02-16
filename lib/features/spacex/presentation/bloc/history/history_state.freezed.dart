// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HistoryState()';
}


}

/// @nodoc
class $HistoryStateCopyWith<$Res>  {
$HistoryStateCopyWith(HistoryState _, $Res Function(HistoryState) __);
}


/// Adds pattern-matching-related methods to [HistoryState].
extension HistoryStatePatterns on HistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HistoryInitial value)?  initial,TResult Function( HistoryLoading value)?  loading,TResult Function( HistoryLoaded value)?  loaded,TResult Function( HistoryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial(_that);case HistoryLoading() when loading != null:
return loading(_that);case HistoryLoaded() when loaded != null:
return loaded(_that);case HistoryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HistoryInitial value)  initial,required TResult Function( HistoryLoading value)  loading,required TResult Function( HistoryLoaded value)  loaded,required TResult Function( HistoryError value)  error,}){
final _that = this;
switch (_that) {
case HistoryInitial():
return initial(_that);case HistoryLoading():
return loading(_that);case HistoryLoaded():
return loaded(_that);case HistoryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HistoryInitial value)?  initial,TResult? Function( HistoryLoading value)?  loading,TResult? Function( HistoryLoaded value)?  loaded,TResult? Function( HistoryError value)?  error,}){
final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial(_that);case HistoryLoading() when loading != null:
return loading(_that);case HistoryLoaded() when loaded != null:
return loaded(_that);case HistoryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Launch> allLaunches,  List<Launch> filteredLaunches,  String searchQuery)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial();case HistoryLoading() when loading != null:
return loading();case HistoryLoaded() when loaded != null:
return loaded(_that.allLaunches,_that.filteredLaunches,_that.searchQuery);case HistoryError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Launch> allLaunches,  List<Launch> filteredLaunches,  String searchQuery)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case HistoryInitial():
return initial();case HistoryLoading():
return loading();case HistoryLoaded():
return loaded(_that.allLaunches,_that.filteredLaunches,_that.searchQuery);case HistoryError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Launch> allLaunches,  List<Launch> filteredLaunches,  String searchQuery)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial();case HistoryLoading() when loading != null:
return loading();case HistoryLoaded() when loaded != null:
return loaded(_that.allLaunches,_that.filteredLaunches,_that.searchQuery);case HistoryError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HistoryInitial implements HistoryState {
  const HistoryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HistoryState.initial()';
}


}




/// @nodoc


class HistoryLoading implements HistoryState {
  const HistoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HistoryState.loading()';
}


}




/// @nodoc


class HistoryLoaded implements HistoryState {
  const HistoryLoaded({required final  List<Launch> allLaunches, required final  List<Launch> filteredLaunches, this.searchQuery = ''}): _allLaunches = allLaunches,_filteredLaunches = filteredLaunches;
  

 final  List<Launch> _allLaunches;
 List<Launch> get allLaunches {
  if (_allLaunches is EqualUnmodifiableListView) return _allLaunches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allLaunches);
}

 final  List<Launch> _filteredLaunches;
 List<Launch> get filteredLaunches {
  if (_filteredLaunches is EqualUnmodifiableListView) return _filteredLaunches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredLaunches);
}

@JsonKey() final  String searchQuery;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryLoadedCopyWith<HistoryLoaded> get copyWith => _$HistoryLoadedCopyWithImpl<HistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoaded&&const DeepCollectionEquality().equals(other._allLaunches, _allLaunches)&&const DeepCollectionEquality().equals(other._filteredLaunches, _filteredLaunches)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allLaunches),const DeepCollectionEquality().hash(_filteredLaunches),searchQuery);

@override
String toString() {
  return 'HistoryState.loaded(allLaunches: $allLaunches, filteredLaunches: $filteredLaunches, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $HistoryLoadedCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory $HistoryLoadedCopyWith(HistoryLoaded value, $Res Function(HistoryLoaded) _then) = _$HistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<Launch> allLaunches, List<Launch> filteredLaunches, String searchQuery
});




}
/// @nodoc
class _$HistoryLoadedCopyWithImpl<$Res>
    implements $HistoryLoadedCopyWith<$Res> {
  _$HistoryLoadedCopyWithImpl(this._self, this._then);

  final HistoryLoaded _self;
  final $Res Function(HistoryLoaded) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allLaunches = null,Object? filteredLaunches = null,Object? searchQuery = null,}) {
  return _then(HistoryLoaded(
allLaunches: null == allLaunches ? _self._allLaunches : allLaunches // ignore: cast_nullable_to_non_nullable
as List<Launch>,filteredLaunches: null == filteredLaunches ? _self._filteredLaunches : filteredLaunches // ignore: cast_nullable_to_non_nullable
as List<Launch>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HistoryError implements HistoryState {
  const HistoryError(this.message);
  

 final  String message;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryErrorCopyWith<HistoryError> get copyWith => _$HistoryErrorCopyWithImpl<HistoryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HistoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $HistoryErrorCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory $HistoryErrorCopyWith(HistoryError value, $Res Function(HistoryError) _then) = _$HistoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HistoryErrorCopyWithImpl<$Res>
    implements $HistoryErrorCopyWith<$Res> {
  _$HistoryErrorCopyWithImpl(this._self, this._then);

  final HistoryError _self;
  final $Res Function(HistoryError) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HistoryError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
