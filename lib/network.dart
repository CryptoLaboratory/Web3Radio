library network_status;

import 'dart:async';

import 'package:connectivity/connectivity.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._privateConstructor();
  NetworkService._privateConstructor();

  factory NetworkService() {
    return _instance;
  }

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  Duration _interval = const Duration(seconds: 3);
  Function? _onNetworkDisconnect;
  Function? _onNetworkReconnect;

  void init({
    required Function onNetworkDisconnect,
    required Function onNetworkReconnect,
    Duration interval = const Duration(seconds: 3),
  }) {
    _interval = interval;
    _onNetworkDisconnect = onNetworkDisconnect;
    _onNetworkReconnect = onNetworkReconnect;
  }

  void startConnectionService() {
    Timer.periodic(
      _interval,
      (Timer t) async {
        ConnectivityResult res = await Connectivity().checkConnectivity();

        if (_isConnected && res == ConnectivityResult.none) {
          if(_onNetworkDisconnect != null) {
            _onNetworkDisconnect!();
          }
          _isConnected = false;
        } else if (!_isConnected && res != ConnectivityResult.none) {
          if(_onNetworkReconnect != null) {
            _onNetworkReconnect!();
          }
          _isConnected = true;
        }
      },
    );
  }
}
