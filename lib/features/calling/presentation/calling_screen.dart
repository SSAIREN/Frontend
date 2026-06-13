import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssairen/core/config/api_config.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/features/calling/widgets/call_control_button.dart';
import 'package:ssairen/features/calling/widgets/call_gradient_background.dart';
import 'package:ssairen/features/calling/widgets/harmful_bottom_sheet.dart';
import 'package:ssairen/features/calling/widgets/risk_monitor_panel.dart';
import 'package:ssairen/features/calling/widgets/suspicious_bottom_sheet.dart';
import 'package:ssairen/models/call_session.dart';
import 'package:ssairen/models/risk_result.dart';
import 'package:ssairen/models/transcript_analysis.dart';
import 'package:ssairen/models/websocket_event.dart';
import 'package:ssairen/services/analyze_api_service.dart';
import 'package:ssairen/services/audio_chunk_recorder_service.dart';
import 'package:ssairen/services/whisper_stt_service.dart';
import 'package:ssairen/services/websocket_service.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  String _phoneNumber = '01087654321';
  bool _initialized = false;
  static const _debugStopAtWarningBranch = false;
  static const _audioChunkDuration = Duration(seconds: 5);
  static const _hapticsChannel = MethodChannel('ssairen/haptics');

  final _analyzeApiService = AnalyzeApiService();
  final _audioRecorderService = AudioChunkRecorderService();
  final _whisperSttService = WhisperSttService();
  final _webSocketService = WebSocketService();
  final Queue<_PendingAudioChunk> _sttQueue = Queue<_PendingAudioChunk>();
  final Queue<_PendingTranscriptAnalysis> _analysisQueue =
      Queue<_PendingTranscriptAnalysis>();
  Timer? _callDurationTimer;
  StreamSubscription<SocketEvent>? _socketSubscription;
  Duration _callElapsed = Duration.zero;
  int _riskPercent = 0;
  int _sttChunkSequence = 1;
  int _nextTranscriptSequence = 1;
  int _lastAcceptedSequence = 0;
  String _latestAiSummary = '현재까지 위험 표현은 감지되지 않았습니다.';
  List<String> _latestKeywords = const [];
  String _latestPhishingType = 'NONE';
  bool _shownWarningSheet = false;
  bool _shownDangerSheet = false;
  bool _isWebSocketConnected = false;
  bool _shouldRunTranscriptLoop = false;
  bool _isTranscriptLoopRunning = false;
  bool _isProcessingAudioChunk = false;
  bool _isSttQueueRunning = false;
  bool _isAnalysisQueueRunning = false;
  bool _isRiskSheetVisible = false;
  CallSession? _callSession;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      _phoneNumber = args;
    }
    _startCallDurationTimer();
    _createCallSession();
  }

  @override
  void dispose() {
    _callDurationTimer?.cancel();
    _stopTranscriptAnalysis();
    unawaited(_audioRecorderService.dispose());
    unawaited(_socketSubscription?.cancel());
    unawaited(_webSocketService.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CallGradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTiny = constraints.maxHeight < 700;
              final isCompact = constraints.maxHeight < 760;
              final riskPanelHeight = isTiny ? 136.0 : (isCompact ? 150.0 : 170.0);
              final padding = EdgeInsets.fromLTRB(
                21,
                isTiny ? 6 : (isCompact ? 10 : 16),
                21,
                isTiny ? 10 : (isCompact ? 16 : 24),
              );

              return Padding(
                padding: padding,
                child: SizedBox(
                  height: constraints.maxHeight - padding.vertical,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CallingTopBar(elapsed: _callElapsed),
                          SizedBox(height: isTiny ? 14 : (isCompact ? 24 : 38)),
                          _CallHeader(phoneNumber: _phoneNumber),
                        ],
                      ),
                      SizedBox(height: isTiny ? 16 : (isCompact ? 22 : 28)),
                      GestureDetector(
                        onTap: _captureAndAnalyzeNextTranscript,
                        child: RiskMonitorPanel(
                          percent: _riskPercent,
                          height: riskPanelHeight,
                        ),
                      ),
                      SizedBox(height: isTiny ? 36 : (isCompact ? 44 : 52)),
                      _ControlGrid(isCompact: isCompact, isTiny: isTiny),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: isTiny ? 8 : (isCompact ? 12 : 16),
                        ),
                        child: _EndCallButton(
                          onPressed: _handleEndCall,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  void _startCallDurationTimer() {
    _callDurationTimer?.cancel();
    _callDurationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _callElapsed += const Duration(seconds: 1);
      });
    });
  }

  Future<void> _createCallSession() async {
    final startedAt = DateTime.now();
    final request = CallSessionCreateRequest(
      userId: 1001,
      externalCallId: 'device-call-${startedAt.microsecondsSinceEpoch}',
      deviceId: 'victim-device-001',
      startedAt: startedAt,
      phoneNumber: _normalizedPhoneNumber,
      victim: const CallSessionVictim(name: '김영희', age: 71),
    );

    try {
      _logStt(
        'SESSION START: mock=${ApiConfig.useMockApi}, baseUrl=${ApiConfig.baseUrl}',
      );
      debugPrint(
        '[CALL_SESSION][REQUEST] '
        'userId=${request.userId}, '
        'externalCallId=${request.externalCallId}, '
        'deviceId=${request.deviceId}, '
        'phoneNumber=${request.phoneNumber}, '
        'victim=${request.victim.name}/${request.victim.age}',
      );
      _logApiJson(
        title: '[CALL_SESSION][REQUEST_BODY]',
        json: request.toJson(),
      );
      final session = await _analyzeApiService.createCallSession(request);
      if (!mounted) return;

      setState(() {
        _callSession = session;
        _nextTranscriptSequence = session.nextTranscriptSequence;
      });
      debugPrint(
        '[CALL_SESSION][RESPONSE] '
        'sessionId=${session.sessionId}, '
        'status=${session.status}, '
        'nextSequence=${session.nextTranscriptSequence}, '
        'webSocketUrl=${session.webSocketUrl}',
      );
      _logApiJson(
        title: '[CALL_SESSION][RESPONSE_BODY]',
        json: session.toJson(),
      );
      _logStt(
        'SESSION READY: ${session.sessionId}, next=${session.nextTranscriptSequence}',
      );
      _startTranscriptAnalysis();
    } catch (error, stackTrace) {
      _logStt('SESSION ERROR: $error');
      debugPrint('Failed to create call session: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _handleEndCall() {
    _callDurationTimer?.cancel();
    _stopTranscriptAnalysis();
    final session = _callSession;
    if (_isWebSocketConnected && session != null) {
      _webSocketService.sendSessionComplete(
        sessionId: session.sessionId,
        lastTranscriptSequence: _lastAcceptedSequence,
      );
    }
    debugPrint('Ending call session: ${_callSession?.sessionId ?? 'none'}');
    Navigator.of(context).maybePop();
  }

  String get _normalizedPhoneNumber {
    final digits = _phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? _phoneNumber : digits;
  }

  void _startTranscriptAnalysis() {
    _shouldRunTranscriptLoop = true;
    unawaited(_runTranscriptLoop());
  }

  void _stopTranscriptAnalysis() {
    _shouldRunTranscriptLoop = false;
    _clearSttQueue();
    _analysisQueue.clear();
    unawaited(_audioRecorderService.cancel());
  }

  void _clearSttQueue() {
    while (_sttQueue.isNotEmpty) {
      final pending = _sttQueue.removeFirst();
      unawaited(_audioRecorderService.deleteChunk(pending.audioChunk.path));
    }
  }

  Future<void> _runTranscriptLoop() async {
    if (_isTranscriptLoopRunning) return;
    _isTranscriptLoopRunning = true;

    while (mounted && _shouldRunTranscriptLoop) {
      await _captureAndAnalyzeNextTranscript();
    }

    _isTranscriptLoopRunning = false;
  }

  Future<void> _captureAndAnalyzeNextTranscript() async {
    if (_isProcessingAudioChunk) {
      _logStt('SKIP: previous audio chunk is still processing.');
      return;
    }

    final session = _callSession;
    if (session == null) {
      _logStt('WAIT: call session is not ready.');
      return;
    }

    if (!_whisperSttService.isConfigured) {
      _logStt('ERROR: OPENAI_API_KEY is empty. Check .env.');
      _shouldRunTranscriptLoop = false;
      return;
    }

    final sttSequence = _sttChunkSequence++;
    _isProcessingAudioChunk = true;

    try {
      _logStt('AUDIO START: stt=$sttSequence');
      final audioStartedAt = DateTime.now();
      final audioChunk = await _audioRecorderService.recordChunk(
        sequence: sttSequence,
        duration: _audioChunkDuration,
      );
      final audioElapsedMs = _elapsedMsSince(audioStartedAt);
      _logStt(
        'AUDIO DONE: stt=$sttSequence, bytes=${audioChunk.bytes}, elapsed=${audioElapsedMs}ms',
      );

      final queuedAt = DateTime.now();
      _sttQueue.add(
        _PendingAudioChunk(
          session: session,
          sttSequence: sttSequence,
          audioChunk: audioChunk,
          queuedAt: queuedAt,
        ),
      );
      debugPrint(
        '[STT][QUEUE_PUSH] stt=$sttSequence, pending=${_sttQueue.length}',
      );
      unawaited(_drainSttQueue());
    } catch (error, stackTrace) {
      _logStt('AUDIO ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isProcessingAudioChunk = false;
    }
  }

  Future<void> _drainSttQueue() async {
    if (_isSttQueueRunning) return;
    _isSttQueueRunning = true;

    try {
      while (mounted && _shouldRunTranscriptLoop && _sttQueue.isNotEmpty) {
        final pending = _sttQueue.removeFirst();
        await _transcribeQueuedAudio(pending);
      }
    } finally {
      _isSttQueueRunning = false;
    }
  }

  Future<void> _transcribeQueuedAudio(_PendingAudioChunk pending) async {
    final sttSequence = pending.sttSequence;
    final audioChunk = pending.audioChunk;
    final queueWaitMs = _elapsedMsSince(pending.queuedAt);

    try {
      _logStt(
        'WHISPER START: stt=$sttSequence, pending=${_sttQueue.length}, queueWait=${queueWaitMs}ms',
      );
      final whisperStartedAt = DateTime.now();
      final text = await _whisperSttService.transcribeFile(audioChunk.path);
      final whisperElapsedMs = _elapsedMsSince(whisperStartedAt);
      _logStt(
        'TEXT: stt=$sttSequence, whisper=${whisperElapsedMs}ms, "$text"',
      );

      if (text.isEmpty) {
        _logStt('SKIP: empty text. stt=$sttSequence');
        return;
      }

      final analysisSequence = _nextTranscriptSequence;
      final chunkIndex = analysisSequence - 1;
      _enqueueTranscriptAnalysis(
        session: pending.session,
        sequence: analysisSequence,
        text: text,
        startedAtMs: chunkIndex * _audioChunkDuration.inMilliseconds,
        endedAtMs: (chunkIndex + 1) * _audioChunkDuration.inMilliseconds,
      );
    } catch (error, stackTrace) {
      _logStt('WHISPER ERROR: stt=$sttSequence, $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      unawaited(_audioRecorderService.deleteChunk(audioChunk.path));
    }
  }

  void _logStt(String message) {
    final line = '[STT] $message';
    debugPrint(line);
  }

  int _elapsedMsSince(DateTime startedAt) {
    return DateTime.now().difference(startedAt).inMilliseconds;
  }

  String _formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final second = local.second.toString().padLeft(2, '0');
    final millisecond = local.millisecond.toString().padLeft(3, '0');
    return '$hour:$minute:$second.$millisecond';
  }

  void _enqueueTranscriptAnalysis({
    required CallSession session,
    required int sequence,
    required String text,
    required int startedAtMs,
    required int endedAtMs,
  }) {
    final request = TranscriptAnalyzeRequest(
      chunkId: 'chunk-${sequence.toString().padLeft(3, '0')}',
      sequence: sequence,
      text: text,
      startedAtMs: startedAtMs,
      endedAtMs: endedAtMs,
    );

    _reserveTranscriptSequence(sequence);

    if (_isWebSocketConnected) {
      _webSocketService.sendTranscriptChunk(
        sessionId: session.sessionId,
        request: request,
      );
      debugPrint('Transcript sent via WebSocket: sequence=$sequence');
      return;
    }

    _analysisQueue.add(
      _PendingTranscriptAnalysis(
        session: session,
        request: request,
        queuedAt: DateTime.now(),
      ),
    );
    debugPrint(
      '[REST_ANALYZE][QUEUE_PUSH] '
      'sequence=$sequence, pending=${_analysisQueue.length}',
    );
    unawaited(_drainAnalysisQueue());
  }

  Future<void> _drainAnalysisQueue() async {
    if (_isAnalysisQueueRunning) return;
    _isAnalysisQueueRunning = true;

    try {
      while (mounted && _analysisQueue.isNotEmpty) {
        final pending = _analysisQueue.removeFirst();
        await _sendQueuedTranscriptAnalysis(pending);
      }
    } finally {
      _isAnalysisQueueRunning = false;
    }
  }

  Future<void> _sendQueuedTranscriptAnalysis(
    _PendingTranscriptAnalysis pending,
  ) async {
    final session = pending.session;
    final request = pending.request;
    final sequence = request.sequence;
    final queueWaitMs = _elapsedMsSince(pending.queuedAt);
    final analyzeStartedAt = DateTime.now();

    try {
      _logRestAnalyzeRequest(
        sessionId: session.sessionId,
        request: request,
        requestedAt: analyzeStartedAt,
        queueWaitMs: queueWaitMs,
      );
      _logStt(
        'ANALYZE START: sequence=$sequence, at=${_formatTime(analyzeStartedAt)}, pending=${_analysisQueue.length}, queueWait=${queueWaitMs}ms',
      );
      final response = await _analyzeApiService.analyzeTranscript(
        sessionId: session.sessionId,
        request: request,
      );
      final analyzeEndedAt = DateTime.now();
      final analyzeElapsedMs = _elapsedMsSince(analyzeStartedAt);
      if (!mounted) return;

      _logRestAnalyzeResponse(
        response,
        requestedAt: analyzeStartedAt,
        respondedAt: analyzeEndedAt,
        elapsedMs: analyzeElapsedMs,
      );
      _logTranscriptSequenceSync(
        requestedSequence: sequence,
        response: response,
      );
      _logStt(
        'ANALYZE DONE: sequence=$sequence, at=${_formatTime(analyzeEndedAt)}, api=${analyzeElapsedMs}ms, score=${response.riskScore}, keywords=${response.keywords}',
      );
      _applyTranscriptProgress(
        riskScore: response.riskScore,
        nextTranscriptSequence: response.nextTranscriptSequence,
        aiSummary: response.aiSummary,
        keywords: response.keywords,
        phishingType: response.phishingType,
      );
      if (response.shouldOpenWebSocket && !_debugStopAtWarningBranch) {
        _connectWebSocket(session);
      } else if (response.shouldOpenWebSocket) {
        debugPrint(
          '[REST_ANALYZE][DECISION] '
          'shouldOpenWebSocket=true, but warning branch debug mode keeps '
          'WebSocket closed for this check.',
        );
      }
      _handleAnalysisRisk(response.riskScore);
    } catch (error, stackTrace) {
      _advanceTranscriptSequenceAfterFailure(sequence, error);
      _logStt('ANALYZE ERROR: $error');
      debugPrint('Failed to analyze transcript: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _logRestAnalyzeRequest({
    required String sessionId,
    required TranscriptAnalyzeRequest request,
    required DateTime requestedAt,
    required int queueWaitMs,
  }) {
    debugPrint(
      '[REST_ANALYZE][REQUEST] '
      'requestedAt=${_formatTime(requestedAt)}, '
      'queueWait=${queueWaitMs}ms, '
      'POST /api/mobile/call-sessions/$sessionId/transcripts/analyze '
      'chunkId=${request.chunkId}, '
      'sequence=${request.sequence}, '
      'startedAtMs=${request.startedAtMs}, '
      'endedAtMs=${request.endedAtMs}, '
      'isFinal=${request.isFinal}, '
      'text="${request.text}"',
    );
    _logApiJson(
      title: '[REST_ANALYZE][REQUEST_BODY]',
      json: request.toJson(),
    );
  }

  void _logRestAnalyzeResponse(
    TranscriptAnalyzeResponse response, {
    required DateTime requestedAt,
    required DateTime respondedAt,
    required int elapsedMs,
  }) {
    debugPrint(
      '[REST_ANALYZE][RESPONSE] '
      'requestedAt=${_formatTime(requestedAt)}, '
      'respondedAt=${_formatTime(respondedAt)}, '
      'api=${elapsedMs}ms, '
      'sessionId=${response.sessionId}, '
      'chunkId=${response.chunkId}, '
      'acceptedSequence=${response.acceptedSequence}, '
      'nextSequence=${response.nextTranscriptSequence}, '
      'duplicate=${response.duplicate}, '
      'thresholdReached=${response.analysisThresholdReached}, '
      'riskScore=${response.riskScore}, '
      'level=${RiskLevel.fromPercent(response.riskScore).label}, '
      'phishingType=${response.phishingType}, '
      'shouldOpenWebSocket=${response.shouldOpenWebSocket}, '
      'aiSummary="${response.aiSummary}", '
      'keywords=${response.keywords}',
    );
    _logApiJson(
      title: '[REST_ANALYZE][RESPONSE_BODY]',
      json: response.toJson(),
    );
  }

  void _reserveTranscriptSequence(int sequence) {
    final reservedNextSequence = sequence + 1;
    if (_nextTranscriptSequence >= reservedNextSequence) return;

    if (mounted) {
      setState(() {
        _nextTranscriptSequence = reservedNextSequence;
      });
    } else {
      _nextTranscriptSequence = reservedNextSequence;
    }

    debugPrint(
      '[REST_ANALYZE][SEQUENCE_RESERVE] '
      'sequence=$sequence, reservedNext=$reservedNextSequence',
    );
  }

  void _advanceTranscriptSequenceAfterFailure(int sequence, Object error) {
    if (!error.toString().contains('DUPLICATE_TRANSCRIPT_CONFLICT')) return;

    final nextSequence = sequence + 1;
    if (_nextTranscriptSequence >= nextSequence) return;

    if (mounted) {
      setState(() {
        _nextTranscriptSequence = nextSequence;
      });
    } else {
      _nextTranscriptSequence = nextSequence;
    }

    debugPrint(
      '[REST_ANALYZE][SEQUENCE_RECOVER] '
      'duplicate sequence=$sequence, next=$nextSequence',
    );
  }

  void _logTranscriptSequenceSync({
    required int requestedSequence,
    required TranscriptAnalyzeResponse response,
  }) {
    final expectedNextSequence = requestedSequence + 1;
    final acceptedMatches = response.acceptedSequence == requestedSequence;
    final nextMatches = response.nextTranscriptSequence == expectedNextSequence;

    debugPrint(
      '[REST_ANALYZE][SEQUENCE_SYNC] '
      'requested=$requestedSequence, '
      'accepted=${response.acceptedSequence}, '
      'next=${response.nextTranscriptSequence}, '
      'acceptedMatches=$acceptedMatches, '
      'nextMatches=$nextMatches',
    );
  }

  void _logApiJson({
    required String title,
    required Map<String, dynamic> json,
  }) {
    const encoder = JsonEncoder.withIndent('  ');
    debugPrint('$title\n${encoder.convert(json)}');
  }

  void _applyTranscriptProgress({
    required int riskScore,
    required int nextTranscriptSequence,
    required String aiSummary,
    required List<String> keywords,
    required String phishingType,
  }) {
    setState(() {
      _riskPercent = riskScore;
      if (nextTranscriptSequence > _nextTranscriptSequence) {
        _nextTranscriptSequence = nextTranscriptSequence;
      }
      _latestAiSummary = aiSummary;
      _latestKeywords = keywords;
      _latestPhishingType = phishingType;
      final acceptedSequence = nextTranscriptSequence - 1;
      if (acceptedSequence > _lastAcceptedSequence) {
        _lastAcceptedSequence = acceptedSequence;
      }
    });
  }

  void _connectWebSocket(CallSession session) {
    if (_isWebSocketConnected) return;

    debugPrint('Opening WebSocket for session: ${session.sessionId}');
    setState(() {
      _isWebSocketConnected = true;
    });
    unawaited(_socketSubscription?.cancel());
    _socketSubscription = _webSocketService
        .connect(
          session,
          nextTranscriptSequence: _nextTranscriptSequence,
        )
        .listen(
      _handleSocketEvent,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('WebSocket error: $error');
        debugPrintStack(stackTrace: stackTrace);
      },
      onDone: () {
        debugPrint('WebSocket closed.');
        if (!mounted) return;
        setState(() {
          _isWebSocketConnected = false;
        });
      },
    );
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!mounted) return;

    debugPrint('WebSocket event received: ${event.eventType.value}');

    switch (event.eventType) {
      case SocketEventType.sessionReady:
        final data = SessionReadyData.fromEvent(event);
        setState(() {
          _isWebSocketConnected = true;
          _nextTranscriptSequence = data.nextTranscriptSequence;
        });
      case SocketEventType.transcriptAck:
        setState(() {
          _lastAcceptedSequence = event.data['acceptedSequence'] as int;
          _nextTranscriptSequence = event.data['nextTranscriptSequence'] as int;
        });
      case SocketEventType.analysisResult:
        final data = AnalysisResultData.fromEvent(event);
        _applyTranscriptProgress(
          riskScore: data.riskScore,
          nextTranscriptSequence: data.sequence + 1,
          aiSummary: data.aiSummary,
          keywords: data.keywords,
          phishingType: data.phishingType,
        );
        _handleAnalysisRisk(data.riskScore);
      case SocketEventType.sessionCompleteAck:
        debugPrint('Session complete ack received.');
      case SocketEventType.analysisError:
        debugPrint('WebSocket analysis error data: ${event.data}');
      case SocketEventType.transcriptNack:
        _handleTranscriptNack(event);
      case SocketEventType.transcriptChunk:
      case SocketEventType.sessionComplete:
      case SocketEventType.ping:
      case SocketEventType.pong:
        break;
    }
  }

  void _handleTranscriptNack(SocketEvent event) {
    final details = event.data['details'];
    if (details is Map<String, dynamic>) {
      final expectedSequence = details['expectedSequence'];
      if (expectedSequence is int) {
        setState(() {
          _nextTranscriptSequence = expectedSequence;
        });
      }
    }
    debugPrint('WebSocket transcript nack data: ${event.data}');
  }

  void _handleAnalysisRisk(int riskScore) {
    final level = RiskLevel.fromPercent(riskScore);
    if (_isRiskSheetVisible) {
      debugPrint(
        '[RISK_BOTTOM_SHEET][SKIP] '
        'already visible, level=${level.label}, riskScore=$riskScore',
      );
      return;
    }

    if (level == RiskLevel.warning && !_shownWarningSheet) {
      _shownWarningSheet = true;
      _isRiskSheetVisible = true;
      if (_debugStopAtWarningBranch) {
        _stopTranscriptAnalysis();
        debugPrint(
          '[WARNING_BRANCH][PAUSE] '
          'STT transcript loop stopped after warning state for inspection.',
        );
      }
      _showSuspiciousSheet();
    }
    if (level == RiskLevel.danger && !_shownDangerSheet) {
      _shownDangerSheet = true;
      _isRiskSheetVisible = true;
      _showHarmfulSheet();
    }
  }

  void _showSuspiciousSheet() {
    unawaited(_vibrateForRisk(RiskLevel.warning));
    debugPrint(
      '[WARNING_BOTTOM_SHEET][SHOW] '
      'percent=${_riskPercent ?? 'none'}, '
      'aiSummary="$_latestAiSummary", '
      'keywords=$_latestKeywords, '
      'phishingType=$_latestPhishingType',
    );
    showModalBottomSheet<void>(
      context: context,
      barrierColor: AppColors.overlayDim,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return SuspiciousBottomSheet(
          percent: _riskPercent,
          aiSummary: _latestAiSummary,
          keywords: _latestKeywords,
          onEndCall: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(
              RoutePaths.policeShare,
              arguments: _callElapsed,
            );
          },
        );
      },
    ).whenComplete(() {
      _shownWarningSheet = false;
      _isRiskSheetVisible = false;
      debugPrint('[WARNING_BOTTOM_SHEET][DISMISS]');
    });
  }

  void _showHarmfulSheet() {
    unawaited(_vibrateForRisk(RiskLevel.danger));
    debugPrint(
      '[DANGER_BOTTOM_SHEET][SHOW] '
      'percent=${_riskPercent ?? 'none'}, '
      'aiSummary="$_dangerAiSummary", '
      'keywords=$_dangerKeywords, '
      'phishingType=$_latestPhishingType',
    );
    showModalBottomSheet<void>(
      context: context,
      barrierColor: AppColors.overlayDim,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => HarmfulBottomSheet(
        percent: _riskPercent,
        aiSummary: _dangerAiSummary,
        keywords: _dangerKeywords,
        onRunPlan: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(RoutePaths.harmfulDashboard);
        },
        onEndCall: () {
          Navigator.of(context).pop();
          _handleEndCall();
        },
      ),
    ).whenComplete(() {
      _shownDangerSheet = false;
      _isRiskSheetVisible = false;
      debugPrint('[DANGER_BOTTOM_SHEET][DISMISS]');
    });
  }

  Future<void> _vibrateForRisk(RiskLevel level) async {
    final count = level == RiskLevel.danger ? 2 : 1;
    try {
      await _hapticsChannel.invokeMethod<void>('riskVibrate', {
        'count': count,
      });
      debugPrint('[RISK_VIBRATION] native count=$count');
    } catch (error) {
      debugPrint('[RISK_VIBRATION][FALLBACK] $error');
      for (var i = 0; i < count; i += 1) {
        await HapticFeedback.vibrate();
        if (i < count - 1) {
          await Future<void>.delayed(const Duration(milliseconds: 160));
        }
      }
    }
  }

  String get _dangerAiSummary {
    if (_latestAiSummary.isNotEmpty) return _latestAiSummary;
    return '가족을 사칭한 협박과 입금 유도 표현이 탐지되었습니다.';
  }

  List<String> get _dangerKeywords {
    if (_latestKeywords.isNotEmpty) return _latestKeywords;
    if (_latestPhishingType == 'FAMILY_THREAT') {
      return const ['납치', '아들', '입금'];
    }
    return const ['납치', '아들', '입금'];
  }
}

