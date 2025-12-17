import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

/// Service to monitor network connectivity status
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _logger = Logger();

  StreamController<bool>? _connectivityController;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Stream of connectivity status (true = online, false = offline)
  Stream<bool> get connectivityStream {
    _connectivityController ??= StreamController<bool>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
    return _connectivityController!.stream;
  }

  /// Check current connectivity status
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _isConnected(results);
    } catch (e) {
      _logger.e('Error checking connectivity: $e');
      return false;
    }
  }

  /// Start listening to connectivity changes
  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final isOnline = _isConnected(results);
        _logger.d('Connectivity changed: $isOnline');
        _connectivityController?.add(isOnline);
      },
      onError: (error) {
        _logger.e('Connectivity stream error: $error');
        _connectivityController?.add(false);
      },
    );

    // Add initial status
    _connectivity.checkConnectivity().then((results) {
      final isOnline = _isConnected(results);
      _connectivityController?.add(isOnline);
    });
  }

  /// Stop listening to connectivity changes
  void _stopListening() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Check if connected based on connectivity results
  bool _isConnected(List<ConnectivityResult> results) {
    // Consider connected if any result is not 'none'
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Dispose resources
  void dispose() {
    _stopListening();
    _connectivityController?.close();
    _connectivityController = null;
  }
}
