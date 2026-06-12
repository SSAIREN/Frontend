abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const useMockApi = bool.fromEnvironment(
    'USE_MOCK_API',
    defaultValue: true,
  );
}
