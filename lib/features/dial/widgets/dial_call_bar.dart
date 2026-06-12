import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';

/// 키패드 아래의 통화 버튼 + 백스페이스 버튼 줄.
///
/// 통화 버튼은 항상 정중앙에 고정되고, 백스페이스는 번호가 입력된 경우에만
/// 우측(# 키 열 위치)에 나타난다.
class DialCallBar extends StatelessWidget {
  const DialCallBar({
    required this.showBackspace,
    required this.onCall,
    required this.onBackspace,
    required this.onClearAll,
    super.key,
  });

  final bool showBackspace;
  final VoidCallback onCall;
  final VoidCallback onBackspace;

  /// 백스페이스 길게 누르기 — 전체 삭제.
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: onCall,
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
          child: !showBackspace
              ? const SizedBox.shrink()
              : Center(
                  child: InkResponse(
                    onTap: onBackspace,
                    onLongPress: onClearAll,
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
    );
  }
}
