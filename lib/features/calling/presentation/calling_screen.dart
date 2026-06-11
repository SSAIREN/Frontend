import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/features/calling/widgets/call_control_button.dart';
import 'package:ssairen/features/calling/widgets/call_gradient_background.dart';
import 'package:ssairen/features/calling/widgets/risk_monitor_panel.dart';

class CallingScreen extends StatelessWidget {
  const CallingScreen({super.key});

  static const _mockRiskPercent = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CallGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(21, 16, 21, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.sizeOf(context).height -
                    MediaQuery.paddingOf(context).vertical -
                    40,
              ),
              child: Column(
                children: [
                  const _CallingTopBar(),
                  const SizedBox(height: 38),
                  const _CallHeader(),
                  const SizedBox(height: 42),
                  const RiskMonitorPanel(
                    percent: CallingScreen._mockRiskPercent,
                  ),
                  const SizedBox(height: 28),
                  const _ControlGrid(),
                  const SizedBox(height: 34),
                  _EndCallButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CallingTopBar extends StatelessWidget {
  const _CallingTopBar();

  @override
  Widget build(BuildContext context) {
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
        const Text(
          'Voice 02:46',
          style: TextStyle(
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
  const _CallHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.health_and_safety,
              color: AppColors.brandBlueLight,
              size: 19,
            ),
            SizedBox(width: 8),
            Text(
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
        SizedBox(height: 6),
        Text(
          '010-8765-4321',
          style: TextStyle(
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
  const _ControlGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: 28,
      crossAxisSpacing: 45,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.82,
      children: const [
        CallControlButton(icon: Icons.voicemail, label: '녹음'),
        CallControlButton(icon: Icons.mic_off_outlined, label: '내 소리 차단'),
        CallControlButton(icon: Icons.bluetooth, label: '경민의 Watch5'),
        CallControlButton(icon: Icons.volume_up_outlined, label: '스피커'),
        CallControlButton(icon: Icons.dialpad, label: '키패드'),
        CallControlButton(icon: Icons.more_vert, label: '더 보기'),
      ],
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
