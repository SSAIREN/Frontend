import 'package:flutter/material.dart';
import 'package:ssairen/core/router/app_router.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/glowing_check.dart';
import 'package:ssairen/core/widgets/primary_button.dart';
import 'package:ssairen/features/result/widgets/receipt_step_tile.dart';

class ReceiptDoneScreen extends StatelessWidget {
  const ReceiptDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 화면이 작으면 스크롤되고, 충분하면 Spacer가 여백을 채우는 구조
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - AppSpacing.screenPadding * 2,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),
                    const Center(child: GlowingCheck()),
                    const SizedBox(height: 40),
                    const Text(
                      '접수됐습니다',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      '신고해 주셔서 감사해요.\n덕분에 다른 분들을 보호할 수 있어요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(flex: 2),
                    const ReceiptStepTile(label: '통화 내용 익명 처리 완료'),
                    const SizedBox(height: AppSpacing.md),
                    const ReceiptStepTile(label: '경찰청 보이스피싱 센터 전송 완료'),
                    const SizedBox(height: AppSpacing.md),
                    const ReceiptStepTile(
                      label: '통화 기록 저장됨',
                      highlighted: true,
                    ),
                    const Spacer(flex: 3),
                    PrimaryButton(
                      label: '확인',
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacement(AppRouter.fadeRoute(RoutePaths.home));
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
