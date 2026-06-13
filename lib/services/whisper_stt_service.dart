import 'package:dio/dio.dart';
import 'package:ssairen/core/config/api_config.dart';

class WhisperSttService {
  WhisperSttService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://gms.ssafy.io/gmsapi/api.openai.com/v1',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 60),
              ),
            );

  static const _model = String.fromEnvironment(
    'OPENAI_STT_MODEL',
    defaultValue: 'whisper-1',
  );

  final Dio _dio;

  bool get isConfigured => ApiConfig.openAiApiKey.trim().isNotEmpty;

  Future<String> transcribeFile(String path) async {
    if (!isConfigured) {
      throw StateError(
        'OPENAI_API_KEY is empty. Add it to .env or pass '
        '--dart-define=OPENAI_API_KEY=your_api_key',
      );
    }

    final formData = FormData.fromMap({
      'model': _model,
      'language': 'ko',
      'response_format': 'json',
      'file': await MultipartFile.fromFile(
        path,
        filename: path.split(RegExp(r'[\\/]')).last,
      ),
    });

    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.post<Map<String, dynamic>>(
        '/audio/transcriptions',
        data: formData,
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.multipartFormDataContentType,
            Headers.acceptHeader: Headers.jsonContentType,
            'authorization': 'Bearer ${ApiConfig.openAiApiKey}',
          },
        ),
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      throw StateError(
        'Whisper request failed'
        '${statusCode == null ? '' : ' ($statusCode)'}: '
        '${responseData ?? error.message}',
      );
    }

    final data = response.data;
    if (data == null) {
      throw const FormatException('Whisper response body is empty.');
    }

    return (data['text'] as String? ?? '').trim();
  }
}
