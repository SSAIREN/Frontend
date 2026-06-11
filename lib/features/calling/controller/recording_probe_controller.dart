import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

class RecordingProbeController extends ChangeNotifier {
  final AudioRecorder _recorder = AudioRecorder();

  StreamSubscription<Uint8List>? _audioSub;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Timer? _timer;

  bool _isRecording = false;
  bool _hasPermission = false;
  String? _errorMessage;
  double _currentDb = 0;
  double _maxDb = 0;
  int _elapsedSeconds = 0;
  int _totalBytes = 0;
  int _currentChunkBytes = 0;
  int _lastChunkBytes = 0;
  int _chunkCount = 0;

  bool get isRecording => _isRecording;
  bool get hasPermission => _hasPermission;
  String? get errorMessage => _errorMessage;
  double get currentDb => _currentDb;
  double get maxDb => _maxDb;
  int get elapsedSeconds => _elapsedSeconds;
  int get totalBytes => _totalBytes;
  int get currentChunkBytes => _currentChunkBytes;
  int get lastChunkBytes => _lastChunkBytes;
  int get chunkCount => _chunkCount;

  Future<void> start() async {
    if (_isRecording) return;

    try {
      _errorMessage = null;
      _hasPermission = await _recorder.hasPermission();

      if (!_hasPermission) {
        _errorMessage = '마이크 권한이 필요합니다.';
        notifyListeners();
        return;
      }

      _resetStats();

      final stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      _audioSub = stream.listen(
        (chunk) {
          _totalBytes += chunk.length;
          _currentChunkBytes += chunk.length;
          notifyListeners();
        },
        onError: (Object error) {
          _errorMessage = '오디오 스트림 오류: $error';
          notifyListeners();
        },
      );

      _amplitudeSub = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 300))
          .listen((amplitude) {
        _currentDb = amplitude.current;
        _maxDb = amplitude.max;
        notifyListeners();
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _elapsedSeconds++;
        if (_elapsedSeconds % 5 == 0) {
          _lastChunkBytes = _currentChunkBytes;
          _currentChunkBytes = 0;
          _chunkCount++;
        }
        notifyListeners();
      });

      _isRecording = true;
      notifyListeners();
    } catch (error) {
      _errorMessage = '녹음 시작 실패: $error';
      await stop();
      notifyListeners();
    }
  }

  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    await _audioSub?.cancel();
    _audioSub = null;
    await _amplitudeSub?.cancel();
    _amplitudeSub = null;

    try {
      await _recorder.stop();
    } catch (_) {
      // The recorder may not have started if permission or device capture failed.
    }

    _isRecording = false;
    notifyListeners();
  }

  Future<void> disposeRecorder() async {
    await stop();
    await _recorder.dispose();
  }

  void _resetStats() {
    _currentDb = 0;
    _maxDb = 0;
    _elapsedSeconds = 0;
    _totalBytes = 0;
    _currentChunkBytes = 0;
    _lastChunkBytes = 0;
    _chunkCount = 0;
  }
}
