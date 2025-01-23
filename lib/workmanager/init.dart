import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:signals/signals_flutter.dart';
import 'package:ttl_camera/state/deletion_method.dart';
import 'package:ttl_camera/state/global_state.dart';
import 'package:ttl_camera/workmanager/entry.dart';
import 'package:ttl_camera/workmanager/task.dart';
import 'package:ttl_camera/workmanager/tasks/check_deletion_images.dart';
import 'package:workmanager/workmanager.dart';

final Map<String, Task Function()> _taskFactories = {};

Task? getTaskById(String id) {
  final taskFactory = _taskFactories[id];
  if (taskFactory != null) {
    return taskFactory();
  }
  return null;
}

Future cancelTask(Task task) async {
  await Workmanager().cancelByUniqueName(task.id);
}

register(Task Function() factory) {
  _taskFactories[factory().id] = factory;
}

registerAll() {
  register(() => CheckDeletionImages());
}

Future initTasks() async {
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  if (GlobalState().isInitialized == false) {
    throw Exception("GlobalState is not initialized");
  }

  await Workmanager().cancelAll();
  final deletionEnabled = computed(() =>
      GlobalState().deletionMethod.signal.value ==
      DeletionMethod.deleteBackground);

  effect(() {
    if (!deletionEnabled.value) {
      cancelTask(CheckDeletionImages());
    }
  });

  effect(() {
    if (deletionEnabled.value) {
      Workmanager().registerPeriodicTask(
        CheckDeletionImages().id,
        CheckDeletionImages().id,
        initialDelay: Duration(seconds: 1),
        frequency: Duration(minutes: 15),
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    }
  });
}
