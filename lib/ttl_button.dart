import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:ttl_camera/app.dart';

class TtlButton extends StatelessWidget {
  final PhotoCameraState state;
  final AwesomeTheme? theme;
  final Widget Function(String text) textBuilder;
  final void Function(PhotoCameraState state, String text) onTextTap;
  final String text;

  static const _ttlOptions = [
    Duration(minutes: 1),
    Duration(minutes: 10),
    Duration(hours: 1),
    Duration(hours: 12),
    Duration(hours: 24),
    Duration(days: 3),
    Duration(days: 7),
  ];

  static String _formatDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d';
    if (d.inHours > 0) return '${d.inHours}h';
    return '${d.inMinutes}m';
  }

  TtlButton({
    super.key,
    required this.state,
    required this.text,
    this.theme,
    Widget Function(String text)? textBuilder,
    void Function(PhotoCameraState state, String text)? onTextTap,
  })  : textBuilder = textBuilder ??
            ((text) {
              return Watch((context) {
                return Text(
                  'TTL: ${_formatDuration(ttlSignal.value)}',
                  style: TextStyle(
                    color: theme?.buttonTheme.foregroundColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                  ),
                );
              });
            }),
        onTextTap = onTextTap ??
            ((state, text) {
              final currentIndex = _ttlOptions.indexOf(ttlSignal.value);
              final nextIndex = (currentIndex + 1) % _ttlOptions.length;
              ttlSignal.value = _ttlOptions[nextIndex];
            });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? AwesomeThemeProvider.of(context).theme;

    return AwesomeOrientedWidget(
      rotateWithDevice: theme.buttonTheme.rotateWithCamera,
      child: theme.buttonTheme.buttonBuilder(
        textBuilder(text),
        () => onTextTap(state, text),
      ),
    );
  }
}
