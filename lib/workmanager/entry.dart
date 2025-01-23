import 'package:fluttertoast/fluttertoast.dart';
import 'package:ttl_camera/workmanager/init.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskId, inputData) async {
    try {
      registerAll();
      final taskInstance = getTaskById(taskId);
      if (taskInstance == null) {
        return Future.value(false);
      }
      await taskInstance.run();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}
