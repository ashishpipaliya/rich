// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Launch _$LaunchFromJson(Map<String, dynamic> json) => _Launch(
  id: json['id'] as String,
  name: json['name'] as String,
  dateUtc: DateTime.parse(json['date_utc'] as String),
  flightNumber: (json['flight_number'] as num).toInt(),
  success: json['success'] as bool?,
  details: json['details'] as String?,
  links: LaunchLinks.fromJson(json['links'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LaunchToJson(_Launch instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'date_utc': instance.dateUtc.toIso8601String(),
  'flight_number': instance.flightNumber,
  'success': instance.success,
  'details': instance.details,
  'links': instance.links,
};

_LaunchLinks _$LaunchLinksFromJson(Map<String, dynamic> json) => _LaunchLinks(
  patch: LaunchPatch.fromJson(json['patch'] as Map<String, dynamic>),
  youtubeId: json['youtube_id'] as String?,
  wikipedia: json['wikipedia'] as String?,
);

Map<String, dynamic> _$LaunchLinksToJson(_LaunchLinks instance) =>
    <String, dynamic>{
      'patch': instance.patch,
      'youtube_id': instance.youtubeId,
      'wikipedia': instance.wikipedia,
    };

_LaunchPatch _$LaunchPatchFromJson(Map<String, dynamic> json) => _LaunchPatch(
  small: json['small'] as String?,
  large: json['large'] as String?,
);

Map<String, dynamic> _$LaunchPatchToJson(_LaunchPatch instance) =>
    <String, dynamic>{'small': instance.small, 'large': instance.large};
