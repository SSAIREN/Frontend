import 'package:flutter/material.dart';
import 'package:ssairen/core/router/app_router.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_theme.dart';
import 'package:ssairen/services/fcm_service.dart';

class SsairenApp extends StatefulWidget {
  const SsairenApp({super.key});

  @override
  State<SsairenApp> createState() => _SsairenAppState();
}

class _SsairenAppState extends State<SsairenApp> {
  final _fcmService = FcmService();

  @override
  void initState() {
    super.initState();
    // 포그라운드 수신 / 알림 탭 구독
    _fcmService.listenForAlerts(AppRouter.navigatorKey);
    // 종료 상태에서 알림 탭으로 실행된 경우 처리
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fcmService.handleLaunchMessage(AppRouter.navigatorKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSAIREN',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRouter.navigatorKey,
      theme: AppTheme.light,
      initialRoute: RoutePaths.splash,
      routes: AppRouter.routes,
    );
  }
}
