import 'dart:async';
import 'dart:io';

import 'package:auth_flutter_sdk/auth_flutter_sdk.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CasdoorFlutterSdkDesktop extends CasdoorFlutterSdkPlatform {
  CasdoorFlutterSdkDesktop() : super.create();
  bool isWindowOpen = false;

  /// Registers this class as the default instance of [PathProviderPlatform]
  static void registerWith() {
    CasdoorFlutterSdkPlatform.instance = CasdoorFlutterSdkDesktop();
  }

  Future<String> _getCacheDirWebPath() async {
    final Directory cacheDirRoot = await getApplicationCacheDirectory();
    return p.join(
      cacheDirRoot.path,
      'casdoor',
    );
  }

  @override
  Future<bool> clearCache() async {
    if (isWindowOpen == true) {
      return false;
    }

    final String cacheDirWebPath = await _getCacheDirWebPath();
    final Directory cacheDirWeb = Directory(cacheDirWebPath);
    if (cacheDirWeb.existsSync()) {
      await cacheDirWeb.delete(recursive: true);
    }
    await cacheDirWeb.create();
    return true;
  }

  @override
  Future<String> authenticate(CasdoorSdkParams params) async {
    await WebviewWindow.clearAll(
      userDataFolderWindows: await _getCacheDirWebPath(),
    );
    print('clear complete');
    final bool isWebviewAvailable = await WebviewWindow.isWebviewAvailable();

    if (isWindowOpen == true) {
      throw CasdoorDesktopWebViewAlreadyOpenException;
    }

    if (isWebviewAvailable == true) {
      final Completer<String> isWindowClosed = Completer<String>();

      String? returnUrl;
      // final String cacheDirWebPath = await _getCacheDirWebPath();

      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          windowWidth: 400,
          windowHeight: 640,
          // title: 'Login',
          userDataFolderWindows: await _getCacheDirWebPath(),
          titleBarTopPadding: Platform.isMacOS ? 20 : 0,
          // titleBarHeight: 0,
        ),
      );

      print(params.url);
      webview
        ..setApplicationNameForUserAgent(" WebviewExample/1.0.0")
        ..launch(params.url)
        ..setOnUrlRequestCallback((url) {
          print("setOnUrlRequestCallback before");
          final uri = Uri.parse(url);

          print(uri.scheme);
          print(params.callbackUrlScheme);
          print(url);

          if (url.contains(params.redirectUri)) {
            returnUrl = url;
            webview.close();
            isWindowClosed.complete(returnUrl);
            print("returnUrl");
            print(returnUrl);
          }
          // grant navigation request

          print("setOnUrlRequestCallback after");
          return true;
        })
        // ..openDevToolsWindow()
        ..onClose.whenComplete(() {
          if (returnUrl != null) {
            if (isWindowClosed.isCompleted == false) {
              isWindowClosed.complete(returnUrl);
            }
          } else {
            isWindowClosed.completeError(CasdoorAuthCancelledException);
          }
          isWindowOpen = false;

          print("when complete");
        });

      isWindowOpen = true;

      return isWindowClosed.future;
    } else {
      throw CasdoorDesktopWebViewNotAvailableException;
    }
  }

  @override
  Future<String> getPlatformVersion() async {
    return 'desktop';
  }
}
