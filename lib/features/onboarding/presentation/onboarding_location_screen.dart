import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/features/onboarding/onboarding_permission_handler.dart';
import 'package:ssairen/features/onboarding/widgets/onboarding_layout.dart';
import 'package:ssairen/features/onboarding/widgets/permission_card.dart';

class OnboardingLocationScreen extends StatelessWidget {
  const OnboardingLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      currentStep: 5,
      buttonLabel: '위치 허용하기',
      onButtonPressed: () => requestPermissionAndContinue(
        context: context,
        request: (service) => service.requestLocation(),
        nextRoute: RoutePaths.onboardingDone,
        settingsMessage: '위급 상황 시 위치 공유를 위해 위치 권한이 필요해요. 설정에서 허용해주세요.',
      ),
      child: const PermissionCard(
        icon: Icon(Icons.location_on, color: Colors.white, size: 34),
        title: '위급 상황시 위치를 공유해요.',
        description: '위험 상황이 감지되면\n가족,경찰에게 현재 위치를 공유해요.\n평상시엔 위치를 수집하지 않아요.',
        footnote: '위험 상황에서만 위치가 공유돼요.',
      ),
    );
  }
}
