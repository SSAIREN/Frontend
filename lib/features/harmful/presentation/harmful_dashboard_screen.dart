import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';

class HarmfulDashboardScreen extends StatelessWidget {
  const HarmfulDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(21, 18, 21, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height -
                  MediaQuery.paddingOf(context).vertical -
                  42,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _DangerCallBanner(),
                const SizedBox(height: 28),
                const _FamilyReplyCard(),
                const SizedBox(height: 24),
                const _LocationCard(),
                const SizedBox(height: 18),
                const _PoliceStatusCard(),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.call_end, size: 22),
                  label: const Text('전화 끊기'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.dangerRedBright,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 10,
                    shadowColor: AppColors.dangerRedBright.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DangerCallBanner extends StatelessWidget {
  const _DangerCallBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4E6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.dangerRedBright),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.dangerRedBright,
            size: 28,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              '010-8765-4321',
              style: TextStyle(
                color: AppColors.brandBlueDark,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          Text(
            '02:45',
            style: TextStyle(
              color: AppColors.dangerRed,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyReplyCard extends StatelessWidget {
  const _FamilyReplyCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.brandBlue,
                child: Text(
                  '아',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '아들에게 답장이 왔어요!',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          width: 19,
                          height: 19,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16C784),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '보호 대상자 상태 확인됨',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.chat_bubble, color: AppColors.brandBlue, size: 21),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '엄마 나 친구들이랑 강남에서 노는중...',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _MapPreview(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.brandBlue,
                  size: 23,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '서울시 강남구',
                        style: TextStyle(
                          color: AppColors.brandBlueDark,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '현재 보호 대상자 위치',
                        style: TextStyle(
                          color: AppColors.brandBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'REAL-TIME GPS',
                    style: TextStyle(
                      color: AppColors.brandBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PoliceStatusCard extends StatelessWidget {
  const _PoliceStatusCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.health_and_safety,
              color: AppColors.brandBlue,
              size: 27,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '경찰이 상황을 지켜보고 있어요',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '긴급 출동 대기 상태 · 서초경찰서',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.45),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _MapPainter(),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _CurrentLocationPin(),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'REAL-TIME GPS',
                style: TextStyle(
                  color: AppColors.brandBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentLocationPin extends StatelessWidget {
  const _CurrentLocationPin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: AppColors.brandBlue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandBlue.withValues(alpha: 0.36),
            blurRadius: 12,
            spreadRadius: 4,
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.clipBehavior = Clip.none,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFEAF0E6);
    canvas.drawRect(Offset.zero & size, background);

    _drawBlocks(canvas, size);
    _drawRoad(canvas, size, const Offset(-20, 42), const Offset(190, 18), 18);
    _drawRoad(canvas, size, const Offset(50, -20), const Offset(320, 210), 22);
    _drawRoad(canvas, size, const Offset(-30, 136), const Offset(400, 114), 20);
    _drawRoad(canvas, size, const Offset(235, -20), const Offset(178, 210), 16);

    final subway = Paint()
      ..color = const Color(0xFF2DA44E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.03, size.height * 0.72),
      Offset(size.width * 0.95, size.height * 0.22),
      subway,
    );

    final traffic = Paint()
      ..color = const Color(0xFFFACC15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.58, size.height),
      traffic,
    );
  }

  void _drawBlocks(Canvas canvas, Size size) {
    final blockPaint = Paint()..color = Colors.white.withValues(alpha: 0.75);
    final borderPaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rects = <Rect>[
      Rect.fromLTWH(14, 12, 78, 36),
      Rect.fromLTWH(112, 8, 92, 42),
      Rect.fromLTWH(244, 16, 86, 36),
      Rect.fromLTWH(20, 72, 96, 44),
      Rect.fromLTWH(146, 67, 76, 46),
      Rect.fromLTWH(264, 75, 92, 45),
      Rect.fromLTWH(36, 144, 82, 32),
      Rect.fromLTWH(156, 136, 88, 38),
      Rect.fromLTWH(278, 142, 80, 32),
    ];

    for (final rect in rects) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        blockPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        borderPaint,
      );
    }
  }

  void _drawRoad(
    Canvas canvas,
    Size size,
    Offset start,
    Offset end,
    double width,
  ) {
    final roadBorder = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width + 4
      ..strokeCap = StrokeCap.round;
    final road = Paint()
      ..color = const Color(0xFFF8FAFC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, roadBorder);
    canvas.drawLine(start, end, road);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
