import 'dart:async';
import 'dart:convert';

import 'package:ssairen/core/config/api_config.dart';
import 'package:ssairen/models/call_session.dart';
import 'package:ssairen/models/transcript_analysis.dart';
import 'package:ssairen/models/websocket_event.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService();

  WebSocketChannel? _channel;
  StreamController<SocketEvent>? _mockController;

  Stream<SocketEvent> connect(
    CallSession session, {
    int? nextTranscriptSequence,
  }) {
    if (ApiConfig.useMockApi) {
      return _connectMock(
        session,
        nextTranscriptSequence: nextTranscriptSequence,
      );
    }

    final uri = _buildWebSocketUri(session.webSocketUrl);
    _channel = WebSocketChannel.connect(uri);

    return _channel!.stream.map((event) {
      final json = jsonDecode(event as String) as Map<String, dynamic>;
      return SocketEvent.fromJson(json);
    });
  }

  void sendTranscriptChunk({
    required String sessionId,
    required TranscriptAnalyzeRequest request,
  }) {
    final event = SocketEvent.transcriptChunk(
      sessionId: sessionId,
      request: request,
    );

    if (ApiConfig.useMockApi) {
      _emitMockTranscriptResponse(event);
      return;
    }

    _channel?.sink.add(jsonEncode(event.toJson()));
  }

  void sendSessionComplete({
    required String sessionId,
    required int lastTranscriptSequence,
  }) {
    final endedAt = DateTime.now();
    final event = SocketEvent.sessionComplete(
      sessionId: sessionId,
      endedAt: endedAt,
      lastTranscriptSequence: lastTranscriptSequence,
    );

    if (ApiConfig.useMockApi) {
      _mockController?.add(
        SocketEvent(
          eventId: 'server-session-complete-${endedAt.microsecondsSinceEpoch}',
          eventType: SocketEventType.sessionCompleteAck,
          sessionId: sessionId,
          occurredAt: endedAt,
          data: const {
            'status': 'COMPLETED',
            'finalAnalysisQueued': true,
          },
        ),
      );
      return;
    }

    _channel?.sink.add(jsonEncode(event.toJson()));
  }

  Future<void> close() async {
    await _mockController?.close();
    _mockController = null;
    await _channel?.sink.close();
    _channel = null;
  }

  Stream<SocketEvent> _connectMock(
    CallSession session, {
    int? nextTranscriptSequence,
  }) {
    unawaited(_mockController?.close());
    _mockController = StreamController<SocketEvent>.broadcast();

    Future<void>.delayed(const Duration(milliseconds: 150), () {
      if (_mockController?.isClosed ?? true) return;
      _mockController?.add(
        SocketEvent(
          eventId: 'server-session-ready-${DateTime.now().microsecondsSinceEpoch}',
          eventType: SocketEventType.sessionReady,
          sessionId: session.sessionId,
          occurredAt: DateTime.now(),
          data: {
            'nextTranscriptSequence':
                nextTranscriptSequence ?? session.nextTranscriptSequence,
          },
        ),
      );
    });

    return _mockController!.stream;
  }

  void _emitMockTranscriptResponse(SocketEvent requestEvent) {
    final request = TranscriptAnalyzeRequest(
      chunkId: requestEvent.data['chunkId'] as String,
      sequence: requestEvent.data['sequence'] as int,
      text: requestEvent.data['text'] as String,
      startedAtMs: requestEvent.data['startedAtMs'] as int,
      endedAtMs: requestEvent.data['endedAtMs'] as int,
      isFinal: requestEvent.data['isFinal'] as bool,
    );
    final response = TranscriptAnalyzeResponse.mock(
      sessionId: requestEvent.sessionId,
      request: request,
    );

    Future<void>.delayed(const Duration(milliseconds: 120), () {
      if (_mockController?.isClosed ?? true) return;
      _mockController?.add(
        SocketEvent(
          eventId: 'server-ack-${request.chunkId}',
          eventType: SocketEventType.transcriptAck,
          sessionId: requestEvent.sessionId,
          occurredAt: DateTime.now(),
          data: {
            'chunkId': response.chunkId,
            'acceptedSequence': response.acceptedSequence,
            'nextTranscriptSequence': response.nextTranscriptSequence,
            'duplicate': response.duplicate,
            'analysisThresholdReached': response.analysisThresholdReached,
          },
        ),
      );
      _mockController?.add(
        SocketEvent(
          eventId: 'server-analysis-${request.chunkId}',
          eventType: SocketEventType.analysisResult,
          sessionId: requestEvent.sessionId,
          occurredAt: DateTime.now(),
          data: {
            'chunkId': response.chunkId,
            'sequence': response.acceptedSequence,
            'riskScore': response.riskScore,
            'phishingType': response.phishingType,
            'aiSummary': response.aiSummary,
            'keywords': response.keywords,
            'provider': 'mock',
          },
        ),
      );
    });
  }

  Uri _buildWebSocketUri(String webSocketUrl) {
    final baseUri = Uri.parse(ApiConfig.baseUrl);
    final scheme = baseUri.scheme == 'https' ? 'wss' : 'ws';

    return Uri(
      scheme: scheme,
      host: baseUri.host,
      port: baseUri.port == 0 ? null : baseUri.port,
      path: Uri.parse(webSocketUrl).path,
      query: Uri.parse(webSocketUrl).query,
    );
  }
}
