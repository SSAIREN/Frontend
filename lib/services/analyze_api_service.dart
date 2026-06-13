import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
                receiveTimeout: const Duration(seconds: 60),
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

    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.post<Map<String, dynamic>>(
        '/api/mobile/call-sessions',
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw StateError(_formatDioError('Call session request failed', error));
    }

    final data = _extractPayload(response.data);
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

    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.post<Map<String, dynamic>>(
        '/api/mobile/call-sessions/$sessionId/transcripts/analyze',
        data: request.toJson(),
      );
    } on DioException catch (error) {
      _logDioError('[REST_ANALYZE][ERROR_RESPONSE]', error);
      throw StateError(_formatDioError('Transcript analysis failed', error));
    }

    final data = _extractPayload(response.data);
    if (data == null) {
      throw const FormatException('Transcript analysis response body is empty.');
    }

    return TranscriptAnalyzeResponse.fromJson(
      data,
      fallbackSessionId: sessionId,
      fallbackRequest: request,
    );
  }

  Map<String, dynamic>? _extractPayload(Map<String, dynamic>? body) {
    if (body == null) return null;
    final data = body['data'];
    if (data is Map<String, dynamic>) return data;
    return body;
  }

  String _formatDioError(String message, DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    return '$message'
        '${statusCode == null ? '' : ' ($statusCode)'}: '
        '${responseData ?? error.message}';
  }

  void _logDioError(String title, DioException error) {
    debugPrint('$title status=${error.response?.statusCode}');
    debugPrint('$title body\n${error.response?.data ?? 'null'}');
  }
}
