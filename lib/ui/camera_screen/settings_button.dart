import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/src/widgets/utils/awesome_circle_icon.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final AwesomeTheme? theme;

  SettingsButton({
    super.key,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? AwesomeThemeProvider.of(context).theme;
    return AwesomeOrientedWidget(
      rotateWithDevice: theme.buttonTheme.rotateWithCamera,
      child: theme.buttonTheme.buttonBuilder(
        AwesomeCircleWidget.icon(
          icon: Icons.settings,
          theme: theme,
        ),
        () => Navigator.pushNamed(context, '/settings'),
      ),
    );
  }
}