class _PendingAudioChunk {
  const _PendingAudioChunk({
    required this.session,
    required this.sttSequence,
    required this.audioChunk,
    required this.queuedAt,
  });

  final CallSession session;
  final int sttSequence;
  final AudioChunk audioChunk;
  final DateTime queuedAt;
}

class _PendingTranscriptAnalysis {
  const _PendingTranscriptAnalysis({
    required this.session,
    required this.request,
    required this.queuedAt,
  });

  final CallSession session;
  final TranscriptAnalyzeRequest request;
  final DateTime queuedAt;
}

class _CallingTopBar extends StatelessWidget {
  const _CallingTopBar({required this.elapsed});

  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Row(
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Text(
            'UHD',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Voice $minutes:$seconds',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        const Icon(Icons.videocam, color: Colors.white, size: 26),
      ],
    );
  }
}

class _CallHeader extends StatelessWidget {
  const _CallHeader({required this.phoneNumber});

  final String phoneNumber;

  String get _formatted {
    final d = phoneNumber;
    if (d.length <= 3) return d;
    if (d.length <= 7) return '${d.substring(0, 3)}-${d.substring(3)}';
    return '${d.substring(0, 3)}-${d.substring(3, 7)}-${d.substring(7)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/calling-ssiren-icon.png',
              width: 18,
              height: 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'SSIREN',
              style: TextStyle(
                color: AppColors.brandBlueLight,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          _formatted,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 31,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _ControlGrid extends StatelessWidget {
  const _ControlGrid({
    required this.isCompact,
    required this.isTiny,
  });

  final bool isCompact;
  final bool isTiny;

  @override
  Widget build(BuildContext context) {
    final rowGap = isTiny ? 12.0 : (isCompact ? 18.0 : 28.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ControlButtonSlot(
              child: CallControlButton(icon: Icons.voicemail, label: '녹음'),
            ),
            _ControlButtonSlot(
              child: CallControlButton(
                icon: Icons.mic_off_outlined,
                label: '내 소리 차단',
              ),
            ),
            _ControlButtonSlot(
              child: CallControlButton(icon: Icons.bluetooth, label: '블루투스'),
            ),
          ],
        ),
        SizedBox(height: rowGap),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ControlButtonSlot(
              child: CallControlButton(
                icon: Icons.volume_up_outlined,
                label: '스피커',
              ),
            ),
            _ControlButtonSlot(
              child: CallControlButton(icon: Icons.dialpad, label: '키패드'),
            ),
            _ControlButtonSlot(
              child: CallControlButton(icon: Icons.more_vert, label: '더 보기'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ControlButtonSlot extends StatelessWidget {
  const _ControlButtonSlot({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: child,
    );
  }
}

class _EndCallButton extends StatelessWidget {
  const _EndCallButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 62,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.dangerRedBright,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
        ),
        icon: const Icon(Icons.call_end, size: 32),
      ),
    );
  }
}
