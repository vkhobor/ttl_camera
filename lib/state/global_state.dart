import 'package:signals/signals_flutter.dart';
import 'package:ttl_camera/state/abstractions/persisted_duration_signal.dart';
import 'package:ttl_camera/persistence/shared_preferences.dart';
import 'package:ttl_camera/state/deletion_method.dart';
import 'package:ttl_camera/state/ttl_check.dart';

import 'abstractions/persisted_signal_base.dart';

class GlobalState {
  final ttl = TTLSignalHolder();
  final deletionMethod = DeletionMethodSignalHolder();
  bool _isInitialized = false;

  Future<void> init() async {
    await ttl.init();
    await deletionMethod.init();
    _isInitialized = true;
  }

  bool get isInitialized => _isInitialized;

  static final GlobalState _instance = GlobalState._internal();
  factory GlobalState() {
    return _instance;
  }
  GlobalState._internal();
}
