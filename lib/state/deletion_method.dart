import 'package:signals/signals.dart';
import 'package:ttl_camera/persistence/shared_preferences.dart';
import 'package:ttl_camera/state/abstractions/persisted_enum_signal.dart';

enum DeletionMethod {
  deleteBackground,
  deleteInApp,
}

class DeletionMethodSignalHolder {
  final _deletionMethodSignal = PersistedEnumSignal<DeletionMethod>(
    value: DeletionMethod.deleteBackground,
    key: 'deletion_method_preference_v1',
    store: SharedPreferencesStore(),
    values: DeletionMethod.values,
  );
  late final ReadonlySignal<DeletionMethod> signal =
      _deletionMethodSignal.readonly();

  toggle(DeletionMethod method) {
    if (_deletionMethodSignal.value == method) {
      _deletionMethodSignal.value =
          DeletionMethod.values.firstWhere((element) => element != method);
      return;
    }
    _deletionMethodSignal.value = method;
  }

  Future<void> init() async {
    await _deletionMethodSignal.init();
  }
}
