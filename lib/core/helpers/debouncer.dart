import 'dart:async';
import 'dart:ui';

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) cancel();
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }

  void cancel() {
    _timer?.cancel();
  }
}
