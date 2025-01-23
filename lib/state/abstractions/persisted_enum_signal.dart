import 'persisted_signal_base.dart';
import 'package:ttl_camera/persistence/key_value_store.dart';

class PersistedEnumSignal<T extends Enum> extends PersistedSignal<T> {
  final List<T> values;

  PersistedEnumSignal({
    required T value,
    bool autoDispose = true,
    String? debugLabel,
    required String key,
    required KeyValueStore store,
    required this.values,
  }) : super(value,
            autoDispose: autoDispose,
            debugLabel: debugLabel,
            key: key,
            store: store);

  @override
  T decode(String value) => values.firstWhere((e) => e.toString() == value);

  @override
  String encode(T value) => value.toString();
}
