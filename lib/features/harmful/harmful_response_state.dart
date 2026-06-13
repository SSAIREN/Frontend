import 'package:flutter/foundation.dart';

class HarmfulResponseState {
  const HarmfulResponseState({
    this.familyMessage,
    this.x,
    this.y,
    this.address,
    this.policeStatus,
    this.policeDetail,
  });

  final String? familyMessage;
  final double? x;
  final double? y;
  final String? address;
  final String? policeStatus;
  final String? policeDetail;

  bool get hasFamilyMessage => _hasText(familyMessage);
  bool get hasLocation => x != null && y != null;
  bool get hasPoliceStatus => _hasText(policeStatus) || _hasText(policeDetail);

  HarmfulResponseState copyWith({
    String? familyMessage,
    double? x,
    double? y,
    String? address,
    String? policeStatus,
    String? policeDetail,
  }) {
    return HarmfulResponseState(
      familyMessage: familyMessage ?? this.familyMessage,
      x: x ?? this.x,
      y: y ?? this.y,
      address: address ?? this.address,
      policeStatus: policeStatus ?? this.policeStatus,
      policeDetail: policeDetail ?? this.policeDetail,
    );
  }

  factory HarmfulResponseState.fromSocketData(Map<String, dynamic> data) {
    return HarmfulResponseState(
      familyMessage: _readString(data['familyMessage']) ??
          _readString(data['message']) ??
          _readString(data['sonMessage']),
      x: _readDouble(data['x']) ??
          _readDouble(data['longitude']) ??
          _readDouble(data['lng']),
      y: _readDouble(data['y']) ??
          _readDouble(data['latitude']) ??
          _readDouble(data['lat']),
      address: _readString(data['address']),
      policeStatus: _readString(data['policeStatus']),
      policeDetail: _readString(data['policeDetail']),
    );
  }

  static bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

  static String? _readString(Object? value) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return null;
  }

  static double? _readDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }
}

class HarmfulResponseNotifier extends ValueNotifier<HarmfulResponseState> {
  HarmfulResponseNotifier(super.value);
}
