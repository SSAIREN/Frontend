import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/features/onboarding/widgets/onboarding_layout.dart';
import 'package:ssairen/features/onboarding/widgets/permission_card.dart';

class OnboardingMicScreen extends StatelessWidget {
  const OnboardingMicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      currentStep: 1,
      buttonLabel: '마이크 허용하기',
      onButtonPressed: () =>
          Navigator.of(context).pushNamed(RoutePaths.onboardingContacts),
      child: PermissionCard(
        icon: SvgPicture.asset(
          'assets/onboarding/mic_screen.svg',
          width: 28,
        ),
        title: '통화 내용을 분석할게요',
        description: '보이스피싱을 탐지하는 동안\n음성은 실시간으로만 분석되고\n기기 밖으로 저장되지 않아요.',
        footnote: '실시간 보이스피싱 탐지를 위해 권한이 필요해요.',
      ),
    );
  }
}
