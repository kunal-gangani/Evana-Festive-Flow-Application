import 'dart:async';

import 'package:flutter/foundation.dart';

class SplashViewModel extends ChangeNotifier {
  Timer? _navigationTimer;
  Object? _error;

  Object? get error => _error;

  void start({
    required VoidCallback onNavigate,
    Duration delay = const Duration(seconds: 3),
  }) {
    _navigationTimer?.cancel();
    _error = null;

    try {
      _navigationTimer = Timer(delay, onNavigate);
    } catch (error) {
      _error = error;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }
}
