import 'package:auth_flutter_sdk/auth_flutter_sdk.dart';
import 'package:auth_flutter_sdk/src/auth_flutter_sdk_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCasdoorFlutterSdkPlatform
    with MockPlatformInterfaceMixin
    implements CasdoorFlutterSdkPlatform {
  @override
  Future<String> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> clearCache() {
    // TODO: implement clearCache
    throw UnimplementedError();
  }

  @override
  Future<String> authenticate(CasdoorSdkParams params) {
    // TODO: implement authenticate
    throw UnimplementedError();
  }
}

void main() {
  final CasdoorFlutterSdkPlatform initialPlatform = CasdoorFlutterSdkPlatform();

  test('$MethodChannelCasdoorFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCasdoorFlutterSdk>());
  });

  test('getPlatformVersion', () async {
    final MockCasdoorFlutterSdkPlatform fakePlatform =
        MockCasdoorFlutterSdkPlatform();
    CasdoorFlutterSdkPlatform.instance = fakePlatform;

    expect(await CasdoorFlutterSdkPlatform().getPlatformVersion(), '42');
  });
}
