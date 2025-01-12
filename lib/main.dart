import 'package:flutter/material.dart';
import 'package:ttl_camera/database.dart';
import 'package:ttl_camera/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(MyApp2(database: database));
}

class MyApp2 extends StatelessWidget {
  final AppDatabase database;

  const MyApp2({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) => App(database: database),
          );
        },
      ),
    );
  }
}
