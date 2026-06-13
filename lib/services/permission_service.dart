import 'package:permission_handler/permission_handler.dart';

/// 온보딩 단계에서 사용하는 권한 요청 래퍼.
///
/// 각 메서드는 시스템 권한 다이얼로그를 띄우고 결과 [PermissionStatus]를
/// 반환한다. 이미 허용된 경우 다이얼로그 없이 곧바로 granted를 돌려준다.
class PermissionService {
  const PermissionService();

  Future<PermissionStatus> requestMicrophone() => Permission.microphone.request();

  Future<PermissionStatus> requestContacts() => Permission.contacts.request();

  Future<PermissionStatus> requestLocation() => Permission.locationWhenInUse.request();

  Future<PermissionStatus> requestNotification() => Permission.notification.request();

  /// 권한이 영구 거부되어 인앱 요청으로는 다시 띄울 수 없는 상태에서
  /// 사용자를 앱 설정 화면으로 이동시킨다.
  Future<bool> openSettings() => openAppSettings();
}
