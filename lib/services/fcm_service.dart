import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
