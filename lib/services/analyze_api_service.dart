import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ssairen/models/call_session.dart';
import 'package:ssairen/models/transcript_analysis.dart';

class AnalyzeApiService {
  AnalyzeApiService({Dio? dio})
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

  // .env 미설정 시 기본 mock 모드
  bool get _useMockApi =>
      (dotenv.env['USE_MOCK_API']?.trim().toLowerCase() ?? 'true') == 'true';

  Future<CallSession> createCallSession(
    CallSessionCreateRequest request,
  ) async {
    if (_useMockApi) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return CallSession.mock(request);
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/mobile/call-sessions',
      data: request.toJson(),
    );

    final data = response.data;
    if (data == null) {
      throw const FormatException('Call session response body is empty.');
    }

    return CallSession.fromJson(data);
  }

  Future<TranscriptAnalyzeResponse> analyzeTranscript({
    required String sessionId,
    required TranscriptAnalyzeRequest request,
  }) async {
    if (_useMockApi) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return TranscriptAnalyzeResponse.mock(
        sessionId: sessionId,
        request: request,
      );
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/mobile/call-sessions/$sessionId/transcripts/analyze',
      data: request.toJson(),
    );

    final data = response.data;
    if (data == null) {
      throw const FormatException('Transcript analysis response body is empty.');
    }

    return TranscriptAnalyzeResponse.fromJson(data);
  }
}
