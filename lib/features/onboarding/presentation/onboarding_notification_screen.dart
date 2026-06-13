import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/features/onboarding/widgets/onboarding_layout.dart';
import 'package:ssairen/features/onboarding/widgets/permission_card.dart';
import 'package:ssairen/services/fcm_service.dart';
import 'package:ssairen/services/permission_service.dart';

class OnboardingNotificationScreen extends StatefulWidget {
  const OnboardingNotificationScreen({super.key});

  @override
  State<OnboardingNotificationScreen> createState() =>
      _OnboardingNotificationScreenState();
}

class _OnboardingNotificationScreenState
    extends State<OnboardingNotificationScreen> {
  final _fcmService = FcmService();
  bool _isLoading = false;

  Future<void> _enableNotification() async {
    setState(() => _isLoading = true);
    try {
      await const PermissionService().requestNotification();
      final token = await _fcmService.getToken();
      if (token != null) {
        await _fcmService.registerToken(userId: 1001, token: token);
      }
      if (!mounted) return;
      Navigator.of(context).pushNamed(RoutePaths.onboardingFamily);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('알림 설정에 실패했어요. 다시 시도해 주세요.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      currentStep: 3,
      buttonLabel: '알림 허용하기',
      onButtonPressed: _isLoading ? null : _enableNotification,
      child: const PermissionCard(
        icon: Icon(Icons.notifications_active, color: Colors.white, size: 34),
        title: '위험을 바로 알려드릴게요',
        description: '보이스피싱이 감지되면\n가족에게 즉시 알림을 보내요.\n알림을 켜야 보호가 시작돼요.',
        footnote: '알림을 켜야 가족이 위험을 알 수 있어요.',
      ),
    );
  }
}
