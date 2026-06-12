import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

/// 내용이 화면보다 작으면 Spacer가 남는 공간을 채우고,
/// 화면보다 크면 스크롤되는 세로 레이아웃.
///
/// 완료/결과 화면처럼 Spacer로 여백을 배분하면서도
/// 작은 기기에서 오버플로우가 나면 안 되는 화면에 쓴다.
class StretchScrollColumn extends StatelessWidget {
  const StretchScrollColumn({
    required this.children,
    this.padding = const EdgeInsets.all(AppSpacing.screenPadding),
    super.key,
  });

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight - padding.vertical,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
