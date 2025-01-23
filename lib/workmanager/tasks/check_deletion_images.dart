import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ttl_camera/persistence/sqlite/database.dart';
import 'package:ttl_camera/services/image_deletion_service.dart';
import 'package:ttl_camera/workmanager/entry.dart';
import 'package:ttl_camera/workmanager/task.dart';

class CheckDeletionImages implements Task {
  static const _id = "com.example.ttl_camera.check_deletion_images.v1";

  @override
  String get id => _id;

  @override
  Future<void> run() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final deletionService = ImageDeletionService(database);
    final deletionImages = await deletionService.getImagesDueForDeletion();
    if (deletionImages.isNotEmpty) {
      await deletionService.deleteAllDueImages();
      await notification(deletionImages.length);
    }
  }

  Future notification(int deletedCount) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      _id,
      _id,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, '$deletedCount images were deleted', '', platformChannelSpecifics);
  }
}
