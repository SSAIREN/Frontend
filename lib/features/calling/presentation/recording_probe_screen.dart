import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/features/calling/controller/recording_probe_controller.dart';

class RecordingProbeScreen extends StatefulWidget {
  const RecordingProbeScreen({super.key});

  @override
  State<RecordingProbeScreen> createState() => _RecordingProbeScreenState();
}

class _RecordingProbeScreenState extends State<RecordingProbeScreen> {
  late final RecordingProbeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RecordingProbeController();
  }

  @override
  void dispose() {
    unawaited(_controller.disposeRecorder());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('통화 중 녹음 테스트'),
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _GuideCard(isRecording: _controller.isRecording),
                const SizedBox(height: 16),
                _StatusCard(controller: _controller),
                const SizedBox(height: 16),
                _MetricGrid(controller: _controller),
                if (_controller.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _ErrorBox(message: _controller.errorMessage!),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _controller.isRecording
                      ? _controller.stop
                      : _controller.start,
                  icon: Icon(_controller.isRecording ? Icons.stop : Icons.mic),
                  label: Text(_controller.isRecording ? '녹음 중지' : '녹음 시작'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _controller.isRecording
                        ? AppColors.dangerRedBright
                        : AppColors.brandBlue,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed(
                    RoutePaths.calling,
                  ),
                  icon: const Icon(Icons.phone_in_talk),
                  label: const Text('통화 UI 화면 보기'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.isRecording});

  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgBlueSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.brandBlue.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isRecording ? Icons.mic : Icons.info_outline,
                color: isRecording ? AppColors.safeGreen : AppColors.brandBlue,
              ),
              const SizedBox(width: 8),
              Text(
                isRecording ? '녹음 테스트 진행 중' : '테스트 방법',
                style: const TextStyle(
                  color: AppColors.brandBlueDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '1. 실제 전화 통화 연결\n'
            '2. 스피커폰 ON\n'
            '3. 이 화면으로 돌아와 녹음 시작\n'
            '4. 상대방 목소리에 따라 dB와 bytes가 움직이는지 확인',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.controller});

  final RecordingProbeController controller;

  @override
  Widget build(BuildContext context) {
    final color =
        controller.isRecording ? AppColors.safeGreen : AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(
              controller.isRecording ? Icons.graphic_eq : Icons.mic_none,
              color: color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isRecording ? '마이크 스트림 수신 중' : '대기 중',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '권한: ${controller.hasPermission ? '허용됨' : '미확인/미허용'}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.controller});

  final RecordingProbeController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.55,
      children: [
        _MetricTile(label: '시간', value: _duration(controller.elapsedSeconds)),
        _MetricTile(
          label: '현재 dB',
          value: controller.currentDb.toStringAsFixed(1),
        ),
        _MetricTile(
          label: '최대 dB',
          value: controller.maxDb.toStringAsFixed(1),
        ),
        _MetricTile(label: '총 bytes', value: '${controller.totalBytes}'),
        _MetricTile(label: '5초 청크 수', value: '${controller.chunkCount}'),
        _MetricTile(
          label: '최근 청크 bytes',
          value: '${controller.lastChunkBytes}',
        ),
      ],
    );
  }

  String _duration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final rest = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$rest';
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dangerRedBright.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.dangerRedBright.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.dangerRed,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
