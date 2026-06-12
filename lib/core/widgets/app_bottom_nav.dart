import 'package:flutter/material.dart';
import 'package:ssairen/core/router/app_router.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

enum MainTab {
  dial(icon: Icons.apps, label: '키패드', path: RoutePaths.dial),
  recents(icon: Icons.schedule, label: '최근기록', path: RoutePaths.recents),
  contacts(icon: Icons.person, label: '연락처', path: RoutePaths.contacts),
  home(
    label: '싸이렌',
    path: RoutePaths.home,
    selectedAsset: 'assets/widget_logo_blue.png',
    unselectedAsset: 'assets/widget_logo_gray.png',
  );

  const MainTab({
    required this.label,
    required this.path,
    this.icon,
    this.selectedAsset,
    this.unselectedAsset,
  });

  /// 머티리얼 아이콘 탭이면 [icon], 이미지 로고 탭이면 asset 경로를 사용.
  final IconData? icon;
  final String? selectedAsset;
  final String? unselectedAsset;
  final String label;
  final String path;
}

/// 와이어프레임의 플로팅 알약형 하단 바.
///
/// 바 양옆으로 페이지 내용이 보여야 하므로, 이 위젯을 쓰는 Scaffold는
/// `extendBody: true`로 설정하고 본문 스크롤 하단에 여백을 둬야 합니다.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentTab,
    super.key,
  });

  final MainTab currentTab;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        64,
      ),
      child: Container(
        height: 58,
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(29),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            for (final tab in MainTab.values)
              Expanded(
                child: _NavItem(
                  tab: tab,
                  isSelected: tab == currentTab,
                  onTap: () {
                    if (tab != currentTab) {
                      Navigator.of(context)
                          .pushReplacement(AppRouter.fadeRoute(tab.path));
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final MainTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.brandBlue : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.navSelectedPill,
                borderRadius: BorderRadius.circular(25),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.icon != null)
              Icon(tab.icon, size: 24, color: color)
            else
              Image.asset(
                isSelected ? tab.selectedAsset! : tab.unselectedAsset!,
                width: 24,
                height: 24,
              ),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
