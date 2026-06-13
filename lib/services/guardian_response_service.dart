import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 보호자(가족)가 위험 알림을 받고 보내는 응답을 서버로 전송한다.
///
/// 현재 위치(위도/경도)와 보호자가 입력한 메시지를 함께 보낸다.
class GuardianResponseService {
  GuardianResponseService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: dotenv.env['API_BASE_URL']?.trim().isNotEmpty == true
                    ? dotenv.env['API_BASE_URL']!.trim()
                    : 'http://10.0.2.2:8080',
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 8),
                headers: const {
                  Headers.contentTypeHeader: Headers.jsonContentType,
                },
              ),
            );

  final Dio _dio;

  bool get _useMockApi =>
      (dotenv.env['USE_MOCK_API']?.trim().toLowerCase() ?? 'true') == 'true';

  Future<void> sendResponse({
    required int guardianId,
    required double latitude,
    required double longitude,
    required String message,
  }) async {
    final body = {
      'guardianId': guardianId,
      'latitude': latitude,
      'longitude': longitude,
      'message': message,
    };

    if (_useMockApi) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return;
    }

    await _dio.post<void>('/api/mobile/guardians/responses', data: body);
  }
}
