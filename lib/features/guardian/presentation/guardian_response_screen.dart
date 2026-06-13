import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/primary_button.dart';
import 'package:ssairen/features/guardian/guardian_response_args.dart';
import 'package:ssairen/services/guardian_response_service.dart';

// TODO: 로그인 구현 후 저장된 사용자 ID로 교체한다.
const _guardianId = 2001;

// 시연용 하드코딩 위치: 카카오 AI 캠퍼스
// TODO: 정확한 위경도 확인 후 교체. 실제 GPS로 되돌리려면 LocationService 사용.
const _demoLatitude = 37.351684;
const _demoLongitude = 127.071856;

class GuardianResponseScreen extends StatefulWidget {
  const GuardianResponseScreen({super.key});

  @override
  State<GuardianResponseScreen> createState() => _GuardianResponseScreenState();
}

class _GuardianResponseScreenState extends State<GuardianResponseScreen> {
  final _messageController = TextEditingController();
  final _service = GuardianResponseService();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('보낼 메시지를 입력해 주세요')),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      await _service.sendResponse(
        guardianId: _guardianId,
        latitude: _demoLatitude,
        longitude: _demoLongitude,
        message: message,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내 위치와 메시지를 전송했어요')),
      );
      Navigator.of(context).maybePop();
    } on DioException catch (e) {
      debugPrint('[GuardianResponse] API 실패: ${e.type} '
          '${e.response?.statusCode} ${e.message} ${e.response?.data}');
      if (!mounted) return;
      _showError('서버 전송 실패: ${e.response?.statusCode ?? e.type.name}');
    } catch (e) {
      debugPrint('[GuardianResponse] 알 수 없는 실패: $e');
      if (!mounted) return;
      _showError('전송에 실패했어요. 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final title = args is GuardianResponseArgs && args.title != null
        ? args.title!
        : '가족이 위험한 전화를 받고 있어요';
    final body = args is GuardianResponseArgs && args.body != null
        ? args.body!
        : '지금 안전한지 가족에게 알려주세요.\n내 위치와 함께 메시지가 전달돼요.';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.xxl),
              const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.dangerRedBright,
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandBlueDark,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                body,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandBlueStrong,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                controller: _messageController,
                maxLines: 4,
                minLines: 3,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: '예) 저 안전해요, 그 전화 끊으세요',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
                      const Spacer(),
                      PrimaryButton(
                        label:
                            _isSending ? '전송 중...' : '내 위치와 함께 응답 보내기',
                        icon: Icons.send,
                        onPressed: _isSending ? null : _send,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
