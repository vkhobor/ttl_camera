import 'package:floor/floor.dart';
import 'package:ttl_camera/persistence/sqlite/temporary_image.dart';

@dao
abstract class TemporaryImageDao {
  @Query('SELECT * FROM TemporaryImage')
  Future<List<TemporaryImage>> findAllTemporaryImages();

  @Query('SELECT * FROM TemporaryImage WHERE deleteAt < :now')
  Future<List<TemporaryImage>> findToDeleteTemporaryImages(DateTime now);

  @insert
  Future<void> insertTemporaryImage(TemporaryImage person);

  @delete
  Future<void> deleteTemporaryImage(TemporaryImage person);
}
