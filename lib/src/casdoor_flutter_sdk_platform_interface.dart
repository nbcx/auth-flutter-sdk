import 'package:auth_flutter_sdk/auth_flutter_sdk.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'casdoor_flutter_sdk_method_channel.dart';

abstract class CasdoorFlutterSdkPlatform extends PlatformInterface {
  // Returns singleton instance.
  factory CasdoorFlutterSdkPlatform() => _instance;

  CasdoorFlutterSdkPlatform.create() : super(token: _token);

  static CasdoorFlutterSdkPlatform _instance = MethodChannelCasdoorFlutterSdk();

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CasdoorFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(CasdoorFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  static final Object _token = Object();

  Future<String> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> clearCache() {
    throw UnimplementedError('clearCache() has not been implemented.');
  }

  Future<String> authenticate(CasdoorSdkParams params) {
    throw UnimplementedError('authenticate() has not been implemented.');
  }
}
