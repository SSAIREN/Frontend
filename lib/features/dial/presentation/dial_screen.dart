import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/app_bottom_nav.dart';
import 'package:ssairen/core/widgets/screen_action_icons.dart';
import 'package:ssairen/features/dial/widgets/dial_call_bar.dart';
import 'package:ssairen/features/dial/widgets/dial_keypad.dart';

class DialScreen extends StatefulWidget {
  const DialScreen({super.key});

  @override
  State<DialScreen> createState() => _DialScreenState();
}

class _DialScreenState extends State<DialScreen> {
  String _digits = '';

  String get _number {
    final d = _digits;
    if (d.length <= 3) return d;
    if (d.length <= 7) return '${d.substring(0, 3)}-${d.substring(3)}';
    return '${d.substring(0, 3)}-${d.substring(3, 7)}-${d.substring(7)}';
  }

  void _onKeyPressed(String value) {
    if (_digits.length >= 11) return;
    setState(() => _digits += value);
  }

  void _onBackspace() {
    if (_digits.isEmpty) return;
    setState(() => _digits = _digits.substring(0, _digits.length - 1));
  }

  void _onCall() {
    if (_digits.isEmpty) return;
    // TODO: 입력 번호 전달은 calling 담당자와 협의 (RouteSettings.arguments)
    Navigator.of(context).pushNamed(RoutePaths.calling);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 플로팅 하단 바 양옆으로 본문이 보이도록 확장
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.md,
                AppSpacing.screenPadding,
                0,
              ),
              child: const ScreenActionIcons(),
            ),
            Expanded(
              child: Center(
                child: Text(
                  _number,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    letterSpacing: 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            DialKeypad(onKeyPressed: _onKeyPressed),
            const SizedBox(height: AppSpacing.md),
            DialCallBar(
              showBackspace: _number.isNotEmpty,
              onCall: _onCall,
              onBackspace: _onBackspace,
              onClearAll: () => setState(() => _digits = ''),
            ),
            // 플로팅 하단 바(58 + 여백)에 가리지 않도록 확보
            const SizedBox(height: 150),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentTab: MainTab.dial),
    );
  }
}
