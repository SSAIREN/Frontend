import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssairen/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('홈 화면 주요 섹션이 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('싸이렌'), findsWidgets);
    expect(find.text('보호 중'), findsOneWidget);
    expect(find.text('이번 주 리포트'), findsOneWidget);
    expect(find.text('0건'), findsOneWidget);
    expect(find.text('의심 전화 없음'), findsOneWidget);
    expect(find.text('실시간 검사'), findsOneWidget);
    expect(find.text('DB 업데이트'), findsOneWidget);
    expect(find.text('내 보호자'), findsOneWidget);
    expect(find.text('아들 (김철수)'), findsOneWidget);
    expect(find.text('딸 (김영희)'), findsOneWidget);
  });
}
