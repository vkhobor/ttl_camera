import 'dart:io';

import 'package:ttl_camera/persistence/sqlite/database.dart';
import 'package:ttl_camera/persistence/sqlite/temporary_image.dart';

class ImageDeletionService {
  final AppDatabase database;

  ImageDeletionService(this.database);

  Future<int> deleteAllDueImages() async {
    final deletionItems = await getImagesDueForDeletion();
    int deletedCount = 0;
    for (var item in deletionItems) {
      final path = item.path;
      final file = File(path);
      if (await file.exists()) {
        try {
          await file.delete();
          deletedCount++;
        } catch (e) {
          print('Failed to delete file: $path, error: $e');
        }
      }
      await database.personDao.deleteTemporaryImage(item);
    }
    return deletedCount;
  }

  Future<List<TemporaryImage>> getImagesDueForDeletion() async {
    return await database.personDao
        .findToDeleteTemporaryImages(DateTime.now().toUtc());
  }
}
