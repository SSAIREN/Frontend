import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/features/guardian/guardian_response_args.dart';

class FcmService {
  FcmService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: dotenv.env['API_BASE_URL']?.trim().isNotEmpty == true
                    ? dotenv.env['API_BASE_URL']!.trim()
                    : 'http://10.0.2.2:8080',
                headers: const {
                  Headers.contentTypeHeader: Headers.jsonContentType,
                },
              ),
            );

  final Dio _dio;
  final _messaging = FirebaseMessaging.instance;

  bool get _useMockApi =>
      (dotenv.env['USE_MOCK_API']?.trim().toLowerCase() ?? 'true') == 'true';

  Future<String?> getToken() async {
    await _messaging.requestPermission();
    return _messaging.getToken();
  }

  /// 포그라운드 수신 + 알림 탭으로 앱이 열린 경우를 구독한다.
  /// 위험 알림을 받으면 보호자 응답 화면으로 이동시킨다.
  void listenForAlerts(GlobalKey<NavigatorState> navigatorKey) {
    FirebaseMessaging.onMessage.listen((m) => _routeToResponse(navigatorKey, m));
    FirebaseMessaging.onMessageOpenedApp
        .listen((m) => _routeToResponse(navigatorKey, m));
  }

  /// 앱이 완전히 종료된 상태에서 알림 탭으로 실행된 경우를 처리한다.
  Future<void> handleLaunchMessage(
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _routeToResponse(navigatorKey, initial);
  }

  void _routeToResponse(
    GlobalKey<NavigatorState> navigatorKey,
    RemoteMessage message,
  ) {
    navigatorKey.currentState?.pushNamed(
      RoutePaths.guardianResponse,
      arguments: GuardianResponseArgs(
        title: message.notification?.title,
        body: message.notification?.body,
      ),
    );
  }

  Future<void> registerToken({
    required int userId,
    required String token,
  }) async {
    if (_useMockApi) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return;
    }

    await _dio.patch<void>(
      '/users/$userId/fcm-token',
      data: {'fcmToken': token},
    );
  }
}
