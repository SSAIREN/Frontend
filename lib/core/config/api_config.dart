import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class ApiConfig {
  static const _baseUrlFromDefine = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const _openAiApiKeyFromDefine = String.fromEnvironment(
    'OPENAI_API_KEY',
  );

  static const _useMockApiFromDefine = bool.fromEnvironment(
    'USE_MOCK_API',
    defaultValue: true,
  );

  static String get baseUrl {
    return dotenv.env['API_BASE_URL']?.trim().isNotEmpty == true
        ? dotenv.env['API_BASE_URL']!.trim()
        : _baseUrlFromDefine;
  }

  static String get openAiApiKey {
    return dotenv.env['OPENAI_API_KEY']?.trim().isNotEmpty == true
        ? dotenv.env['OPENAI_API_KEY']!.trim()
        : _openAiApiKeyFromDefine;
  }

  static bool get useMockApi {
    final value = dotenv.env['USE_MOCK_API']?.trim().toLowerCase();
    if (value == null || value.isEmpty) return _useMockApiFromDefine;
    return value == 'true';
  }
}
