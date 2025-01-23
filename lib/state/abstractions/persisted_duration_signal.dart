import 'persisted_signal_base.dart';
import 'package:ttl_camera/persistence/key_value_store.dart';

class PersistedDurationSignal extends PersistedSignal<Duration> {
  PersistedDurationSignal({
    required Duration value,
    bool autoDispose = true,
    String? debugLabel,
    required String key,
    required KeyValueStore store,
  }) : super(value,
            autoDispose: autoDispose,
            debugLabel: debugLabel,
            key: key,
            store: store);

  @override
  Duration decode(String value) => Duration(milliseconds: int.parse(value));

  @override
  String encode(Duration value) => value.inMilliseconds.toString();
}
