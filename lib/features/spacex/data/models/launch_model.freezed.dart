// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'launch_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Launch {

 String get id; String get name;@JsonKey(name: 'date_utc') DateTime get dateUtc;@JsonKey(name: 'flight_number') int get flightNumber; bool? get success; String? get details; LaunchLinks get links;
/// Create a copy of Launch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaunchCopyWith<Launch> get copyWith => _$LaunchCopyWithImpl<Launch>(this as Launch, _$identity);

  /// Serializes this Launch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Launch&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateUtc, dateUtc) || other.dateUtc == dateUtc)&&(identical(other.flightNumber, flightNumber) || other.flightNumber == flightNumber)&&(identical(other.success, success) || other.success == success)&&(identical(other.details, details) || other.details == details)&&(identical(other.links, links) || other.links == links));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dateUtc,flightNumber,success,details,links);

@override
String toString() {
  return 'Launch(id: $id, name: $name, dateUtc: $dateUtc, flightNumber: $flightNumber, success: $success, details: $details, links: $links)';
}


}

/// @nodoc
abstract mixin class $LaunchCopyWith<$Res>  {
  factory $LaunchCopyWith(Launch value, $Res Function(Launch) _then) = _$LaunchCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'date_utc') DateTime dateUtc,@JsonKey(name: 'flight_number') int flightNumber, bool? success, String? details, LaunchLinks links
});


$LaunchLinksCopyWith<$Res> get links;

}
/// @nodoc
class _$LaunchCopyWithImpl<$Res>
    implements $LaunchCopyWith<$Res> {
  _$LaunchCopyWithImpl(this._self, this._then);

  final Launch _self;
  final $Res Function(Launch) _then;

/// Create a copy of Launch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dateUtc = null,Object? flightNumber = null,Object? success = freezed,Object? details = freezed,Object? links = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateUtc: null == dateUtc ? _self.dateUtc : dateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,flightNumber: null == flightNumber ? _self.flightNumber : flightNumber // ignore: cast_nullable_to_non_nullable
as int,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as LaunchLinks,
  ));
}
/// Create a copy of Launch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LaunchLinksCopyWith<$Res> get links {
  
  return $LaunchLinksCopyWith<$Res>(_self.links, (value) {
    return _then(_self.copyWith(links: value));
  });
}
}


/// Adds pattern-matching-related methods to [Launch].
extension LaunchPatterns on Launch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Launch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Launch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Launch value)  $default,){
final _that = this;
switch (_that) {
case _Launch():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Launch value)?  $default,){
final _that = this;
switch (_that) {
case _Launch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'date_utc')  DateTime dateUtc, @JsonKey(name: 'flight_number')  int flightNumber,  bool? success,  String? details,  LaunchLinks links)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Launch() when $default != null:
return $default(_that.id,_that.name,_that.dateUtc,_that.flightNumber,_that.success,_that.details,_that.links);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'date_utc')  DateTime dateUtc, @JsonKey(name: 'flight_number')  int flightNumber,  bool? success,  String? details,  LaunchLinks links)  $default,) {final _that = this;
switch (_that) {
case _Launch():
return $default(_that.id,_that.name,_that.dateUtc,_that.flightNumber,_that.success,_that.details,_that.links);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'date_utc')  DateTime dateUtc, @JsonKey(name: 'flight_number')  int flightNumber,  bool? success,  String? details,  LaunchLinks links)?  $default,) {final _that = this;
switch (_that) {
case _Launch() when $default != null:
return $default(_that.id,_that.name,_that.dateUtc,_that.flightNumber,_that.success,_that.details,_that.links);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Launch implements Launch {
  const _Launch({required this.id, required this.name, @JsonKey(name: 'date_utc') required this.dateUtc, @JsonKey(name: 'flight_number') required this.flightNumber, required this.success, required this.details, required this.links});
  factory _Launch.fromJson(Map<String, dynamic> json) => _$LaunchFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'date_utc') final  DateTime dateUtc;
@override@JsonKey(name: 'flight_number') final  int flightNumber;
@override final  bool? success;
@override final  String? details;
@override final  LaunchLinks links;

/// Create a copy of Launch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaunchCopyWith<_Launch> get copyWith => __$LaunchCopyWithImpl<_Launch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LaunchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Launch&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateUtc, dateUtc) || other.dateUtc == dateUtc)&&(identical(other.flightNumber, flightNumber) || other.flightNumber == flightNumber)&&(identical(other.success, success) || other.success == success)&&(identical(other.details, details) || other.details == details)&&(identical(other.links, links) || other.links == links));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dateUtc,flightNumber,success,details,links);

@override
String toString() {
  return 'Launch(id: $id, name: $name, dateUtc: $dateUtc, flightNumber: $flightNumber, success: $success, details: $details, links: $links)';
}


}

/// @nodoc
abstract mixin class _$LaunchCopyWith<$Res> implements $LaunchCopyWith<$Res> {
  factory _$LaunchCopyWith(_Launch value, $Res Function(_Launch) _then) = __$LaunchCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'date_utc') DateTime dateUtc,@JsonKey(name: 'flight_number') int flightNumber, bool? success, String? details, LaunchLinks links
});


