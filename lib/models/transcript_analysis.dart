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

  factory TranscriptAnalyzeResponse.fromJson(Map<String, dynamic> json) {
    return TranscriptAnalyzeResponse(
      sessionId: json['sessionId'] as String,
      chunkId: json['chunkId'] as String,
      acceptedSequence: json['acceptedSequence'] as int,
      nextTranscriptSequence: json['nextTranscriptSequence'] as int,
      duplicate: json['duplicate'] as bool,
      analysisThresholdReached: json['analysisThresholdReached'] as bool,
      riskScore: json['riskScore'] as int,
      phishingType: json['phishingType'] as String,
      aiSummary: json['aiSummary'] as String,
      keywords: (json['keywords'] as List<dynamic>).cast<String>(),
      shouldOpenWebSocket: json['shouldOpenWebSocket'] as bool,
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
}
