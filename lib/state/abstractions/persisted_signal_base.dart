import 'package:signals/signals_flutter.dart';
import 'package:ttl_camera/persistence/key_value_store.dart';
import 'persisted_signal_mixin.dart';

class PersistedSignal<T> extends FlutterSignal<T> with PersistedSignalMixin<T> {
  PersistedSignal(
    super.internalValue, {
    super.autoDispose,
    super.debugLabel,
    required this.key,
    required this.store,
  });

  @override
  final String key;

  @override
  final KeyValueStore store;
}
