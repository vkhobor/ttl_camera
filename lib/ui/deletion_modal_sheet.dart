import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:ttl_camera/persistence/sqlite/temporary_image.dart';

class DeletionModalSheet extends WoltModalSheetPage {
  DeletionModalSheet({
    required List<TemporaryImage>? deletionItems,
    required VoidCallback onDelete,
  }) : super(
          enableDrag: true,
          topBarTitle: const Text('Delete images'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 130),
            child: Text(
              '''${deletionItems?.length ?? 0} images are due for deletion. Would you like to delete them now?''',
            ),
          ),
          stickyActionBar: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 4),
            child: Column(
              children: [
                ShadButton(
                  onPressed: onDelete,
                  expands: true,
                  height: 50,
                  child: const Text('Delete them now'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
}