@override $LaunchLinksCopyWith<$Res> get links;

}
/// @nodoc
class __$LaunchCopyWithImpl<$Res>
    implements _$LaunchCopyWith<$Res> {
  __$LaunchCopyWithImpl(this._self, this._then);

  final _Launch _self;
  final $Res Function(_Launch) _then;

/// Create a copy of Launch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dateUtc = null,Object? flightNumber = null,Object? success = freezed,Object? details = freezed,Object? links = null,}) {
  return _then(_Launch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateUtc: null == dateUtc ? _self.dateUtc : dateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,flightNumber: null == flightNumber ? _self.flightNumber : flightNumber // ignore: cast_nullable_to_non_nullable
as int,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as LaunchLinks,
  ));
}

/// Create a copy of Launch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LaunchLinksCopyWith<$Res> get links {
  
  return $LaunchLinksCopyWith<$Res>(_self.links, (value) {
    return _then(_self.copyWith(links: value));
  });
}
}


/// @nodoc
mixin _$LaunchLinks {

 LaunchPatch get patch;@JsonKey(name: 'youtube_id') String? get youtubeId; String? get wikipedia;
/// Create a copy of LaunchLinks
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaunchLinksCopyWith<LaunchLinks> get copyWith => _$LaunchLinksCopyWithImpl<LaunchLinks>(this as LaunchLinks, _$identity);

  /// Serializes this LaunchLinks to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaunchLinks&&(identical(other.patch, patch) || other.patch == patch)&&(identical(other.youtubeId, youtubeId) || other.youtubeId == youtubeId)&&(identical(other.wikipedia, wikipedia) || other.wikipedia == wikipedia));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patch,youtubeId,wikipedia);

@override
String toString() {
  return 'LaunchLinks(patch: $patch, youtubeId: $youtubeId, wikipedia: $wikipedia)';
}


}

