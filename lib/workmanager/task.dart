abstract class Task {
  Future<void> run();
  String get id;
}
