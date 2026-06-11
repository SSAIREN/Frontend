import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/features/calling/presentation/calling_screen.dart';
import 'package:ssairen/features/contacts/presentation/contacts_screen.dart';
import 'package:ssairen/features/dial/presentation/dial_screen.dart';
import 'package:ssairen/features/harmful/presentation/harmful_dashboard_screen.dart';
import 'package:ssairen/features/harmful/presentation/harmful_done_screen.dart';
import 'package:ssairen/features/home/presentation/home_screen.dart';
import 'package:ssairen/features/onboarding/presentation/onboarding_contacts_screen.dart';
import 'package:ssairen/features/onboarding/presentation/onboarding_done_screen.dart';
import 'package:ssairen/features/onboarding/presentation/onboarding_family_screen.dart';
import 'package:ssairen/features/onboarding/presentation/onboarding_location_screen.dart';
import 'package:ssairen/features/onboarding/presentation/onboarding_mic_screen.dart';
import 'package:ssairen/features/recents/presentation/recents_screen.dart';
import 'package:ssairen/features/result/presentation/police_share_screen.dart';
import 'package:ssairen/features/result/presentation/receipt_done_screen.dart';
import 'package:ssairen/features/splash/presentation/splash_screen.dart';

abstract final class AppRouter {
  static Map<String, WidgetBuilder> get routes {
    return {
      RoutePaths.splash: (_) => const SplashScreen(),
      RoutePaths.onboardingMic: (_) => const OnboardingMicScreen(),
      RoutePaths.onboardingContacts: (_) => const OnboardingContactsScreen(),
      RoutePaths.onboardingFamily: (_) => const OnboardingFamilyScreen(),
      RoutePaths.onboardingLocation: (_) => const OnboardingLocationScreen(),
      RoutePaths.onboardingDone: (_) => const OnboardingDoneScreen(),
      RoutePaths.home: (_) => const HomeScreen(),
      RoutePaths.recents: (_) => const RecentsScreen(),
      RoutePaths.contacts: (_) => const ContactsScreen(),
      RoutePaths.dial: (_) => const DialScreen(),
      RoutePaths.calling: (_) => const CallingScreen(),
      RoutePaths.policeShare: (_) => const PoliceShareScreen(),
      RoutePaths.receiptDone: (_) => const ReceiptDoneScreen(),
      RoutePaths.harmfulDashboard: (_) => const HarmfulDashboardScreen(),
      RoutePaths.harmfulDone: (_) => const HarmfulDoneScreen(),
    };
  }
}
