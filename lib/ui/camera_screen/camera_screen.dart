import 'dart:async';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:ttl_camera/ui/deletion_modal_sheet.dart';
import 'package:ttl_camera/main.dart';
import 'package:ttl_camera/persistence/sqlite/database.dart';
import 'package:ttl_camera/persistence/sqlite/temporary_image.dart';
import 'package:ttl_camera/services/image_deletion_service.dart';
import 'package:ttl_camera/state/deletion_method.dart';
import 'package:ttl_camera/state/global_state.dart';
import 'package:ttl_camera/ui/camera_screen/timed_widget.dart';
import 'package:ttl_camera/ui/camera_screen/top_actions.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../state/ttl_check.dart';

class CameraScreen extends StatefulWidget {
  final AppDatabase database;

  const CameraScreen({super.key, required this.database});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
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
          final Directory tempDir = await getTemporaryDirectory();

          tempDir.createSync(recursive: true);
          if (sensors.length == 1) {
            final String filePath =
                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

            return SingleCaptureRequest(filePath, sensors.first);
          } else {
            return MultipleCaptureRequest(
              {
                for (final sensor in sensors)
                  sensor:
                      '$tempDir/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
              },
            );
          }
        },
      ),
      onMediaTap: (mediaCapture) async {
        final intent = AndroidIntent(
          action: 'com.android.camera.action.REVIEW',
          data: lastContentUri,
          flags: <int>[
            Flag.FLAG_ACTIVITY_CLEAR_TOP,
          ],
          arguments: <String, dynamic>{
            'windowTitle': 'Your Window Title', // Replace with actual title
            'mediaTypes': 1,
          },
        );
        intent.launch();
      },
      onMediaCaptureEvent: (event) async {
        switch (event.captureRequest) {
          case SingleCaptureRequest request:
            if (request.file != null) {
              final path = request.file!.path;
              final file = File(path);
              bool exists = await file.exists();
              print('File exists: $exists');
              if (!exists) return;
              var fileinfo = await mediaStorePlugin.saveFile(
                tempFilePath: path,
                dirName: DirName.pictures,
                dirType: DirType.photo,
              );
              lastContentUri = fileinfo!.uri.toString();
              final kkk = await mediaStorePlugin.getFilePathFromUri(
                  uriString: lastContentUri);
              print("handled file path uri: ${fileinfo!.uri.toString()}");
              var time =
                  DateTime.now().toUtc().add(GlobalState().ttl.ttlSignal.value);
              await widget.database.personDao
                  .insertTemporaryImage(TemporaryImage(kkk!, time));
            }
          case MultipleCaptureRequest _:
            break;
        }
      },
    );
  }
}

var lastContentUri = "";
