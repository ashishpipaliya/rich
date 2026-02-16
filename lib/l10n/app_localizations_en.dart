// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SpaceX Dashboard';

  @override
  String get searchHint => 'Search experimental missions...';

  @override
  String get initializingControl => 'Initializing Mission Control...';

  @override
  String get loading => 'Loading...';

  @override
  String telemetryError(String message) {
    return 'Telemetry Error: $message';
  }

  @override
  String get noMissionsFound => 'No missions match coordinates';

  @override
  String get launchHistory => 'Launch History';

  @override
  String flightNumber(int number) {
    return 'Flight #$number';
  }

  @override
  String get success => 'Success';

  @override
  String get failure => 'Failure';

  @override
  String get retry => 'Retry Fetching';

  @override
  String get missionSummary => 'Mission Summary';

  @override
  String get noDetails =>
      'Historical records for this mission are classified or unavailable.';

  @override
  String get launchDate => 'Launch Date';

  @override
  String get launchStatus => 'Launch Status';

  @override
  String get liveTelemetry => 'LIVE TELEMETRY';

  @override
  String get successfulDeployment => 'Successful Deployment';

  @override
  String connectionLost(String message) {
    return 'Connection lost: $message';
  }

  @override
  String get reconnect => 'Reconnect';

  @override
  String get orbit => 'ORBIT';

  @override
  String get latestLaunch => 'Latest Launch';
}
