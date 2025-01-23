import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:ttl_camera/state/global_state.dart';

class TtlButton extends StatelessWidget {
  final PhotoCameraState state;
  final AwesomeTheme? theme;

  static String _formatDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d';
    if (d.inHours > 0) return '${d.inHours}h';
    return '${d.inMinutes}m';
  }

  final readableTtlDuration =
      computed(() => _formatDuration(GlobalState().ttl.ttlSignal.value));

  TtlButton({
    super.key,
    required this.state,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? AwesomeThemeProvider.of(context).theme;

    return AwesomeOrientedWidget(
      rotateWithDevice: theme.buttonTheme.rotateWithCamera,
      child: theme.buttonTheme.buttonBuilder(
        Watch((context) {
          return Text(
            'TTL: $readableTtlDuration',
            style: TextStyle(
              color: theme.buttonTheme.foregroundColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              fontSize: 16,
              fontFamily: 'Roboto',
            ),
          );
        }),
        () => GlobalState().ttl.nextTtlOption(),
      ),
    );
  }
}
