/// 한글 초성 처리 유틸.
abstract final class Hangul {
  static const _choseong = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ',
    'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  /// 쌍자음은 기본 자음으로 합친다 (ㄲ → ㄱ).
  static const _doubleToSingle = {
    'ㄲ': 'ㄱ',
    'ㄸ': 'ㄷ',
    'ㅃ': 'ㅂ',
    'ㅆ': 'ㅅ',
    'ㅉ': 'ㅈ',
  };

  /// 첫 글자의 초성을 돌려준다.
  ///
  /// 한글 음절(가~힣)이 아니면 첫 글자를 대문자로 돌려준다.
  /// 연락처 목록처럼 이름을 ㄱㄴㄷ 순으로 묶을 때 사용한다.
  static String initialOf(String text) {
    final code = text.codeUnitAt(0);
    if (code < 0xAC00 || code > 0xD7A3) return text[0].toUpperCase();
    final choseong = _choseong[(code - 0xAC00) ~/ 588];
    return _doubleToSingle[choseong] ?? choseong;
  }
}
