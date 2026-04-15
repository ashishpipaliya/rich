import 'package:rich/features/spacex/data/models/launch_model.dart';
import 'package:rich/features/spacex/domain/entities/launch_entity.dart';

extension LaunchModelMapper on Launch {
  LaunchEntity toEntity() => LaunchEntity(
    id: id,
    name: name,
    dateUtc: dateUtc,
    flightNumber: flightNumber,
    success: success,
    details: details,
    patchSmall: links.patch.small,
    patchLarge: links.patch.large,
    youtubeId: links.youtubeId,
    wikipedia: links.wikipedia,
  );
}
