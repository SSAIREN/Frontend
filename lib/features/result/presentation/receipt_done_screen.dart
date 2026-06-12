import 'package:flutter/material.dart';
import 'package:ssairen/core/router/app_router.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/glowing_check.dart';
import 'package:ssairen/core/widgets/primary_button.dart';
import 'package:ssairen/core/widgets/screen_headline.dart';
import 'package:ssairen/core/widgets/stretch_scroll_column.dart';
import 'package:ssairen/features/result/widgets/receipt_step_tile.dart';

class ReceiptDoneScreen extends StatelessWidget {
  const ReceiptDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StretchScrollColumn(
          children: [
            const Spacer(flex: 2),
            const Center(child: GlowingCheck()),
            const SizedBox(height: 40),
            const ScreenHeadline(
              title: '접수됐습니다',
              subtitle: '신고해 주셔서 감사해요.\n덕분에 다른 분들을 보호할 수 있어요.',
            ),
            const Spacer(flex: 2),
            const ReceiptStepTile(label: '통화 내용 익명 처리 완료'),
            const SizedBox(height: AppSpacing.md),
            const ReceiptStepTile(label: '경찰청 보이스피싱 센터 전송 완료'),
            const SizedBox(height: AppSpacing.md),
            const ReceiptStepTile(label: '통화 기록 저장됨'),
            const Spacer(flex: 3),
            PrimaryButton(
              label: '확인',
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(AppRouter.fadeRoute(RoutePaths.home));
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
