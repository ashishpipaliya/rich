import 'package:freezed_annotation/freezed_annotation.dart';

part 'launch_model.freezed.dart';
part 'launch_model.g.dart';

@freezed
abstract class Launch with _$Launch {
  const factory Launch({
    required String id,
    required String name,
    @JsonKey(name: 'date_utc') required DateTime dateUtc,
    @JsonKey(name: 'flight_number') required int flightNumber,
    required bool? success,
    required String? details,
    required LaunchLinks links,
  }) = _Launch;

  factory Launch.fromJson(Map<String, dynamic> json) => _$LaunchFromJson(json);
}

@freezed
abstract class LaunchLinks with _$LaunchLinks {
  const factory LaunchLinks({required LaunchPatch patch, @JsonKey(name: 'youtube_id') String? youtubeId, String? wikipedia}) = _LaunchLinks;

  factory LaunchLinks.fromJson(Map<String, dynamic> json) => _$LaunchLinksFromJson(json);
}

@freezed
abstract class LaunchPatch with _$LaunchPatch {
  const factory LaunchPatch({String? small, String? large}) = _LaunchPatch;

  factory LaunchPatch.fromJson(Map<String, dynamic> json) => _$LaunchPatchFromJson(json);
}
