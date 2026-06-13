import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/features/onboarding/onboarding_permission_handler.dart';
import 'package:ssairen/features/onboarding/widgets/onboarding_layout.dart';
import 'package:ssairen/features/onboarding/widgets/permission_card.dart';

class OnboardingContactsScreen extends StatelessWidget {
  const OnboardingContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      currentStep: 2,
      buttonLabel: '연락처 허용하기',
      onButtonPressed: () => requestPermissionAndContinue(
        context: context,
        request: (service) => service.requestContacts(),
        nextRoute: RoutePaths.onboardingNotification,
        settingsMessage: '위험 전화 감지 시 가족에게 알리기 위해 연락처 권한이 필요해요. 설정에서 허용해주세요.',
      ),
      child: PermissionCard(
        icon: SvgPicture.asset(
          'assets/onboarding/contacts_screen.svg',
          width: 34,
        ),
        title: '소중한 가족을 연결할게요',
        description: '위험한 전화가 감지되면\n가족에게 즉시 알림을 보내요.\n연락처는 외부로 전송되지 않아요.',
        footnote: '가족 정보는 기기에만 저장돼요.',
      ),
    );
  }
}
