import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ssairen/services/permission_service.dart';

/// 온보딩에서 권한을 요청하고 결과에 따라 다음 화면으로 이동한다.
///
/// 허용/거부 모두 [nextRoute]로 진행한다. 권한은 실제 기능 사용 시점에
/// 다시 확인하므로 온보딩 흐름 자체는 막지 않는다. 다만 영구 거부 상태에서는
/// 인앱 재요청이 불가능하므로 앱 설정으로 안내하는 다이얼로그를 먼저 띄운다.
Future<void> requestPermissionAndContinue({
  required BuildContext context,
  required Future<PermissionStatus> Function(PermissionService) request,
  required String nextRoute,
  required String settingsMessage,
}) async {
  final navigator = Navigator.of(context);
  const service = PermissionService();

  final status = await request(service);
  if (!navigator.mounted) return;

  if (status.isPermanentlyDenied) {
    final goSettings = await showDialog<bool>(
      context: navigator.context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('권한이 꺼져 있어요'),
        content: Text(settingsMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('나중에'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('설정 열기'),
          ),
        ],
      ),
    );
    if (goSettings ?? false) {
      await service.openSettings();
    }
  }

  navigator.pushNamed(nextRoute);
}
