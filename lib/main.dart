import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:ttl_camera/database.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();

  runApp(MyApp2(database: database));
}

const ttl = Duration(days: 7);

class MyApp extends StatefulWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  _MyAppState createState() => _MyAppState();
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
            builder: (context) => MyApp(database: database),
          );
        },
      ),
    );
  }
}

class _MyAppState extends State<MyApp> {
  void asyncInit() async {
    var allItems =
        await widget.database.select(widget.database.temporaryImages).get();
    var deletionItems = allItems
        .where((element) => element.deleteAt.isBefore(DateTime.now().toUtc()))
        .toList();
    if (deletionItems.isEmpty) {
      return;
    }
    WoltModalSheet.show(
      context: context,
      pageListBuilder: (bottomSheetContext) => [
        WoltModalSheetPage(
          stickyActionBar: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    for (var item in deletionItems) {
                      final path = item.savedAt;
                      final file = File(path);
                      if (file.existsSync()) {
                        file.deleteSync(); // Synchronous deletion
                        print('File deleted.');
                      } else {
                        print('File does not exist.');
                      }
                    }

                    var q = widget.database
                        .delete(widget.database.temporaryImages)
                      ..where((t) =>
                          t.savedAt.isIn(deletionItems.map((e) => e.savedAt)));
                    q.go();

                    print('Deleted ${deletionItems.length} items.');
                    Navigator.of(bottomSheetContext).pop();
                    print('Bottom sheet closed.');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 60),
                  ),
                  child: const SizedBox(
                    height: 20,
                    width: double.infinity,
                    child: Center(
                        child: Text('Delete them now',
                            style: TextStyle(color: Colors.black))),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 130),
              child: Text(
                '''${deletionItems.length} images are due for deletion. Would you like to delete them now?''',
              )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = widget.database;
    return CameraAwesomeBuilder.awesome(
      saveConfig: SaveConfig.photo(
        pathBuilder: (sensors) async {
          final testDir =
              await Directory('/storage/emulated/0/Pictures/tempImages')
                  .create(recursive: true);
          if (sensors.length == 1) {
            final String filePath =
                '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

            await database.into(database.temporaryImages).insert(
                TemporaryImagesCompanion.insert(
                    savedAt: filePath,
                    deleteAt: DateTime.now().toUtc().add(ttl)));

            return SingleCaptureRequest(filePath, sensors.first);
          } else {
            return MultipleCaptureRequest(
              {
                for (final sensor in sensors)
                  sensor:
                      '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
              },
            );
          }
        },
      ),
      onMediaTap: (mediaCapture) {
        OpenFile.open(mediaCapture.captureRequest.path);
      },
    );
  }

  @override
  void initState() {
    super.initState(); // Always call this first.
    asyncInit();
  }
}
