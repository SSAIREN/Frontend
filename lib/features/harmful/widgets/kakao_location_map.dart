import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:ssairen/core/theme/app_colors.dart';

/// 카카오맵으로 보호 대상자 위치를 표시한다.
///
/// `.env`의 `KAKAO_JS_KEY`가 비어 있으면(키 미주입) 지도 대신 안내 플레이스홀더를
/// 보여줘서, 키 없이도 화면이 깨지지 않는다.
class KakaoLocationMap extends StatefulWidget {
  const KakaoLocationMap({
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final double latitude;
  final double longitude;

  @override
  State<KakaoLocationMap> createState() => _KakaoLocationMapState();
}

class _KakaoLocationMapState extends State<KakaoLocationMap> {
  String get _kakaoJsKey => dotenv.env['KAKAO_JS_KEY']?.trim() ?? '';

  @override
  void initState() {
    super.initState();
    if (_kakaoJsKey.isNotEmpty) {
      // baseUrl(WebView origin)을 지정해야 카카오 JS SDK 도메인 검증을 통과한다.
      // 카카오 개발자 콘솔의 Web 플랫폼 사이트 도메인에 동일한 값을 등록해야 함.
      AuthRepository.initialize(
        appKey: _kakaoJsKey,
        baseUrl: 'http://localhost',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_kakaoJsKey.isEmpty) {
      return const _MapKeyMissingPlaceholder();
    }

    final center = LatLng(widget.latitude, widget.longitude);
    return KakaoMap(
      center: center,
      currentLevel: 4,
      markers: [
        Marker(markerId: 'protected-target', latLng: center),
      ],
    );
  }
}

class _MapKeyMissingPlaceholder extends StatelessWidget {
  const _MapKeyMissingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEAF0E6),
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map_outlined, color: AppColors.brandBlue, size: 32),
          SizedBox(height: 8),
          Text(
            '지도를 불러오려면 카카오 키가 필요해요',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
