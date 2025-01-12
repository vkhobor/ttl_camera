import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:ttl_camera/ttl_button.dart';
import 'package:ttl_camera/app.dart';

class TopActions extends StatelessWidget {
  final CameraState state;

  final List<Widget> children;
  final EdgeInsets padding;

  TopActions({
    super.key,
    required this.state,
    List<Widget>? children,
    this.padding = const EdgeInsets.only(left: 30, right: 30, top: 16),
  }) : children = children ??
            (state is VideoRecordingCameraState
                ? [const SizedBox.shrink()]
                : [
                    AwesomeFlashButton(state: state),
                    if (state is PhotoCameraState)
                      AwesomeAspectRatioButton(state: state),
                    if (state is PhotoCameraState)
                      TtlButton(state: state, text: "ttl"),
                  ]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
