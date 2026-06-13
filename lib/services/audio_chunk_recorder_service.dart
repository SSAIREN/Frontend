import 'dart:async';
import 'dart:io';

import 'package:record/record.dart';

class AudioChunk {
  const AudioChunk({
    required this.path,
    required this.startedAt,
    required this.endedAt,
    required this.bytes,
  });

  final String path;
  final DateTime startedAt;
  final DateTime endedAt;
  final int bytes;
}

class AudioChunkRecorderService {
  AudioChunkRecorderService({AudioRecorder? recorder})
      : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;
  bool _isDisposed = false;
  bool _isRecording = false;

  Future<AudioChunk> recordChunk({
    required int sequence,
    required Duration duration,
  }) async {
    if (_isDisposed) {
      throw StateError('Recorder is already disposed.');
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw StateError('Microphone permission is not granted.');
    }

    final startedAt = DateTime.now();
    final fileName =
        'ssairen_call_${startedAt.microsecondsSinceEpoch}_$sequence.m4a';
    final path = [
      Directory.systemTemp.path,
      fileName,
    ].join(Platform.pathSeparator);

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 64000,
        sampleRate: 16000,
        numChannels: 1,
        autoGain: true,
        echoCancel: false,
        noiseSuppress: false,
      ),
      path: path,
    );
    _isRecording = true;

    await Future<void>.delayed(duration);

    if (_isDisposed || !_isRecording || !await _recorder.isRecording()) {
      throw StateError('Recording was cancelled before the chunk completed.');
    }

    final String? stoppedPath;
    try {
      stoppedPath = await _recorder.stop();
    } finally {
      _isRecording = false;
    }
    final outputPath = stoppedPath ?? path;
    final file = File(outputPath);
    final bytes = await file.exists() ? await file.length() : 0;

    return AudioChunk(
      path: outputPath,
      startedAt: startedAt,
      endedAt: DateTime.now(),
      bytes: bytes,
    );
  }

  Future<void> cancel() async {
    try {
      if (!_isDisposed && _isRecording && await _recorder.isRecording()) {
        await _recorder.cancel();
      }
    } catch (_) {
      // The recorder may already be stopped while the call screen is closing.
    } finally {
      _isRecording = false;
    }
  }

  Future<void> deleteChunk(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    await cancel();
    _isDisposed = true;
    await _recorder.dispose();
  }
}
