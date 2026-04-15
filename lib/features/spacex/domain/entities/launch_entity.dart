class LaunchEntity {
  final String id;
  final String name;
  final DateTime dateUtc;
  final int flightNumber;
  final bool? success;
  final String? details;
  final String? patchSmall;
  final String? patchLarge;
  final String? youtubeId;
  final String? wikipedia;

  const LaunchEntity({
    required this.id,
    required this.name,
    required this.dateUtc,
    required this.flightNumber,
    required this.success,
    required this.details,
    required this.patchSmall,
    required this.patchLarge,
    required this.youtubeId,
    required this.wikipedia,
  });
}
