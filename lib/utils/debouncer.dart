import 'dart:async';
import 'package:flutter/foundation.dart';

/*
 * Handle multiple fire search
*/
class Debouncer {
  final int milliseconds = 450;
  VoidCallback action;
  Timer _timer;

  // Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
