import 'package:ssairen/models/transcript_analysis.dart';

enum SocketEventType {
  sessionReady('SESSION_READY'),
  transcriptChunk('TRANSCRIPT_CHUNK'),
  transcriptAck('TRANSCRIPT_ACK'),
  analysisResult('ANALYSIS_RESULT'),
  analysisError('ANALYSIS_ERROR'),
  transcriptNack('TRANSCRIPT_NACK'),
  sessionComplete('SESSION_COMPLETE'),
  sessionCompleteAck('SESSION_COMPLETE_ACK'),
  ping('PING'),
  pong('PONG');

  const SocketEventType(this.value);

  final String value;

  static SocketEventType fromValue(String value) {
    return SocketEventType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw FormatException('Unknown socket event type: $value'),
    );
  }
}

class SocketEvent {
  const SocketEvent({
    required this.eventId,
    required this.eventType,
    required this.sessionId,
    required this.occurredAt,
    required this.data,
  });

  final String eventId;
  final SocketEventType eventType;
  final String sessionId;
  final DateTime occurredAt;
  final Map<String, dynamic> data;

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventType': eventType.value,
      'sessionId': sessionId,
      'occurredAt': _toIso8601Offset(occurredAt),
      'data': data,
    };
  }

  factory SocketEvent.fromJson(Map<String, dynamic> json) {
    return SocketEvent(
      eventId: json['eventId'] as String,
      eventType: SocketEventType.fromValue(json['eventType'] as String),
      sessionId: json['sessionId'] as String,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      data: (json['data'] as Map<String, dynamic>?) ?? const {},
    );
  }

  factory SocketEvent.transcriptChunk({
    required String sessionId,
    required TranscriptAnalyzeRequest request,
  }) {
    return SocketEvent(
      eventId: 'event-${request.chunkId}',
      eventType: SocketEventType.transcriptChunk,
      sessionId: sessionId,
      occurredAt: DateTime.now(),
      data: request.toJson(),
    );
  }

  factory SocketEvent.sessionComplete({
    required String sessionId,
    required DateTime endedAt,
    required int lastTranscriptSequence,
  }) {
    return SocketEvent(
      eventId: 'event-session-complete-${endedAt.microsecondsSinceEpoch}',
      eventType: SocketEventType.sessionComplete,
      sessionId: sessionId,
      occurredAt: endedAt,
      data: {
        'endedAt': _toIso8601Offset(endedAt),
        'lastTranscriptSequence': lastTranscriptSequence,
      },
    );
  }

  factory SocketEvent.ping({required String sessionId}) {
    final now = DateTime.now();
    return SocketEvent(
      eventId: 'event-ping-${now.microsecondsSinceEpoch}',
      eventType: SocketEventType.ping,
      sessionId: sessionId,
      occurredAt: now,
      data: const {},
    );
  }
}

class SessionReadyData {
  const SessionReadyData({required this.nextTranscriptSequence});

  final int nextTranscriptSequence;

  factory SessionReadyData.fromEvent(SocketEvent event) {
    return SessionReadyData(
      nextTranscriptSequence:
          (event.data['nextTranscriptSequence'] as num?)?.toInt() ?? 1,
    );
  }
}

class AnalysisResultData {
  const AnalysisResultData({
    required this.chunkId,
    required this.sequence,
    required this.riskScore,
    required this.phishingType,
    required this.aiSummary,
    required this.keywords,
    required this.provider,
  });

  final String chunkId;
  final int sequence;
  final int riskScore;
  final String phishingType;
  final String aiSummary;
  final List<String> keywords;
  final String provider;

  factory AnalysisResultData.fromEvent(SocketEvent event) {
    final data = event.data;
    return AnalysisResultData(
      chunkId: data['chunkId'] as String? ?? '',
      sequence: (data['sequence'] as num?)?.toInt() ?? 0,
      riskScore: (data['riskScore'] as num?)?.toInt() ?? 0,
      phishingType: data['phishingType'] as String? ?? 'NONE',
      aiSummary: data['aiSummary'] as String? ?? '',
      keywords:
          (data['keywords'] as List<dynamic>?)?.cast<String>() ?? const [],
      provider: data['provider'] as String? ?? '',
    );
  }
}

String _toIso8601Offset(DateTime dateTime) {
  final local = dateTime.toLocal();
  final offset = local.timeZoneOffset;
  final sign = offset.isNegative ? '-' : '+';
  final absoluteOffset = offset.abs();
  final hours = absoluteOffset.inHours.toString().padLeft(2, '0');
  final minutes = absoluteOffset.inMinutes
      .remainder(60)
      .toString()
      .padLeft(2, '0');

  return '${local.toIso8601String()}$sign$hours:$minutes';
}
