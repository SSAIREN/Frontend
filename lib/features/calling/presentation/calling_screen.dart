import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:ssairen/services/websocket_service.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  String _phoneNumber = '01087654321';
  bool _initialized = false;
  static const _debugStopAtWarningBranch = true;
  static const _mockTranscriptTexts = [
    '지금은 평범한 통화 내용입니다.',
    '계좌 확인이 필요하다는 표현이 나왔습니다.',
    '검찰 수사관입니다. 안전 계좌로 입금하세요.',
    '아들을 데리고 있습니다. 지금 바로 입금하세요.',
  ];

  final _analyzeApiService = AnalyzeApiService();
  final _webSocketService = WebSocketService();
  Timer? _callDurationTimer;
  Timer? _transcriptTimer;
  StreamSubscription<SocketEvent>? _socketSubscription;
  Duration _callElapsed = Duration.zero;
  int _riskPercent = 12;
  int _nextTranscriptSequence = 1;
  int _lastAcceptedSequence = 0;
  int _mockTranscriptIndex = 0;
  String _latestAiSummary = '현재까지 위험 표현은 감지되지 않았습니다.';
  List<String> _latestKeywords = const [];
  String _latestPhishingType = 'NONE';
  bool _shownWarningSheet = false;
  bool _shownDangerSheet = false;
  bool _isWebSocketConnected = false;
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
    _transcriptTimer?.cancel();
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
              final isCompact = constraints.maxHeight < 720;
              final padding = EdgeInsets.fromLTRB(
                21,
                isCompact ? 10 : 16,
                21,
                isCompact ? 16 : 24,
              );

              return SingleChildScrollView(
                padding: padding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - padding.vertical,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CallingTopBar(elapsed: _callElapsed),
                          SizedBox(height: isCompact ? 24 : 38),
                          _CallHeader(phoneNumber: _phoneNumber),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: isCompact ? 24 : 34),
                          GestureDetector(
                            onTap: _sendNextMockTranscript,
                            child: RiskMonitorPanel(percent: _riskPercent),
                          ),
                          SizedBox(height: isCompact ? 20 : 28),
                          _ControlGrid(isCompact: isCompact),
                          SizedBox(height: isCompact ? 24 : 34),
                          _EndCallButton(
                            onPressed: _handleEndCall,
                          ),
                        ],
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
      phoneNumber: _phoneNumber,
      victim: const CallSessionVictim(name: '김영희', age: 71),
    );

    try {
      debugPrint(
        '[CALL_SESSION][REQUEST] '
        'userId=${request.userId}, '
        'externalCallId=${request.externalCallId}, '
        'deviceId=${request.deviceId}, '
        'phoneNumber=${request.phoneNumber}, '
        'victim=${request.victim.name}/${request.victim.age}',
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
      _startTranscriptAnalysis();
    } catch (error, stackTrace) {
      debugPrint('Failed to create call session: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _handleEndCall() {
    _callDurationTimer?.cancel();
    _transcriptTimer?.cancel();
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

  void _startTranscriptAnalysis() {
    _transcriptTimer?.cancel();
    _sendNextMockTranscript();
    _transcriptTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _sendNextMockTranscript(),
    );
  }

  Future<void> _sendNextMockTranscript() async {
    final session = _callSession;
    if (session == null) return;

    final sequence = _nextTranscriptSequence;
    final chunkIndex = sequence - 1;
    final transcriptIndex = _mockTranscriptIndex.clamp(
      0,
      _mockTranscriptTexts.length - 1,
    ).toInt();
    final text = _mockTranscriptTexts[transcriptIndex];
    final request = TranscriptAnalyzeRequest(
      chunkId: 'chunk-${sequence.toString().padLeft(3, '0')}',
      sequence: sequence,
      text: text,
      startedAtMs: chunkIndex * 5000,
      endedAtMs: (chunkIndex + 1) * 5000,
    );

    try {
      if (_isWebSocketConnected) {
        _webSocketService.sendTranscriptChunk(
          sessionId: session.sessionId,
          request: request,
        );
        debugPrint('Transcript sent via WebSocket: sequence=$sequence');
        return;
      }

      _logRestAnalyzeRequest(
        sessionId: session.sessionId,
        request: request,
      );
      final response = await _analyzeApiService.analyzeTranscript(
        sessionId: session.sessionId,
        request: request,
      );
      if (!mounted) return;

      _logRestAnalyzeResponse(response);
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
      debugPrint('Failed to analyze transcript: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _logRestAnalyzeRequest({
    required String sessionId,
    required TranscriptAnalyzeRequest request,
  }) {
    debugPrint(
      '[REST_ANALYZE][REQUEST] '
      'POST /api/mobile/call-sessions/$sessionId/transcripts/analyze '
      'chunkId=${request.chunkId}, '
      'sequence=${request.sequence}, '
      'startedAtMs=${request.startedAtMs}, '
      'endedAtMs=${request.endedAtMs}, '
      'isFinal=${request.isFinal}, '
      'text="${request.text}"',
    );
  }

  void _logRestAnalyzeResponse(TranscriptAnalyzeResponse response) {
    debugPrint(
      '[REST_ANALYZE][RESPONSE] '
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
      _nextTranscriptSequence = nextTranscriptSequence;
      _latestAiSummary = aiSummary;
      _latestKeywords = keywords;
      _latestPhishingType = phishingType;
      _lastAcceptedSequence = nextTranscriptSequence - 1;
      if (_mockTranscriptIndex < _mockTranscriptTexts.length - 1) {
        _mockTranscriptIndex += 1;
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
    if (level == RiskLevel.warning && !_shownWarningSheet) {
      _shownWarningSheet = true;
      if (_debugStopAtWarningBranch) {
        _transcriptTimer?.cancel();
        debugPrint(
          '[WARNING_BRANCH][PAUSE] '
          'Mock transcript timer stopped after warning state for inspection.',
        );
      }
      _showSuspiciousSheet();
    }
    if (level == RiskLevel.danger && !_shownDangerSheet) {
      _shownDangerSheet = true;
      _showHarmfulSheet();
    }
  }

  void _showSuspiciousSheet() {
    debugPrint(
      '[WARNING_BOTTOM_SHEET][SHOW] '
      'percent=$_riskPercent, '
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
    );
  }

  void _showHarmfulSheet() {
    showModalBottomSheet<void>(
      context: context,
      barrierColor: AppColors.overlayDim,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => HarmfulBottomSheet(
        percent: _riskPercent,
        aiSummary: _dangerAiSummary,
        keywords: _dangerKeywords,
      ),
    );
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
  const _ControlGrid({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final rowGap = isCompact ? 18.0 : 28.0;

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
