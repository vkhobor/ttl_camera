// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:ttl_camera/persistence/sqlite/datetime_converter.dart';
import 'package:ttl_camera/persistence/sqlite/temporary_image.dart';
import 'package:ttl_camera/persistence/sqlite/temporary_image_dao.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [TemporaryImage])
abstract class AppDatabase extends FloorDatabase {
  TemporaryImageDao get personDao;
}