/// @nodoc
abstract mixin class $LaunchLinksCopyWith<$Res>  {
  factory $LaunchLinksCopyWith(LaunchLinks value, $Res Function(LaunchLinks) _then) = _$LaunchLinksCopyWithImpl;
@useResult
$Res call({
 LaunchPatch patch,@JsonKey(name: 'youtube_id') String? youtubeId, String? wikipedia
});


$LaunchPatchCopyWith<$Res> get patch;

}
/// @nodoc
class _$LaunchLinksCopyWithImpl<$Res>
    implements $LaunchLinksCopyWith<$Res> {
  _$LaunchLinksCopyWithImpl(this._self, this._then);

  final LaunchLinks _self;
  final $Res Function(LaunchLinks) _then;

/// Create a copy of LaunchLinks
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patch = null,Object? youtubeId = freezed,Object? wikipedia = freezed,}) {
  return _then(_self.copyWith(
patch: null == patch ? _self.patch : patch // ignore: cast_nullable_to_non_nullable
as LaunchPatch,youtubeId: freezed == youtubeId ? _self.youtubeId : youtubeId // ignore: cast_nullable_to_non_nullable
as String?,wikipedia: freezed == wikipedia ? _self.wikipedia : wikipedia // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LaunchLinks
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LaunchPatchCopyWith<$Res> get patch {
  
  return $LaunchPatchCopyWith<$Res>(_self.patch, (value) {
    return _then(_self.copyWith(patch: value));
  });
}
}


/// Adds pattern-matching-related methods to [LaunchLinks].
extension LaunchLinksPatterns on LaunchLinks {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LaunchLinks value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LaunchLinks() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LaunchLinks value)  $default,){
final _that = this;
switch (_that) {
case _LaunchLinks():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LaunchLinks value)?  $default,){
final _that = this;
switch (_that) {
case _LaunchLinks() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LaunchPatch patch, @JsonKey(name: 'youtube_id')  String? youtubeId,  String? wikipedia)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LaunchLinks() when $default != null:
return $default(_that.patch,_that.youtubeId,_that.wikipedia);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LaunchPatch patch, @JsonKey(name: 'youtube_id')  String? youtubeId,  String? wikipedia)  $default,) {final _that = this;
switch (_that) {
case _LaunchLinks():
return $default(_that.patch,_that.youtubeId,_that.wikipedia);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LaunchPatch patch, @JsonKey(name: 'youtube_id')  String? youtubeId,  String? wikipedia)?  $default,) {final _that = this;
switch (_that) {
case _LaunchLinks() when $default != null:
return $default(_that.patch,_that.youtubeId,_that.wikipedia);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LaunchLinks implements LaunchLinks {
  const _LaunchLinks({required this.patch, @JsonKey(name: 'youtube_id') this.youtubeId, this.wikipedia});
  factory _LaunchLinks.fromJson(Map<String, dynamic> json) => _$LaunchLinksFromJson(json);

@override final  LaunchPatch patch;
@override@JsonKey(name: 'youtube_id') final  String? youtubeId;
@override final  String? wikipedia;

/// Create a copy of LaunchLinks
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaunchLinksCopyWith<_LaunchLinks> get copyWith => __$LaunchLinksCopyWithImpl<_LaunchLinks>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LaunchLinksToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaunchLinks&&(identical(other.patch, patch) || other.patch == patch)&&(identical(other.youtubeId, youtubeId) || other.youtubeId == youtubeId)&&(identical(other.wikipedia, wikipedia) || other.wikipedia == wikipedia));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patch,youtubeId,wikipedia);

@override
String toString() {
  return 'LaunchLinks(patch: $patch, youtubeId: $youtubeId, wikipedia: $wikipedia)';
}


}

