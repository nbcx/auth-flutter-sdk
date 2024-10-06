import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';

import 'package:auth_flutter_sdk/auth_flutter_sdk.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class CasdoorFlutterSdkWeb extends CasdoorFlutterSdkPlatform {
  CasdoorFlutterSdkWeb() : super.create();

  static void registerWith(Registrar registrar) {
    CasdoorFlutterSdkPlatform.instance = CasdoorFlutterSdkWeb();
  }

  @override
  Future<String> authenticate(CasdoorSdkParams params) async {
    context.callMethod('open', [params.url]);
    await for (MessageEvent messageEvent in window.onMessage) {
      if (messageEvent.origin == Uri.base.origin) {
        final flutterWebAuthMessage = messageEvent.data['casdoor-auth'];
        if (flutterWebAuthMessage is String) {
          return flutterWebAuthMessage;
        }
      }
      final appleOrigin = Uri(scheme: 'https', host: 'appleid.apple.com');
      if (messageEvent.origin == appleOrigin.toString()) {
        try {
          final Map<String, dynamic> data =
              jsonDecode(messageEvent.data as String) as Map<String, dynamic>;
          if (data['method'] == 'oauthDone') {
            final appleAuth = data['data']['authorization'];
            if (appleAuth != null) {
              final appleAuthQuery =
                  Uri(queryParameters: appleAuth as Map<String, dynamic>?)
                      .query;
              return appleOrigin.replace(fragment: appleAuthQuery).toString();
            }
          }
        } on FormatException {}
      }
    }
    throw PlatformException(
        code: 'error', message: 'Iterable window.onMessage is empty');
  }

  @override
  Future<String> getPlatformVersion() async {
    return 'web';
  }
}
