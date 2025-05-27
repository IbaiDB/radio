import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkMonitor {
  final Connectivity _connectivity = Connectivity();
  Stream<ConnectivityResult> get connectivityStream => _connectivity.onConnectivityChanged;

  Future<bool> get hasConnection async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}