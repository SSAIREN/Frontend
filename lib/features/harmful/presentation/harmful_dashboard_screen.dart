import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ssairen/core/router/app_router.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/features/harmful/harmful_dashboard_args.dart';
import 'package:ssairen/features/harmful/harmful_response_state.dart';
import 'package:ssairen/features/harmful/widgets/kakao_location_map.dart';

class HarmfulDashboardScreen extends StatefulWidget {
  const HarmfulDashboardScreen({super.key});

  @override
  State<HarmfulDashboardScreen> createState() => _HarmfulDashboardScreenState();
}

class _HarmfulDashboardScreenState extends State<HarmfulDashboardScreen> {
  String _phoneNumber = '01087654321';
  Duration _callElapsed = const Duration(minutes: 2, seconds: 45);
  double _fallbackLatitude = HarmfulDashboardArgs.defaultLat;
  double _fallbackLongitude = HarmfulDashboardArgs.defaultLng;
  bool _initialized = false;
  bool _ownsNotifier = false;
  Timer? _callDurationTimer;
  HarmfulResponseNotifier _responseNotifier =
      HarmfulResponseNotifier(const HarmfulResponseState());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is HarmfulDashboardArgs) {
      _phoneNumber = args.phoneNumber;
      _callElapsed = args.callElapsed;
      _fallbackLatitude = args.latitude;
      _fallbackLongitude = args.longitude;
      _responseNotifier = args.responseNotifier;
    } else {
      _ownsNotifier = true;
    }

    _callDurationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _callElapsed += const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _callDurationTimer?.cancel();
    if (_ownsNotifier) {
      _responseNotifier.dispose();
    }
    super.dispose();
  }

  String get _formattedPhoneNumber {
    final d = _phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.length <= 3) return d.isEmpty ? _phoneNumber : d;
    if (d.length <= 7) return '${d.substring(0, 3)}-${d.substring(3)}';
    return '${d.substring(0, 3)}-${d.substring(3, 7)}-${d.substring(7)}';
  }

  String get _formattedElapsed {
    final m = _callElapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _callElapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: ValueListenableBuilder<HarmfulResponseState>(
          valueListenable: _responseNotifier,
          builder: (context, response, _) {
            final latitude = response.y ?? _fallbackLatitude;
            final longitude = response.x ?? _fallbackLongitude;

            return SingleChildScrollView(
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
                    _DangerCallBanner(
                      phoneNumber: _formattedPhoneNumber,
                      elapsed: _formattedElapsed,
                    ),
                    const SizedBox(height: 28),
                    _FamilyReplyCard(response: response),
                    const SizedBox(height: 24),
                    _LocationCard(
                      latitude: latitude,
                      longitude: longitude,
                      address: response.address,
                      isPending: !response.hasLocation,
                    ),
                    const SizedBox(height: 18),
                    const _PoliceStatusCard(),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        AppRouter.fadeRoute(RoutePaths.harmfulDone),
                      ),
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
            );
          },
        ),
      ),
    );
  }
}

class _DangerCallBanner extends StatelessWidget {
  const _DangerCallBanner({
    required this.phoneNumber,
    required this.elapsed,
  });

  final String phoneNumber;
  final String elapsed;

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
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.dangerRedBright,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              phoneNumber,
              style: const TextStyle(
                color: AppColors.brandBlueDark,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          Text(
            elapsed,
            style: const TextStyle(
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
  const _FamilyReplyCard({required this.response});

  final HarmfulResponseState response;

  @override
  Widget build(BuildContext context) {
    final isPending = !response.hasFamilyMessage;
    final title = isPending ? '아들에게 답장 요청 중' : '아들에게 답장이 왔어요!';
    final subtitle = isPending ? '보호 대상자 상태 확인 중' : '보호 대상자 상태 확인됨';
    final message = response.familyMessage ?? '아들의 답장을 기다리고 있어요';

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
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        _StatusIndicator(isPending: isPending),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
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
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble,
                  color: isPending ? AppColors.textMuted : AppColors.brandBlue,
                  size: 21,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isPending
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
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
  const _LocationCard({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isPending,
  });

  final double latitude;
  final double longitude;
  final String? address;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPending)
            const _PendingMapPreview()
          else
            _MapPreview(latitude: latitude, longitude: longitude),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: isPending ? AppColors.textMuted : AppColors.brandBlue,
                  size: 23,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPending ? '위치 확인 중' : (address ?? '현재 위치 확인됨'),
                        style: const TextStyle(
                          color: AppColors.brandBlueDark,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isPending
                            ? '보호 대상자 GPS 응답 대기'
                            : '현재 보호 대상자 위치',
                        style: const TextStyle(
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
                  child: Text(
                    isPending ? 'PENDING' : 'REAL-TIME GPS',
                    style: const TextStyle(
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
    // 시연용: 경찰 대응을 항상 완료 상태로 표시한다.
    const isPending = false;
    const status = '경찰 대응 완료';
    const detail = '긴급 상황이 경찰에 공유되었어요';

    return _DashboardCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5FF),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/widget_logo_blue.png',
              width: 27,
              height: 27,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  detail,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _StatusIndicator(isPending: isPending),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.isPending});

  final bool isPending;

  @override
  Widget build(BuildContext context) {
    if (isPending) {
      return const SizedBox(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(strokeWidth: 2.4),
      );
    }

    return Container(
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
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184,
      child: Stack(
        children: [
          Positioned.fill(
            child: KakaoLocationMap(
              latitude: latitude,
              longitude: longitude,
            ),
          ),
          const Positioned(
            left: 16,
            bottom: 12,
            child: _MapBadge(label: 'REAL-TIME GPS'),
          ),
        ],
      ),
    );
  }
}

class _PendingMapPreview extends StatelessWidget {
  const _PendingMapPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 184,
      color: const Color(0xFFF1F5F9),
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(height: 12),
          Text(
            '위치 정보를 기다리고 있어요',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapBadge extends StatelessWidget {
  const _MapBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.brandBlue,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
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
