import 'package:ssairen/features/harmful/harmful_response_state.dart';

class HarmfulDashboardArgs {
  const HarmfulDashboardArgs({
    required this.phoneNumber,
    required this.callElapsed,
    required this.responseNotifier,
    this.latitude = defaultLat,
    this.longitude = defaultLng,
  });

  static const defaultLat = 37.4979;
  static const defaultLng = 127.0276;

  final String phoneNumber;
  final Duration callElapsed;
  final HarmfulResponseNotifier responseNotifier;
  final double latitude;
  final double longitude;
}
