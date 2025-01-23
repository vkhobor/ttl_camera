import 'package:signals/signals.dart';
import 'package:ttl_camera/persistence/shared_preferences.dart';
import 'package:ttl_camera/state/abstractions/persisted_duration_signal.dart';

class TTLSignalHolder {
  final _ttlSignal = PersistedDurationSignal(
    value: ttlOptions[0],
    key: 'ttl_preference_v1',
    store: SharedPreferencesStore(),
  );
  late final ReadonlySignal<Duration> ttlSignal = _ttlSignal.readonly();

  void nextTtlOption() {
    final currentIndex = ttlOptions.indexOf(_ttlSignal.value);
    final nextIndex = (currentIndex + 1) % ttlOptions.length;
    _ttlSignal.value = ttlOptions[nextIndex];
  }

  Future<void> init() async {
    await _ttlSignal.init();
  }
}

const ttlCheckInterval = Duration(seconds: 30);
const ttlOptions = [
  Duration(minutes: 1),
  Duration(minutes: 10),
  Duration(hours: 1),
  Duration(hours: 12),
  Duration(hours: 24),
  Duration(days: 3),
  Duration(days: 7),
];
