import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:ttl_camera/persistence/sqlite/database.dart';
import 'package:ttl_camera/persistence/sqlite/temporary_image.dart';
import 'package:ttl_camera/services/image_deletion_service.dart';
import 'package:ttl_camera/state/deletion_method.dart';
import 'package:ttl_camera/state/global_state.dart';
import 'package:ttl_camera/state/ttl_check.dart';
import 'package:ttl_camera/ui/deletion_modal_sheet.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GlobalImageNotificatoinModalService {
  late final ImageDeletionService _imageDeletionService;
  Timer? _checkDeletionTimer;
  bool _isDeletionDialogOpen = false;
  GlobalKey<NavigatorState>? _context;

  GlobalImageNotificatoinModalService(AppDatabase database) {
    _imageDeletionService = ImageDeletionService(database);
  }

  void init(GlobalKey<NavigatorState> navigatorKey) {
    _context = navigatorKey;
    effect(() async {
      print("runeff");
      if (GlobalState().deletionMethod.signal.value ==
          DeletionMethod.deleteInApp) {
        _checkDeletionTimer?.cancel();
        _checkDeletionTimer = await checkDeletion();
      } else {
        _checkDeletionTimer?.cancel();
      }
    });
  }

  Future<Timer> checkDeletion() async {
    final timer = Timer.periodic(ttlCheckInterval, (Timer timer) async {
      if (_isDeletionDialogOpen) return;
      var deletionItems = await _imageDeletionService.getImagesDueForDeletion();
      if (deletionItems.isEmpty) return;
      showDeletionDialog(deletionItems);
    });
    if (_isDeletionDialogOpen) return timer;
    var deletionItems = await _imageDeletionService.getImagesDueForDeletion();
    if (deletionItems.isNotEmpty) {
      showDeletionDialog(deletionItems);
    }
    return timer;
  }

  void showDeletionDialog([List<TemporaryImage>? deletionItems]) {
    print('Showing deletion dialog $_isDeletionDialogOpen');
    if (_isDeletionDialogOpen) return;
    _isDeletionDialogOpen = true;

    WoltModalSheet.show(
      barrierDismissible: true,
      showDragHandle: true,
      context: _context!.currentContext!,
      onModalDismissedWithBarrierTap: () {
        _isDeletionDialogOpen = false;
      },
      onModalDismissedWithDrag: () {
        _isDeletionDialogOpen = false;
      },
      pageListBuilder: (bottomSheetContext) => [
        DeletionModalSheet(
          deletionItems: deletionItems,
          onDelete: () async {
            await _imageDeletionService.deleteAllDueImages();
            Navigator.of(bottomSheetContext).pop();
            _isDeletionDialogOpen = false;
            print('Bottom sheet closed.');
          },
        ),
      ],
    );
  }
}
