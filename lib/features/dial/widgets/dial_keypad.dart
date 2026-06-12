import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';

/// 갤럭시 다이얼러와 동일한 3×4 키패드.
class DialKeypad extends StatelessWidget {
  const DialKeypad({
    required this.onKeyPressed,
    super.key,
  });

  final ValueChanged<String> onKeyPressed;

  /// (키 값, 한글 보조 라벨, 영문 보조 라벨)
  static const _keys = [
    ('1', '', ''),
    ('2', '', 'ABC'),
    ('3', '', 'DEF'),
    ('4', 'ㄱㅋ', 'GHI'),
    ('5', 'ㄴㄹ', 'JKL'),
    ('6', 'ㄷㅌ', 'MNO'),
    ('7', 'ㅂㅍ', 'PQRS'),
    ('8', 'ㅅㅎ', 'TUV'),
    ('9', 'ㅈㅊ', 'WXYZ'),
    ('*', '', ''),
    ('0', 'ㅇㅁ', ''),
    ('#', '', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var row = 0; row < 4; row++)
            Row(
              children: [
                for (var col = 0; col < 3; col++)
                  Expanded(
                    child: _DialKey(
                      value: _keys[row * 3 + col].$1,
                      subKorean: _keys[row * 3 + col].$2,
                      subLatin: _keys[row * 3 + col].$3,
                      onTap: onKeyPressed,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DialKey extends StatelessWidget {
  const _DialKey({
    required this.value,
    required this.subKorean,
    required this.subLatin,
    required this.onTap,
  });

  final String value;
  final String subKorean;
  final String subLatin;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => onTap(value),
      radius: 38,
      child: SizedBox(
        height: 82,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 1.1,
              ),
            ),
            if (subKorean.isNotEmpty)
              Text(
                subKorean,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textMuted,
                  height: 1.2,
                ),
              ),
            if (subLatin.isNotEmpty)
              Text(
                subLatin,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                  height: 1.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
