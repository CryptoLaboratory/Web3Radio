import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._privateConstructor();
  NetworkService._privateConstructor();

  factory NetworkService() {
    return _instance;
  }

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  late Duration _interval;
  late Function _onNetworkDisconnect;
  late Function _onNetworkReconnect;

  void init({
    required BuildContext context,
    required Function onNetworkDisconnect,
    required Function onNetworkReconnect,
    Duration interval = const Duration(seconds: 5),
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
          _onNetworkDisconnect();
          _isConnected = false;
        } else if (!_isConnected && res != ConnectivityResult.none) {
          _onNetworkReconnect();
          _isConnected = true;
        }
      },
    );
  }
}
