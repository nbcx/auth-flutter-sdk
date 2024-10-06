import 'dart:async';

import 'package:auth_flutter_sdk/auth_flutter_sdk.dart';

class CasdoorOauth {
  Future<String?> getPlatformVersion() {
    return CasdoorFlutterSdkPlatform().getPlatformVersion();
  }

  static Future<String> authenticate(CasdoorSdkParams params) async {
    try {
      return CasdoorFlutterSdkPlatform().authenticate(params);
    } catch (_) {
      rethrow;
    }
  }

  static Future<bool> clearCache() async {
    try {
      return CasdoorFlutterSdkPlatform().clearCache();
    } catch (_) {
      rethrow;
    }
  }
}
