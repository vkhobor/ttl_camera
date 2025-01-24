import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:ttl_camera/services/modal_service.dart';
import 'package:ttl_camera/ui/camera_screen/camera_screen.dart';
import 'package:ttl_camera/ui/settings_screen/settings_screen.dart';
import 'package:ttl_camera/persistence/sqlite/database.dart';
import 'package:ttl_camera/state/global_state.dart';
import 'package:ttl_camera/workmanager/init.dart';

final mediaStorePlugin = MediaStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MediaStore.ensureInitialized();
  MediaStore.appFolder = "TemporaryCamera";
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  await GlobalState().init();
  await initTasks();

  runApp(AppScaffold(database: database));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppScaffold extends StatefulWidget {
  final AppDatabase database;

  const AppScaffold({super.key, required this.database});

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late final GlobalImageNotificatoinModalService _modalService =
      GlobalImageNotificatoinModalService(widget.database);
  @override
  void initState() {
    super.initState();
    _modalService.init(navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return ShadApp.material(
      navigatorKey: navigatorKey,
      theme: ShadThemeData(
          colorScheme: ShadBlueColorScheme.dark(), brightness: Brightness.dark),
      materialThemeBuilder: (ctx, theme) => theme.copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: theme.colorScheme
            .copyWith(surface: Colors.black, surfaceContainer: Colors.black),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => CameraScreen(database: widget.database),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

enum SurfaceColorEnum {
  /// The lowest tone color that can be used as a background for a surface.
  surface,

  /// A slightly higher tone color that can be used for low-emphasis surfaces.
  surfaceContainerLowest,

  /// A higher tone color that can be used for medium-emphasis surfaces.
  surfaceContainerLow,

  /// A higher tone color that can be used for high-emphasis surfaces.
  surfaceContainer,

  /// A higher tone color that can be used for elevated surfaces, such as dialogs.
  surfaceContainerHigh,

  /// The highest tone color that can be used as a background for a surface.
  surfaceContainerHighest,
}

class NewSurfaceTheme {
  /// Returns the surface color based on the [selectedColor] and the current [Theme]
  /// in [context].
  ///
  /// [SurfaceColorEnum.surface] returns the surface color from the current theme.
  ///
  /// [SurfaceColorEnum.surfaceContainerLowest] to [SurfaceColorEnum.surfaceContainerHigh]
  /// return the surface color tinted based on the elevation, with increasing opacity.
  ///
  /// [SurfaceColorEnum.surfaceContainerHighest] returns the surface variant color from
  /// the current theme.
  static Color getSurfaceColor(
      SurfaceColorEnum selectedColor, ColorScheme colorScheme) {
    switch (selectedColor) {
      case SurfaceColorEnum.surface:
        return colorScheme.surface;
      case SurfaceColorEnum.surfaceContainerLowest:
        return Colors.black;
      case SurfaceColorEnum.surfaceContainerLow:
        return ElevationOverlay.applySurfaceTint(
          colorScheme.surface,
          colorScheme.surfaceTint,
          1,
        );
      case SurfaceColorEnum.surfaceContainer:
        return ElevationOverlay.applySurfaceTint(
          colorScheme.surface,
          colorScheme.surfaceTint,
          2,
        );
      case SurfaceColorEnum.surfaceContainerHigh:
        return ElevationOverlay.applySurfaceTint(
          colorScheme.surface,
          colorScheme.surfaceTint,
          3,
        );
      case SurfaceColorEnum.surfaceContainerHighest:
        return colorScheme.surfaceContainerHighest;
    }
  }
}
