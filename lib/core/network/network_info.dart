import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Contract for checking the device's internet connection status.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Simple and robust implementation of [NetworkInfo].
/// Requires 'internet_connection_checker' package.
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
