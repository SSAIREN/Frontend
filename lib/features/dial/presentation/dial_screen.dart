import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/app_bottom_nav.dart';
import 'package:ssairen/features/dial/widgets/dial_keypad.dart';

class DialScreen extends StatefulWidget {
  const DialScreen({super.key});

  @override
  State<DialScreen> createState() => _DialScreenState();
}

class _DialScreenState extends State<DialScreen> {
  String _number = '';

  void _onKeyPressed(String value) {
    setState(() => _number += value);
  }

  void _onBackspace() {
    setState(() => _number = _number.substring(0, _number.length - 1));
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.search,
                    size: 26,
                    color: AppColors.textHeading,
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.more_vert,
                        size: 26,
                        color: AppColors.textHeading,
                      ),
                      Positioned(
                        top: -2,
                        right: -4,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.alertOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (_number.isEmpty) return;
                    // TODO: 입력 번호 전달은 calling 담당자와 협의 (RouteSettings.arguments)
                    Navigator.of(context).pushNamed(RoutePaths.calling);
                  },
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.brandBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: _number.isEmpty
                      ? const SizedBox.shrink()
                      : Center(
                          child: InkResponse(
                            onTap: _onBackspace,
                            // 길게 누르면 전체 삭제
                            onLongPress: () => setState(() => _number = ''),
                            radius: 28,
                            child: const Icon(
                              Icons.backspace_outlined,
                              size: 26,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                ),
              ],
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
