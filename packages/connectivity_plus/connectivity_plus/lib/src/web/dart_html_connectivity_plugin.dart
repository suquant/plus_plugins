import 'dart:async';
import 'dart:html' as html show window;

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

import '../connectivity_plus_web.dart';

/// The web implementation of the ConnectivityPlatform of the Connectivity plugin.
class DartHtmlConnectivityPlugin extends ConnectivityPlusWebPlugin {
  /// Checks the connection status of the device.
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return (html.window.navigator.onLine ?? false)
        ? [ConnectivityResult.wifi]
        : [ConnectivityResult.none];
  }

  StreamController<List<ConnectivityResult>>? _connectivityResult;

  /// Returns a Stream of ConnectivityResults changes.
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    if (_connectivityResult == null) {
      _connectivityResult =
          StreamController<List<ConnectivityResult>>.broadcast();
      // Fallback to dart:html window.onOnline / window.onOffline
      html.window.onOnline.listen((event) {
        _connectivityResult!.add([ConnectivityResult.wifi]);
      });
      html.window.onOffline.listen((event) {
        _connectivityResult!.add([ConnectivityResult.none]);
      });
    }
    return _connectivityResult!.stream;
  }
}