/// @nodoc
abstract mixin class _$LaunchLinksCopyWith<$Res> implements $LaunchLinksCopyWith<$Res> {
  factory _$LaunchLinksCopyWith(_LaunchLinks value, $Res Function(_LaunchLinks) _then) = __$LaunchLinksCopyWithImpl;
@override @useResult
$Res call({
 LaunchPatch patch,@JsonKey(name: 'youtube_id') String? youtubeId, String? wikipedia
});


@override $LaunchPatchCopyWith<$Res> get patch;

}
/// @nodoc
class __$LaunchLinksCopyWithImpl<$Res>
    implements _$LaunchLinksCopyWith<$Res> {
  __$LaunchLinksCopyWithImpl(this._self, this._then);

  final _LaunchLinks _self;
  final $Res Function(_LaunchLinks) _then;

/// Create a copy of LaunchLinks
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patch = null,Object? youtubeId = freezed,Object? wikipedia = freezed,}) {
  return _then(_LaunchLinks(
patch: null == patch ? _self.patch : patch // ignore: cast_nullable_to_non_nullable
as LaunchPatch,youtubeId: freezed == youtubeId ? _self.youtubeId : youtubeId // ignore: cast_nullable_to_non_nullable
as String?,wikipedia: freezed == wikipedia ? _self.wikipedia : wikipedia // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LaunchLinks
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LaunchPatchCopyWith<$Res> get patch {
  
  return $LaunchPatchCopyWith<$Res>(_self.patch, (value) {
    return _then(_self.copyWith(patch: value));
  });
}
}


/// @nodoc
mixin _$LaunchPatch {

 String? get small; String? get large;
/// Create a copy of LaunchPatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaunchPatchCopyWith<LaunchPatch> get copyWith => _$LaunchPatchCopyWithImpl<LaunchPatch>(this as LaunchPatch, _$identity);

  /// Serializes this LaunchPatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaunchPatch&&(identical(other.small, small) || other.small == small)&&(identical(other.large, large) || other.large == large));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,small,large);

@override
String toString() {
  return 'LaunchPatch(small: $small, large: $large)';
}


}

/// @nodoc
abstract mixin class $LaunchPatchCopyWith<$Res>  {
  factory $LaunchPatchCopyWith(LaunchPatch value, $Res Function(LaunchPatch) _then) = _$LaunchPatchCopyWithImpl;
@useResult
$Res call({
 String? small, String? large
});




}
/// @nodoc
class _$LaunchPatchCopyWithImpl<$Res>
    implements $LaunchPatchCopyWith<$Res> {
  _$LaunchPatchCopyWithImpl(this._self, this._then);

  final LaunchPatch _self;
  final $Res Function(LaunchPatch) _then;

/// Create a copy of LaunchPatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? small = freezed,Object? large = freezed,}) {
  return _then(_self.copyWith(
small: freezed == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as String?,large: freezed == large ? _self.large : large // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LaunchPatch].
extension LaunchPatchPatterns on LaunchPatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LaunchPatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LaunchPatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LaunchPatch value)  $default,){
final _that = this;
switch (_that) {
case _LaunchPatch():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LaunchPatch value)?  $default,){
final _that = this;
switch (_that) {
case _LaunchPatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? small,  String? large)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LaunchPatch() when $default != null:
return $default(_that.small,_that.large);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? small,  String? large)  $default,) {final _that = this;
switch (_that) {
case _LaunchPatch():
return $default(_that.small,_that.large);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? small,  String? large)?  $default,) {final _that = this;
switch (_that) {
case _LaunchPatch() when $default != null:
return $default(_that.small,_that.large);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LaunchPatch implements LaunchPatch {
  const _LaunchPatch({this.small, this.large});
  factory _LaunchPatch.fromJson(Map<String, dynamic> json) => _$LaunchPatchFromJson(json);

@override final  String? small;
@override final  String? large;

/// Create a copy of LaunchPatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaunchPatchCopyWith<_LaunchPatch> get copyWith => __$LaunchPatchCopyWithImpl<_LaunchPatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LaunchPatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaunchPatch&&(identical(other.small, small) || other.small == small)&&(identical(other.large, large) || other.large == large));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,small,large);

@override
String toString() {
  return 'LaunchPatch(small: $small, large: $large)';
}


}

/// @nodoc
abstract mixin class _$LaunchPatchCopyWith<$Res> implements $LaunchPatchCopyWith<$Res> {
  factory _$LaunchPatchCopyWith(_LaunchPatch value, $Res Function(_LaunchPatch) _then) = __$LaunchPatchCopyWithImpl;
@override @useResult
$Res call({
 String? small, String? large
});




}
/// @nodoc
class __$LaunchPatchCopyWithImpl<$Res>
    implements _$LaunchPatchCopyWith<$Res> {
  __$LaunchPatchCopyWithImpl(this._self, this._then);

  final _LaunchPatch _self;
  final $Res Function(_LaunchPatch) _then;

/// Create a copy of LaunchPatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? small = freezed,Object? large = freezed,}) {
  return _then(_LaunchPatch(
small: freezed == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as String?,large: freezed == large ? _self.large : large // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
