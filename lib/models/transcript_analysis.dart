class TranscriptAnalyzeRequest {
  const TranscriptAnalyzeRequest({
    required this.chunkId,
    required this.sequence,
    required this.text,
    required this.startedAtMs,
    required this.endedAtMs,
    this.isFinal = true,
  });

  final String chunkId;
  final int sequence;
  final String text;
  final int startedAtMs;
  final int endedAtMs;
  final bool isFinal;

  Map<String, dynamic> toJson() {
    return {
      'chunkId': chunkId,
      'sequence': sequence,
      'text': text,
      'startedAtMs': startedAtMs,
      'endedAtMs': endedAtMs,
      'isFinal': isFinal,
    };
  }
}

class TranscriptAnalyzeResponse {
  const TranscriptAnalyzeResponse({
    required this.sessionId,
    required this.chunkId,
    required this.acceptedSequence,
    required this.nextTranscriptSequence,
    required this.duplicate,
    required this.analysisThresholdReached,
    required this.riskScore,
    required this.phishingType,
    required this.aiSummary,
    required this.keywords,
    required this.shouldOpenWebSocket,
  });

  final String sessionId;
  final String chunkId;
  final int acceptedSequence;
  final int nextTranscriptSequence;
  final bool duplicate;
  final bool analysisThresholdReached;
  final int riskScore;
  final String phishingType;
  final String aiSummary;
  final List<String> keywords;
  final bool shouldOpenWebSocket;

  factory TranscriptAnalyzeResponse.fromJson(
    Map<String, dynamic> json, {
    String? fallbackSessionId,
    TranscriptAnalyzeRequest? fallbackRequest,
  }) {
    final fallbackSequence = fallbackRequest?.sequence ?? 0;
    final acceptedSequence = _readInt(
      json['acceptedSequence'],
      fallbackSequence,
    );
    final riskScore = _readInt(json['riskScore'], 0);

    return TranscriptAnalyzeResponse(
      sessionId: _readString(json['sessionId'], fallbackSessionId ?? ''),
      chunkId: _readString(json['chunkId'], fallbackRequest?.chunkId ?? ''),
      acceptedSequence: acceptedSequence,
      nextTranscriptSequence: _readInt(
        json['nextTranscriptSequence'],
        acceptedSequence + 1,
      ),
      duplicate: _readBool(json['duplicate'], false),
      analysisThresholdReached: _readBool(
        json['analysisThresholdReached'],
        riskScore >= 41,
      ),
      riskScore: riskScore,
      phishingType: _readString(
        json['phishingType'],
        _mockPhishingType(riskScore),
      ),
      aiSummary: _readString(json['aiSummary'], ''),
      keywords: _readStringList(json['keywords']),
      shouldOpenWebSocket: _readBool(
        json['shouldOpenWebSocket'],
        riskScore >= 56,
      ),
    );
  }

  factory TranscriptAnalyzeResponse.mock({
    required String sessionId,
    required TranscriptAnalyzeRequest request,
  }) {
    final riskScore = switch (request.sequence) {
      1 => 20,
      2 => 48,
      3 => 66,
      _ => 86,
    };

    return TranscriptAnalyzeResponse(
      sessionId: sessionId,
      chunkId: request.chunkId,
      acceptedSequence: request.sequence,
      nextTranscriptSequence: request.sequence + 1,
      duplicate: false,
      analysisThresholdReached: request.sequence >= 2,
      riskScore: riskScore,
      phishingType: _mockPhishingType(riskScore),
      aiSummary: _mockSummary(riskScore),
      keywords: _mockKeywords(riskScore),
      shouldOpenWebSocket: riskScore >= 56,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'chunkId': chunkId,
      'acceptedSequence': acceptedSequence,
      'nextTranscriptSequence': nextTranscriptSequence,
      'duplicate': duplicate,
      'analysisThresholdReached': analysisThresholdReached,
      'riskScore': riskScore,
      'phishingType': phishingType,
      'aiSummary': aiSummary,
      'keywords': keywords,
      'shouldOpenWebSocket': shouldOpenWebSocket,
    };
  }

  static String _mockPhishingType(int riskScore) {
    if (riskScore >= 76) return 'FAMILY_THREAT';
    if (riskScore >= 56) return 'ACCOUNT_TRANSFER_INDUCEMENT';
    if (riskScore >= 41) return 'SUSPICIOUS_PATTERN';
    return 'NONE';
  }

  static String _mockSummary(int riskScore) {
    if (riskScore >= 76) return '가족을 사칭한 협박과 입금 유도 표현이 탐지되었습니다.';
    if (riskScore >= 56) return '검사, 수사, 입금 등 보이스피싱 의심 표현이 감지되었습니다.';
    if (riskScore >= 41) return '주의가 필요한 금융/기관 사칭 표현이 일부 감지되었습니다.';
    return '현재까지 위험 표현은 감지되지 않았습니다.';
  }

  static List<String> _mockKeywords(int riskScore) {
    if (riskScore >= 76) return const ['납치', '아들', '입금'];
    if (riskScore >= 56) return const ['검사', '수사', '입금'];
    if (riskScore >= 41) return const ['계좌', '확인'];
    return const [];
  }

  static String _readString(Object? value, String fallback) {
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  static int _readInt(Object? value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static bool _readBool(Object? value, bool fallback) {
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true') return true;
      if (normalized == 'false') return false;
    }
    return fallback;
  }

  static List<String> _readStringList(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Object>()
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
