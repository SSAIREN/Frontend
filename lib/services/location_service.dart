import 'package:geolocator/geolocator.dart';

/// 현재 기기의 GPS 위치를 조회한다.
///
/// 위치 서비스가 꺼져 있거나 권한이 없으면 null을 반환한다.
/// 권한은 온보딩에서 받지만, 사용 시점에 다시 확인한다.
class LocationService {
  const LocationService();

  Future<Position?> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition();
  }
}
