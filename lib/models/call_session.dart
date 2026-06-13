class CallSessionCreateRequest {
  const CallSessionCreateRequest({
    required this.userId,
    required this.externalCallId,
    required this.deviceId,
    required this.startedAt,
    required this.phoneNumber,
    required this.victim,
  });

  final int userId;
  final String externalCallId;
  final String deviceId;
  final DateTime startedAt;
  final String phoneNumber;
  final CallSessionVictim victim;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'externalCallId': externalCallId,
      'deviceId': deviceId,
      'startedAt': _toIso8601Offset(startedAt),
      'phoneNumber': phoneNumber,
      'victim': victim.toJson(),
    };
  }
}

class CallSessionVictim {
  const CallSessionVictim({
    required this.name,
    required this.age,
  });

  final String name;
  final int age;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}

class CallSession {
  const CallSession({
    required this.sessionId,
    required this.status,
    required this.nextTranscriptSequence,
    required this.accumulatedTranscriptCharacters,
    required this.startedAt,
    required this.webSocketUrl,
    this.endedAt,
  });

  final String sessionId;
  final String status;
  final int nextTranscriptSequence;
  final int accumulatedTranscriptCharacters;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String webSocketUrl;

  factory CallSession.fromJson(Map<String, dynamic> json) {
    return CallSession(
      sessionId: _readString(json['sessionId'], ''),
      status: _readString(json['status'], 'ACTIVE'),
      nextTranscriptSequence: _readInt(json['nextTranscriptSequence'], 1),
      accumulatedTranscriptCharacters:
          _readInt(json['accumulatedTranscriptCharacters'], 0),
      startedAt: _readDateTime(json['startedAt'], DateTime.now()),
      endedAt: json['endedAt'] == null
          ? null
          : _readDateTime(json['endedAt'], DateTime.now()),
      webSocketUrl: _readString(json['webSocketUrl'], ''),
    );
  }

  factory CallSession.mock(CallSessionCreateRequest request) {
    final sessionId = 'mock-${request.externalCallId}';

    return CallSession(
      sessionId: sessionId,
      status: 'ACTIVE',
      nextTranscriptSequence: 1,
      accumulatedTranscriptCharacters: 0,
      startedAt: request.startedAt,
      webSocketUrl: '/ws/v1/victim?sessionId=$sessionId',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'status': status,
      'nextTranscriptSequence': nextTranscriptSequence,
      'accumulatedTranscriptCharacters': accumulatedTranscriptCharacters,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'webSocketUrl': webSocketUrl,
    };
  }
}

String _readString(Object? value, String fallback) {
  if (value is String && value.trim().isNotEmpty) return value;
  return fallback;
}

int _readInt(Object? value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

DateTime _readDateTime(Object? value, DateTime fallback) {
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value) ?? fallback;
  }
  return fallback;
}

String _toIso8601Offset(DateTime dateTime) {
  final local = dateTime.toLocal();
  final offset = local.timeZoneOffset;
  final sign = offset.isNegative ? '-' : '+';
  final absoluteOffset = offset.abs();
  final hours = absoluteOffset.inHours.toString().padLeft(2, '0');
  final minutes = absoluteOffset.inMinutes.remainder(60).toString().padLeft(
        2,
        '0',
      );

  return '${local.toIso8601String()}$sign$hours:$minutes';
}
