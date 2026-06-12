import 'package:dio/dio.dart';
import 'package:ssairen/core/config/api_config.dart';
import 'package:ssairen/models/call_session.dart';
import 'package:ssairen/models/transcript_analysis.dart';

class AnalyzeApiService {
  AnalyzeApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.baseUrl,
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 8),
                headers: const {
                  Headers.contentTypeHeader: Headers.jsonContentType,
                },
              ),
            );

  final Dio _dio;

  Future<CallSession> createCallSession(
    CallSessionCreateRequest request,
  ) async {
    if (ApiConfig.useMockApi) {
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
    if (ApiConfig.useMockApi) {
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
