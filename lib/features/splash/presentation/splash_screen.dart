import 'package:flutter/material.dart';
import 'package:ssairen/core/router/app_router.dart';
import 'package:ssairen/core/router/route_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: 실제 스플래시 로직(권한 체크, 로그인 여부 등) 구현 후 제거
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .pushReplacement(AppRouter.fadeRoute(RoutePaths.home));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
