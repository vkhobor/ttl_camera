import 'dart:async';
import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:signals/signals_flutter.dart';
import 'package:ttl_camera/database.dart';
import 'package:ttl_camera/top_actions.dart';
import 'package:ttl_camera/timed_widget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const ttl = Duration(days: 7);
final ttlSignal = signal(ttl);

const ttlCheckInterval = Duration(minutes: 2);

class App extends StatefulWidget {
  final AppDatabase database;

  const App({super.key, required this.database});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _recentlyProcessedFiles = <String>{};
  Future<List<TemporaryImage>> getDeletionItems() async {
    var allItems =
        await widget.database.select(widget.database.temporaryImages).get();
    var deletionItems = allItems
        .where((element) => element.deleteAt.isBefore(DateTime.now().toUtc()))
        .toList();
    print('Deletion items: ${deletionItems.length}');
    return deletionItems;
  }

  void asyncInit() async {
    Timer.periodic(ttlCheckInterval, (Timer timer) async {
      print('Checking for deletion items');
      var deletionItems = await getDeletionItems();
      if (deletionItems.isEmpty) return;
      showDeletionDialog(deletionItems);
    });

    var deletionItems = await getDeletionItems();
    if (deletionItems.isEmpty) return;
    showDeletionDialog(deletionItems);
  }

  void showDeletionDialog([List<TemporaryImage>? deletionItems]) {
    if (!mounted) return;
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
                    for (var item in deletionItems!) {
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
                '''${deletionItems?.length ?? 0} images are due for deletion. Would you like to delete them now?''',
              )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = widget.database;
    return CameraAwesomeBuilder.awesome(
      availableFilters: [],
      middleContentBuilder: (state) => SizedBox.shrink(),
      topActionsBuilder: (state) => TopActions(state: state),
      previewFit: CameraPreviewFit.contain,
      previewDecoratorBuilder: (state, preview) {
        switch (state) {
          case PhotoCameraState():
            final photoState = state as PhotoCameraState;
            return StreamBuilder<MediaCapture?>(
              stream: photoState.captureState$,
              builder: (context, snapshot) {
                if (snapshot.data?.status == MediaCaptureStatus.capturing) {
                  final rect = preview.rect;
                  final overlay = TimedWidget(
                    duration: const Duration(milliseconds: 100),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: Container(
                          width: rect.width,
                          height: rect.height,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  );
                  return overlay;
                }
                return const SizedBox.shrink();
              },
            );
        }
        return const SizedBox.shrink();
      },
      saveConfig: SaveConfig.photo(
        pathBuilder: (sensors) async {
          const testDirPath = '/storage/emulated/0/Pictures/tempImages';

          final testDir = Directory(testDirPath);
          await testDir.create(recursive: true);
          if (sensors.length == 1) {
            final String filePath =
                '$testDirPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

            return SingleCaptureRequest(filePath, sensors.first);
          } else {
            return MultipleCaptureRequest(
              {
                for (final sensor in sensors)
                  sensor:
                      '$testDirPath/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
              },
            );
          }
        },
      ),
      onMediaTap: (mediaCapture) {
        OpenFile.open(mediaCapture.captureRequest.path);
      },
      onMediaCaptureEvent: (event) async {
        switch (event.captureRequest) {
          case SingleCaptureRequest request:
            if (request.file != null) {
              final path = request.file!.path;
              if (_recentlyProcessedFiles.contains(path)) return;
              _recentlyProcessedFiles.add(path);
              var time = DateTime.now().toUtc().add(ttlSignal.value);
              await database.into(database.temporaryImages).insert(
                  TemporaryImagesCompanion.insert(
                      savedAt: path, deleteAt: time));

              Future.delayed(const Duration(seconds: 5), () {
                _recentlyProcessedFiles.remove(path);
              });
            }
          case MultipleCaptureRequest _:
            break;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    asyncInit();
  }
}
