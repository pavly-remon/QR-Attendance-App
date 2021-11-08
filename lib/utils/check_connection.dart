import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

Future<bool> checkConnection() async {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult result = ConnectivityResult.none;
  try {
    result = await _connectivity.checkConnectivity();
    if (result != ConnectivityResult.none) {
      print('connected');
      return true;
    } else {
      return false;
    }
  } on PlatformException catch (_) {
    return false;
  }
}
