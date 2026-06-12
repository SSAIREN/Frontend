import 'package:flutter/material.dart';
import 'package:ssairen/core/router/app_router.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_theme.dart';

class SsairenApp extends StatelessWidget {
  const SsairenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSAIREN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: RoutePaths.calling,
      routes: AppRouter.routes,
    );
  }
}
