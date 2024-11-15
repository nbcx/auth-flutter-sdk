import 'package:auth_flutter_sdk/auth_flutter_sdk.dart';
import 'package:flutter/services.dart';

/// An implementation of [CasdoorFlutterSdkPlatform] that uses method channels.
class MethodChannelCasdoorFlutterSdk extends CasdoorFlutterSdkPlatform {
  MethodChannelCasdoorFlutterSdk() : super.create();

  static const MethodChannel _channel = MethodChannel('casdoor_flutter_sdk');

  @override
  Future<bool> clearCache() async {
    return await _channel
            .invokeMethod<bool>('clearCache')
            .catchError((err) => throw (Exception(err))) ??
        false;
  }

  @override
  Future<String> authenticate(CasdoorSdkParams params) async {
    return await _channel
            .invokeMethod<String>('authenticate', <String, dynamic>{
          'params': params,
        }).catchError((err) => throw (Exception(err))) ??
        '';
  }

  @override
  Future<String> getPlatformVersion() async {
    final version =
        await _channel.invokeMethod<String>('getPlatformVersion') ?? '';
    return version;
  }
}
