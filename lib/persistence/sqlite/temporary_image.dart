import 'package:floor/floor.dart';

@entity
class TemporaryImage {
  @primaryKey
  final String path;
  final DateTime deleteAt;
  TemporaryImage(this.path, this.deleteAt);
}
